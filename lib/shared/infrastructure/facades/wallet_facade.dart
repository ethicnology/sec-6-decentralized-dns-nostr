import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39_mnemonic/bip39_mnemonic.dart';
import 'package:bip32_keys/bip32_keys.dart';
import 'package:coinlib/coinlib.dart' as coinlib;
import 'package:drift/drift.dart' show Value;
import 'package:namecoin/namecoin.dart' as nmc;
import 'package:nostr_namecoin/shared/infrastructure/database/app_database.dart';
import 'package:nostr_namecoin/shared/infrastructure/facades/electrum_facade.dart';

final _namecoinNetwork = coinlib.Network(
  wifPrefix: 0xb4,
  p2pkhPrefix: 0x34,
  p2shPrefix: 0x0d,
  privHDPrefix: 0x0488ade4,
  pubHDPrefix: 0x0488b21e,
  bech32Hrp: 'nc',
  messagePrefix: '\x18Namecoin Signed Message:\n',
  minFee: BigInt.from(5000),
  minOutput: BigInt.from(1000),
  feePerKb: BigInt.from(100000),
);

final _namecoinBip32Network = NetworkType(
  wif: 0xb4,
  bip32: Bip32Type(public: 0x0488b21e, private: 0x0488ade4),
);

/// BIP44 derivation path for Namecoin legacy P2PKH (coin type 7)
const _accountPath = "m/44'/7'/0'";
const _gapLimit = 20;

class WalletFacade {
  final ElectrumFacade _electrumFacade;
  final AppDatabase _db;

  Mnemonic? _mnemonic;
  Bip32Keys? _accountKey;

  int _receiveIndex = 0;
  int _changeIndex = 0;
  int? _oldestKnownBlock;

  int? get oldestKnownBlock => _oldestKnownBlock;

  WalletFacade(this._electrumFacade, this._db);

  bool get hasMnemonic => _mnemonic != null;

  String generateMnemonic() {
    _mnemonic = Mnemonic.generate(Language.english);
    _deriveAccountKey();
    return _mnemonic!.sentence;
  }

  void importMnemonic(String sentence) {
    _mnemonic = Mnemonic.fromSentence(sentence, Language.english);
    _deriveAccountKey();
  }

  void _deriveAccountKey() {
    final seed = Uint8List.fromList(_mnemonic!.seed);
    final root = Bip32Keys.fromSeed(seed, network: _namecoinBip32Network);
    _accountKey = root.derivePath(_accountPath);
    _receiveIndex = 0;
    _changeIndex = 0;
  }

  // Key derivation — all P2PKH

  Bip32Keys _deriveKey(int chain, int index) {
    if (_accountKey == null) throw StateError('No mnemonic loaded');
    return _accountKey!.derive(chain).derive(index);
  }

  coinlib.ECPrivateKey _privateKeyFromBip32(Bip32Keys key) {
    if (key.private == null) throw StateError('No private key');
    return coinlib.ECPrivateKey(key.private!);
  }

  String _addressFromKey(Bip32Keys key) {
    final pubkey = coinlib.ECPublicKey(key.public);
    return coinlib.P2PKHAddress.fromPublicKey(
      pubkey,
      version: _namecoinNetwork.p2pkhPrefix,
    ).toString();
  }

  String getNextReceiveAddress() {
    final addr = _addressFromKey(_deriveKey(0, _receiveIndex));
    _receiveIndex++;
    return addr;
  }

  String getNextChangeAddress() {
    final addr = _addressFromKey(_deriveKey(1, _changeIndex));
    _changeIndex++;
    return addr;
  }

  // Scanning — batched with Future.wait

  /// Scan a chain (receive=0, change=1) using batched concurrent requests.
  /// Returns addresses with history entries for tx history extraction.
  Future<List<({
    String address, String scriptHash, String path,
    int chain, int index, List<dynamic> history,
  })>> _scanChain(int chain) async {
    final chainName = chain == 0 ? 'receive' : 'change';
    // ignore: avoid_print
    print('[scan] scanning $chainName chain (batched)...');

    final results = <({
      String address, String scriptHash, String path,
      int chain, int index, List<dynamic> history,
    })>[];
    int consecutiveEmpty = 0;
    int batchStart = 0;

    while (consecutiveEmpty < _gapLimit) {
      final batchSize = _gapLimit - consecutiveEmpty;

      // Derive batch of addresses + script hashes
      final batch = List.generate(batchSize, (i) {
        final idx = batchStart + i;
        final key = _deriveKey(chain, idx);
        final address = _addressFromKey(key);
        final scriptHash = _scriptHashFromAddress(
          coinlib.Address.fromString(address, _namecoinNetwork),
        );
        return (index: idx, address: address, scriptHash: scriptHash);
      });

      // Fire all get_history concurrently
      final futures = batch.map((b) => _electrumFacade.request(
        'blockchain.scripthash.get_history',
        [b.scriptHash],
      ));
      final responses = await Future.wait(futures);

      // Process results, track gap
      for (var i = 0; i < batch.length; i++) {
        final history = responses[i] as List<dynamic>;
        results.add((
          address: batch[i].address,
          scriptHash: batch[i].scriptHash,
          path: "$_accountPath/$chain/${batch[i].index}",
          chain: chain,
          index: batch[i].index,
          history: history,
        ));

        if (history.isNotEmpty) {
          consecutiveEmpty = 0;
        } else {
          consecutiveEmpty++;
        }
        if (consecutiveEmpty >= _gapLimit) break;
      }
      batchStart += batch.length;
    }

    final usedCount = results.where((r) => r.history.isNotEmpty).length;
    // ignore: avoid_print
    print('[scan] $chainName done. $usedCount used addresses (${results.length} scanned, batched).');
    return results;
  }

  Future<List<({String address, String path, int balance, int utxoCount, bool isChange})>>
      getAddresses() async {
    final receiveAddrs = await _scanChain(0);
    final changeAddrs = await _scanChain(1);

    final used = [
      ...receiveAddrs.where((a) => a.history.isNotEmpty),
      ...changeAddrs.where((a) => a.history.isNotEmpty),
    ];

    // Batch fetch UTXOs for all used addresses concurrently
    // ignore: avoid_print
    print('[sync] fetching UTXOs for ${used.length} addresses (batched)...');
    final utxoFutures = used.map((a) => _electrumFacade.request(
      'blockchain.scripthash.listunspent',
      [a.scriptHash],
    ));
    final utxoResponses = await Future.wait(utxoFutures);

    final result =
        <({String address, String path, int balance, int utxoCount, bool isChange})>[];
    for (var i = 0; i < used.length; i++) {
      final utxoList = utxoResponses[i] as List<dynamic>;
      final balance =
          utxoList.fold<int>(0, (sum, u) => sum + (u['value'] as int));
      result.add((
        address: used[i].address,
        path: used[i].path,
        balance: balance,
        utxoCount: utxoList.length,
        isChange: used[i].chain == 1,
      ));
    }

    final usedReceive = receiveAddrs.where((a) => a.history.isNotEmpty).length;
    final usedChange = changeAddrs.where((a) => a.history.isNotEmpty).length;
    if (usedReceive >= _receiveIndex) _receiveIndex = usedReceive;
    if (usedChange >= _changeIndex) _changeIndex = usedChange;

    return result;
  }

  Future<List<({String txid, int vout, int value, String address})>>
      getAllUtxos() async {
    // Read from DB (populated by last syncAll)
    final dbUtxos = await _db.getAllUtxos();
    if (dbUtxos.isNotEmpty) {
      return dbUtxos
          .map((u) =>
              (txid: u.txid, vout: u.vout, value: u.value, address: u.address))
          .toList();
    }
    // Fallback: if DB is empty, do a full sync
    final sync = await syncAll();
    return sync.utxos;
  }

  Future<int> getTotalBalance() async {
    final dbUtxos = await _db.getAllUtxos();
    if (dbUtxos.isNotEmpty) {
      return dbUtxos.fold<int>(0, (sum, u) => sum + u.value);
    }
    final utxos = await getAllUtxos();
    return utxos.fold<int>(0, (sum, u) => sum + u.value);
  }

  Future<List<({String txid, int height})>> getTransactionHistory() async {
    final dbHistory = await _db.getTransactionHistorySorted();
    if (dbHistory.isNotEmpty) {
      return dbHistory
          .map((t) => (txid: t.txid, height: t.height))
          .toList();
    }
    // Fallback: if DB is empty, do a full sync
    final sync = await syncAll();
    return sync.transactions;
  }

  /// Sync everything in one pass — batched requests, no duplicates.
  /// Scan addresses → batch UTXOs → extract tx history from scan data.
  Future<({
    List<({String address, String path, int balance, int utxoCount, bool isChange})> addresses,
    List<({String txid, int vout, int value, String address})> utxos,
    int totalBalance,
    List<({String txid, int height})> transactions,
  })> syncAll() async {
    // ignore: avoid_print
    print('[syncAll] starting (batched)...');
    final sw = Stopwatch()..start();

    // 1. Scan both chains (batched get_history)
    final receiveAddrs = await _scanChain(0);
    final changeAddrs = await _scanChain(1);

    final used = [
      ...receiveAddrs.where((a) => a.history.isNotEmpty),
      ...changeAddrs.where((a) => a.history.isNotEmpty),
    ];

    // Update indices
    final usedReceive = receiveAddrs.where((a) => a.history.isNotEmpty).length;
    final usedChange = changeAddrs.where((a) => a.history.isNotEmpty).length;
    if (usedReceive >= _receiveIndex) _receiveIndex = usedReceive;
    if (usedChange >= _changeIndex) _changeIndex = usedChange;

    // 2. Batch fetch UTXOs for all used addresses
    // ignore: avoid_print
    print('[syncAll] batch fetching UTXOs for ${used.length} addresses...');
    final utxoFutures = used.map((a) => _electrumFacade.request(
      'blockchain.scripthash.listunspent',
      [a.scriptHash],
    ));
    final utxoResponses = await Future.wait(utxoFutures);

    // Build address summaries + raw UTXO list
    final addresses =
        <({String address, String path, int balance, int utxoCount, bool isChange})>[];
    final utxos = <({String txid, int vout, int value, String address})>[];

    for (var i = 0; i < used.length; i++) {
      final utxoList = utxoResponses[i] as List<dynamic>;
      final balance =
          utxoList.fold<int>(0, (sum, u) => sum + (u['value'] as int));
      addresses.add((
        address: used[i].address,
        path: used[i].path,
        balance: balance,
        utxoCount: utxoList.length,
        isChange: used[i].chain == 1,
      ));
      for (final u in utxoList) {
        utxos.add((
          txid: u['tx_hash'] as String,
          vout: u['tx_pos'] as int,
          value: u['value'] as int,
          address: used[i].address,
        ));
      }
    }

    final totalBalance = utxos.fold<int>(0, (sum, u) => sum + u.value);

    // 3. Extract tx history from scan data (already fetched, no extra requests!)
    final txSet = <String, int>{};
    for (final addr in used) {
      for (final tx in addr.history) {
        txSet[tx['tx_hash'] as String] = tx['height'] as int;
      }
    }

    if (txSet.isNotEmpty) {
      final confirmed = txSet.values.where((h) => h > 0);
      if (confirmed.isNotEmpty) {
        _oldestKnownBlock = confirmed.reduce((a, b) => a < b ? a : b);
      }
    }

    final sortedTxs = txSet.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final transactions =
        sortedTxs.map((e) => (txid: e.key, height: e.value)).toList();

    // 4. Persist to database
    final addressEntries = <AddressesCompanion>[];
    for (final r in [...receiveAddrs, ...changeAddrs]) {
      addressEntries.add(AddressesCompanion(
        address: Value(r.address),
        chain: Value(r.chain),
        indexColumn: Value(r.index),
        derivationPath: Value(r.path),
        scriptHash: Value(r.scriptHash),
        hasHistory: Value(r.history.isNotEmpty),
        lastSyncAt: Value(DateTime.now()),
      ));
    }
    await _db.upsertAddresses(addressEntries);

    for (var i = 0; i < used.length; i++) {
      final utxoList = utxoResponses[i] as List<dynamic>;
      final utxoEntries = utxoList
          .map((u) => UtxosCompanion(
                txid: Value(u['tx_hash'] as String),
                vout: Value(u['tx_pos'] as int),
                value: Value(u['value'] as int),
                address: Value(used[i].address),
              ))
          .toList();
      await _db.replaceUtxosForAddress(used[i].address, utxoEntries);
    }

    final historyEntries = sortedTxs
        .map((e) => TransactionHistoryCompanion(
              txid: Value(e.key),
              height: Value(e.value),
            ))
        .toList();
    await _db.replaceTransactionHistory(historyEntries);

    // Restore indices from DB in case of app restart
    final maxReceive = await _db.getMaxUsedIndex(0);
    final maxChange = await _db.getMaxUsedIndex(1);
    if (maxReceive + 1 > _receiveIndex) _receiveIndex = maxReceive + 1;
    if (maxChange + 1 > _changeIndex) _changeIndex = maxChange + 1;

    sw.stop();
    // ignore: avoid_print
    print('[syncAll] done in ${sw.elapsedMilliseconds}ms. '
        '${addresses.length} addrs, ${utxos.length} utxos, '
        '$totalBalance sats, ${transactions.length} txs.');

    return (
      addresses: addresses,
      utxos: utxos,
      totalBalance: totalBalance,
      transactions: transactions,
    );
  }

  /// Sweep funds from BIP84 (segwit nc1q...) to BIP44 (legacy N...) addresses.
  /// One-time migration when switching from segwit to legacy wallet.
  Future<String> sweepFromBip84() async {
    if (_mnemonic == null) throw StateError('No mnemonic loaded');

    final seed = Uint8List.fromList(_mnemonic!.seed);
    final root = Bip32Keys.fromSeed(seed, network: _namecoinBip32Network);
    final bip84Account = root.derivePath("m/84'/7'/0'");

    // Scan BIP84 receive+change chains for UTXOs
    final segwitUtxos =
        <({String txid, int vout, int value, coinlib.ECPrivateKey key})>[];

    for (var chain = 0; chain <= 1; chain++) {
      int consecutiveEmpty = 0;
      for (var i = 0; consecutiveEmpty < _gapLimit; i++) {
        final key = bip84Account.derive(chain).derive(i);
        final pubkey = coinlib.ECPublicKey(key.public);
        final addr = coinlib.P2WPKHAddress.fromPublicKey(
          pubkey,
          hrp: _namecoinNetwork.bech32Hrp,
        );
        final scriptHash = _scriptHashFromAddress(addr);
        final utxoResult = await _electrumFacade.request(
          'blockchain.scripthash.listunspent',
          [scriptHash],
        );
        final utxoList = utxoResult as List<dynamic>;
        if (utxoList.isEmpty) {
          consecutiveEmpty++;
          continue;
        }
        consecutiveEmpty = 0;
        final privkey = coinlib.ECPrivateKey(key.private!);
        for (final u in utxoList) {
          segwitUtxos.add((
            txid: u['tx_hash'] as String,
            vout: u['tx_pos'] as int,
            value: u['value'] as int,
            key: privkey,
          ));
        }
      }
    }

    if (segwitUtxos.isEmpty) {
      throw StateError('No BIP84 segwit UTXOs found to sweep');
    }

    // Build a simple send-all tx to the current BIP44 receive address
    final destAddr = getNextReceiveAddress();
    final destProgram = coinlib.Address.fromString(
      destAddr,
      _namecoinNetwork,
    ).program;

    final inputs = <coinlib.InputCandidate>[];
    final keys = <coinlib.ECPrivateKey>[];
    final values = <BigInt>[];

    for (final u in segwitUtxos) {
      inputs.add(coinlib.InputCandidate(
        input: coinlib.P2WPKHInput(
          prevOut: coinlib.OutPoint.fromHex(u.txid, u.vout),
          publicKey: u.key.pubkey,
        ),
        value: BigInt.from(u.value),
      ));
      keys.add(u.key);
      values.add(BigInt.from(u.value));
    }

    final totalValue =
        segwitUtxos.fold<int>(0, (sum, u) => sum + u.value);
    final fee = 11500;
    final sendValue = totalValue - fee;
    if (sendValue <= 0) throw StateError('Insufficient funds to sweep');

    final output = coinlib.Output.fromProgram(
      BigInt.from(sendValue),
      destProgram,
    );

    var tx = coinlib.Transaction(
      version: 2,
      inputs: inputs.map((c) => c.input).toList(),
      outputs: [output],
    );

    for (var i = 0; i < inputs.length; i++) {
      tx = tx.signLegacyWitness(
        inputN: i,
        key: keys[i],
        value: values[i],
      );
    }

    final txHex = tx.toHex();
    return broadcastTx(txHex);
  }

  // Transaction building — all P2PKH, all signLegacy

  Future<({String txHex, String saltHex, String commitmentHex})>
      buildNameNewTx(String name) async {
    final (scriptHex, saltHex, commitmentHex) = nmc.scriptNameNew(name);
    final txHex = await _buildNameTx(scriptHex);
    return (txHex: txHex, saltHex: saltHex, commitmentHex: commitmentHex);
  }

  Future<String> buildNameFirstUpdateTx(
      String name, String value, String saltHex) async {
    final scriptHex = nmc.scriptNameFirstUpdate(name, value, saltHex);
    return _buildNameTxWithNameInput(scriptHex, name, saltHex: saltHex);
  }

  Future<String> buildNameUpdateTx(String name, String value) async {
    final scriptHex = nmc.scriptNameUpdate(name, value);
    return _buildNameTxWithNameInput(scriptHex, name);
  }

  /// Ensure DB has UTXOs. If empty, trigger a full sync first.
  Future<void> _ensureDbPopulated() async {
    final dbUtxos = await _db.getAllUtxos();
    // ignore: avoid_print
    print('[db] DB has ${dbUtxos.length} UTXOs');
    if (dbUtxos.isEmpty) {
      // ignore: avoid_print
      print('[db] DB empty, running syncAll to populate...');
      await syncAll();
      final afterSync = await _db.getAllUtxos();
      // ignore: avoid_print
      print('[db] after sync: ${afterSync.length} UTXOs');
    }
  }

  /// Ensure all UTXOs in DB have their nameOp status classified.
  /// Fetches tx data for unchecked UTXOs, caches it, and marks isNameUtxo.
  Future<void> _enrichUtxoNameStatus() async {
    final unchecked = await _db.getUncheckedUtxos();
    // ignore: avoid_print
    print('[enrich] ${unchecked.length} unchecked UTXOs');
    if (unchecked.isEmpty) {
      // Log current DB state for debugging
      final allUtxos = await _db.getAllUtxos();
      final nameUtxos =
          allUtxos.where((u) => u.isNameUtxo == true).toList();
      final nonName =
          allUtxos.where((u) => u.isNameUtxo == false).toList();
      // ignore: avoid_print
      print('[enrich] DB state: ${allUtxos.length} total, '
          '${nameUtxos.length} name, ${nonName.length} non-name');
      for (final u in nameUtxos) {
        // ignore: avoid_print
        print('[enrich]   name UTXO: ${u.txid}:${u.vout} '
            'type=${u.nameOpType} hash=${u.nameOpHash} name=${u.nameOpName}');
      }
      return;
    }

    // ignore: avoid_print
    print('[enrich] classifying ${unchecked.length} unchecked UTXOs...');

    // Deduplicate txids
    final txidsToFetch = unchecked.map((u) => u.txid).toSet();

    // Check cache first
    final cached = await _db.getCachedTransactions(txidsToFetch.toList());
    final cachedMap = {for (final c in cached) c.txid: c.rawJson};
    final uncachedTxids =
        txidsToFetch.where((id) => !cachedMap.containsKey(id)).toList();

    // Batch fetch uncached transactions
    if (uncachedTxids.isNotEmpty) {
      // ignore: avoid_print
      print('[enrich] fetching ${uncachedTxids.length} txs from Electrum...');
      final fetchFutures = uncachedTxids.map((txid) async {
        final data = await _electrumFacade.getTransaction(txid);
        final json = jsonEncode(data);
        await _db.cacheTransaction(txid, json, 0);
        return (txid: txid, json: json);
      });
      final fetched = await Future.wait(fetchFutures);
      for (final f in fetched) {
        cachedMap[f.txid] = f.json;
      }
    }

    // Classify each unchecked UTXO
    for (final utxo in unchecked) {
      final txData =
          jsonDecode(cachedMap[utxo.txid]!) as Map<String, dynamic>;
      final voutData = (txData['vout'] as List<dynamic>)[utxo.vout];
      final nameOp = voutData['scriptPubKey']?['nameOp'];

      if (nameOp == null) {
        // ignore: avoid_print
        print('[enrich]   ${utxo.txid}:${utxo.vout} -> non-name');
        await _db.markUtxoNameStatus(
            txid: utxo.txid, vout: utxo.vout, isName: false);
      } else {
        // ignore: avoid_print
        print('[enrich]   ${utxo.txid}:${utxo.vout} -> '
            '${nameOp['op']} hash=${nameOp['hash']} name=${nameOp['name']}');
        await _db.markUtxoNameStatus(
          txid: utxo.txid,
          vout: utxo.vout,
          isName: true,
          opType: nameOp['op'] as String?,
          opHash: nameOp['hash'] as String?,
          opName: nameOp['name'] as String?,
          opValue: nameOp['value'] as String?,
        );
      }
    }
    // ignore: avoid_print
    print('[enrich] done.');
  }

  /// Get cached tx data or fetch from Electrum and cache.
  Future<Map<String, dynamic>> _getCachedOrFetchTx(String txid) async {
    final cached = await _db.getCachedTransaction(txid);
    if (cached != null) {
      return jsonDecode(cached.rawJson) as Map<String, dynamic>;
    }
    final data = await _electrumFacade.getTransaction(txid);
    await _db.cacheTransaction(txid, jsonEncode(data), 0);
    return data;
  }

  /// Lookup key for an address using DB index, falling back to brute-force.
  Future<coinlib.ECPrivateKey> _findKeyForAddressAsync(String address) async {
    final record = await _db.getAddressByString(address);
    if (record != null) {
      return _privateKeyFromBip32(
          _deriveKey(record.chain, record.indexColumn));
    }
    // Fallback: brute-force (should not happen after sync)
    final searchLimit = _receiveIndex + _gapLimit + 50;
    for (var chain = 0; chain <= 1; chain++) {
      for (var i = 0; i < searchLimit; i++) {
        final key = _deriveKey(chain, i);
        if (_addressFromKey(key) == address) {
          return _privateKeyFromBip32(key);
        }
      }
    }
    throw StateError('Key not found for address: $address');
  }

  /// Build name_new tx (no previous name input needed).
  /// Uses DB-cached UTXO classification to avoid per-UTXO getTransaction calls.
  Future<String> _buildNameTx(String nameScriptHex) async {
    final nameOpBytes = coinlib.hexToBytes(nameScriptHex);

    // Ensure DB is populated, then classify all UTXOs
    await _ensureDbPopulated();
    await _enrichUtxoNameStatus();

    // Read non-name UTXOs from DB
    final nonNameUtxos = await _db.getNonNameUtxos();
    if (nonNameUtxos.isEmpty) throw StateError('No non-name UTXOs available');

    // Name output: name_op + P2PKH
    final nameKey = _deriveKey(0, _receiveIndex);
    _receiveIndex++;
    final namePubkey = coinlib.ECPublicKey(nameKey.public);
    final p2pkh = coinlib.P2PKH.fromPublicKey(namePubkey).script.compiled;
    final fullScript = Uint8List(nameOpBytes.length + p2pkh.length);
    fullScript.setAll(0, nameOpBytes);
    fullScript.setAll(nameOpBytes.length, p2pkh);

    final inputs = <coinlib.InputCandidate>[];
    final keys = <coinlib.ECPrivateKey>[];

    for (final u in nonNameUtxos) {
      final key = await _findKeyForAddressAsync(u.address);
      inputs.add(coinlib.InputCandidate(
        input: coinlib.P2PKHInput(
          prevOut: coinlib.OutPoint.fromHex(u.txid, u.vout),
          publicKey: key.pubkey,
        ),
        value: BigInt.from(u.value),
      ));
      keys.add(key);
    }

    final nameOutput = coinlib.Output.fromScriptBytes(
      BigInt.from(1000000),
      fullScript,
    );

    final changeKey = _deriveKey(1, _changeIndex);
    _changeIndex++;
    final changeProgram = coinlib.P2PKH.fromPublicKey(
      coinlib.ECPublicKey(changeKey.public),
    );

    final coinSelection = coinlib.CoinSelection(
      version: 0x7100,
      selected: inputs,
      recipients: [nameOutput],
      changeProgram: changeProgram,
      feePerKb: _namecoinNetwork.feePerKb,
      minFee: _namecoinNetwork.minFee,
      minChange: _namecoinNetwork.minOutput,
    );

    var tx = coinSelection.transaction;
    for (var i = 0; i < tx.inputs.length; i++) {
      tx = tx.signLegacy(inputN: i, key: keys[i]);
    }
    return tx.toHex();
  }

  /// Build name_firstupdate or name_update tx (must spend previous name UTXO).
  /// Uses DB for UTXO lookup, tx data caching, and key derivation.
  Future<String> _buildNameTxWithNameInput(
      String nameScriptHex, String name, {String? saltHex}) async {
    // ignore: avoid_print
    print('[nameTx] building tx for: $name (salt: $saltHex)');
    final nameOpBytes = coinlib.hexToBytes(nameScriptHex);

    // Ensure DB is populated, then classify all UTXOs
    await _ensureDbPopulated();
    await _enrichUtxoNameStatus();

    // Find the previous name UTXO
    String? nameTxHash;
    int? nameVout;

    if (saltHex != null) {
      // name_firstupdate: compute expected commitment, find matching name_new
      final saltBytes = coinlib.hexToBytes(saltHex);
      final nameBytes = ascii.encode(name);
      final combined = Uint8List.fromList(saltBytes + nameBytes);
      final expectedCommitment = coinlib.bytesToHex(
        coinlib.hash160(combined),
      );
      // ignore: avoid_print
      print('[nameTx] expected commitment: $expectedCommitment');

      // Try DB lookup first
      final dbUtxo = await _db.getNameNewUtxoByCommitment(expectedCommitment);
      if (dbUtxo != null) {
        nameTxHash = dbUtxo.txid;
        nameVout = dbUtxo.vout;
        // ignore: avoid_print
        print('[nameTx] found name_new in DB: $nameTxHash:$nameVout');
      }
    }

    // For name_update (no salt) or if DB didn't have it: try Electrum name script hash
    if (nameTxHash == null) {
      final nameScriptHash = nmc.nameIdentifierToScriptHash(name);
      final nameHistory = await _electrumFacade.request(
        'blockchain.scripthash.get_history',
        [nameScriptHash],
      );
      if ((nameHistory as List<dynamic>).isNotEmpty) {
        nameTxHash = nameHistory.last['tx_hash'] as String;
        // ignore: avoid_print
        print('[nameTx] found via name script hash: $nameTxHash');
      }
    }

    // Last resort: scan all name_new UTXOs from DB
    if (nameTxHash == null && saltHex != null) {
      // ignore: avoid_print
      print('[nameTx] scanning DB UTXOs for name_new...');
      final allDbUtxos = await _db.getAllUtxos();
      for (final u in allDbUtxos) {
        if (u.isNameUtxo == true && u.nameOpType == 'name_new') {
          // ignore: avoid_print
          print('[nameTx] found name_new: ${u.txid}:${u.vout} (hash: ${u.nameOpHash})');
          final saltBytes = coinlib.hexToBytes(saltHex);
          final nameBytes = ascii.encode(name);
          final combined = Uint8List.fromList(saltBytes + nameBytes);
          final expected = coinlib.bytesToHex(
            coinlib.hash160(combined),
          );
          if (u.nameOpHash == expected) {
            nameTxHash = u.txid;
            nameVout = u.vout;
            // ignore: avoid_print
            print('[nameTx] MATCH by salt commitment!');
            break;
          }
        }
      }
    }

    if (nameTxHash == null) {
      // Dump full DB state for debugging
      final allDbUtxos2 = await _db.getAllUtxos();
      // ignore: avoid_print
      print('[nameTx] FAILED! Dumping all ${allDbUtxos2.length} DB UTXOs:');
      for (final u in allDbUtxos2) {
        // ignore: avoid_print
        print('[nameTx]   ${u.txid}:${u.vout} val=${u.value} '
            'isName=${u.isNameUtxo} type=${u.nameOpType} '
            'hash=${u.nameOpHash} name=${u.nameOpName} addr=${u.address}');
      }
      throw StateError('No matching name UTXO found for: $name');
    }
    // ignore: avoid_print
    print('[nameTx] using: $nameTxHash:$nameVout');

    // Get tx data (from cache or Electrum)
    final nameTxData = await _getCachedOrFetchTx(nameTxHash);
    final vouts = nameTxData['vout'] as List<dynamic>;

    // Find which output has the name op
    BigInt? nameValue;
    String? nameOutputScriptHex;
    if (nameVout != null) {
      // Already know the vout from DB lookup
      final v = vouts[nameVout]['value'];
      if (v is num) nameValue = BigInt.from((v * 100000000).round());
      nameOutputScriptHex =
          vouts[nameVout]['scriptPubKey']['hex'] as String;
    } else {
      for (var i = 0; i < vouts.length; i++) {
        if (vouts[i]['scriptPubKey']?['nameOp'] != null) {
          nameVout = i;
          final v = vouts[i]['value'];
          if (v is num) nameValue = BigInt.from((v * 100000000).round());
          nameOutputScriptHex = vouts[i]['scriptPubKey']['hex'] as String;
          break;
        }
      }
    }
    if (nameVout == null || nameValue == null || nameOutputScriptHex == null) {
      throw StateError('No name output in tx $nameTxHash');
    }

    // Find the key that owns the name output
    final p2pkhIdx = nameOutputScriptHex.indexOf('76a914');
    if (p2pkhIdx == -1) throw StateError('Name output not P2PKH');
    final pubkeyHashHex =
        nameOutputScriptHex.substring(p2pkhIdx + 6, p2pkhIdx + 46);

    // Try DB lookup for key by matching address from pubkey hash
    coinlib.ECPrivateKey? nameKey;
    final allAddrs = await _db.getUsedAddresses();
    for (final addr in allAddrs) {
      final k = _deriveKey(addr.chain, addr.indexColumn);
      final pk = coinlib.ECPublicKey(k.public);
      final h = coinlib.bytesToHex(
        coinlib.P2PKHAddress.fromPublicKey(
          pk,
          version: _namecoinNetwork.p2pkhPrefix,
        ).hash,
      );
      if (h == pubkeyHashHex) {
        nameKey = _privateKeyFromBip32(k);
        break;
      }
    }
    // Fallback: brute-force (should not happen after sync)
    if (nameKey == null) {
      for (var chain = 0; chain <= 1 && nameKey == null; chain++) {
        for (var i = 0; i <= _receiveIndex + _gapLimit + 50; i++) {
          final k = _deriveKey(chain, i);
          final pk = coinlib.ECPublicKey(k.public);
          final h = coinlib.bytesToHex(
            coinlib.P2PKHAddress.fromPublicKey(
              pk,
              version: _namecoinNetwork.p2pkhPrefix,
            ).hash,
          );
          if (h == pubkeyHashHex) {
            nameKey = _privateKeyFromBip32(k);
            break;
          }
        }
      }
    }
    if (nameKey == null) throw StateError('Key not found for name output');

    // Build new name output
    final newNameKey = _deriveKey(0, _receiveIndex);
    _receiveIndex++;
    final newPubkey = coinlib.ECPublicKey(newNameKey.public);
    final newP2pkh = coinlib.P2PKH.fromPublicKey(newPubkey).script.compiled;
    final fullScript = Uint8List(nameOpBytes.length + newP2pkh.length);
    fullScript.setAll(0, nameOpBytes);
    fullScript.setAll(nameOpBytes.length, newP2pkh);

    final nameOutput = coinlib.Output.fromScriptBytes(
      BigInt.from(1000000),
      fullScript,
    );

    // Name input (P2PKH for coin selection sizing)
    final namePrevOut = coinlib.OutPoint.fromHex(nameTxHash, nameVout);
    final nameInputPlaceholder = coinlib.P2PKHInput(
      prevOut: namePrevOut,
      publicKey: nameKey.pubkey,
    );

    // Fee inputs from DB — already classified, no per-UTXO getTransaction
    final nonNameUtxos = await _db.getNonNameUtxos();
    final feeInputs = <coinlib.InputCandidate>[];
    final feeKeys = <coinlib.ECPrivateKey>[];
    for (final u in nonNameUtxos) {
      if (u.txid == nameTxHash && u.vout == nameVout) continue;
      final key = await _findKeyForAddressAsync(u.address);
      feeInputs.add(coinlib.InputCandidate(
        input: coinlib.P2PKHInput(
          prevOut: coinlib.OutPoint.fromHex(u.txid, u.vout),
          publicKey: key.pubkey,
        ),
        value: BigInt.from(u.value),
      ));
      feeKeys.add(key);
    }

    final allInputs = <coinlib.InputCandidate>[
      coinlib.InputCandidate(input: nameInputPlaceholder, value: nameValue),
      ...feeInputs,
    ];

    // Change
    final changeKey = _deriveKey(1, _changeIndex);
    _changeIndex++;
    final changeProgram = coinlib.P2PKH.fromPublicKey(
      coinlib.ECPublicKey(changeKey.public),
    );

    final coinSelection = coinlib.CoinSelection(
      version: 0x7100,
      selected: allInputs,
      recipients: [nameOutput],
      changeProgram: changeProgram,
      feePerKb: _namecoinNetwork.feePerKb,
      minFee: _namecoinNetwork.minFee,
      minChange: _namecoinNetwork.minOutput,
    );

    var tx = coinSelection.transaction;

    // Sign fee inputs (standard P2PKH)
    for (var i = 0; i < feeKeys.length; i++) {
      tx = tx.signLegacy(inputN: i + 1, key: feeKeys[i]);
    }

    // Sign name input (index 0) with FULL name output script as scriptCode
    final nameFullScript = coinlib.Script.decompile(
      coinlib.hexToBytes(nameOutputScriptHex),
    );
    final signDetails = coinlib.LegacySignDetailsWithScript(
      tx: tx,
      inputN: 0,
      scriptCode: nameFullScript,
    );
    final sig = coinlib.ECDSASignature.sign(
      nameKey,
      coinlib.LegacySignatureHasher(signDetails).hash,
    );
    final scriptSig = coinlib.Script([
      coinlib.ScriptPushData(coinlib.ECDSAInputSignature(sig).bytes),
      coinlib.ScriptPushData(nameKey.pubkey.data),
    ]);
    tx = tx.replaceInput(
      coinlib.RawInput(prevOut: namePrevOut, scriptSig: scriptSig.compiled),
      0,
    );

    return tx.toHex();
  }

  Future<String> broadcastTx(String txHex) async {
    final result = await _electrumFacade.request(
      'blockchain.transaction.broadcast',
      [txHex],
    );
    return result as String;
  }

  String _scriptHashFromAddress(coinlib.Address addr) {
    final scriptBytes = addr.program.script.compiled;
    final hash = coinlib.sha256Hash(scriptBytes);
    final reversed = Uint8List(hash.length);
    for (var i = 0; i < hash.length; i++) {
      reversed[i] = hash[hash.length - 1 - i];
    }
    return coinlib.bytesToHex(reversed);
  }
}
