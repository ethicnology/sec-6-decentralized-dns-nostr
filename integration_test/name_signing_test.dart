import 'dart:typed_data';

import 'package:coinlib/coinlib.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Integration test for name input signing.
/// Must run on a real device/simulator because coinlib needs native secp256k1.
///
/// Run with: flutter test integration_test/name_signing_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await loadCoinlib();
  });

  testWidgets('signature with full name script differs from P2PKH-only',
      (tester) async {
    final key = ECPrivateKey.generate();
    final pubkey = key.pubkey;
    final pubkeyHash = hash160(pubkey.data);
    final commitment = generateRandomBytes(20);

    // Full name output script:
    // OP_NAME_NEW <commitment> OP_2DROP OP_DUP OP_HASH160 <hash> OP_EQUALVERIFY OP_CHECKSIG
    final nameOutputScript = Script([
      ScriptOpCode.fromName('1'), // 0x51 = OP_NAME_NEW
      ScriptPushData(commitment),
      ScriptOpCode.fromName('2DROP'),
      ScriptOpCode.fromName('DUP'),
      ScriptOpCode.fromName('HASH160'),
      ScriptPushData(pubkeyHash),
      ScriptOpCode.fromName('EQUALVERIFY'),
      ScriptOpCode.fromName('CHECKSIG'),
    ]);

    // Standard P2PKH script (what P2PKHInput uses — WRONG for name outputs)
    final p2pkhScript = P2PKH.fromPublicKey(pubkey).script;

    // Build a test transaction
    final prevOut = OutPoint(Uint8List(32), 0);
    final nameInput = RawInput(
      prevOut: prevOut,
      scriptSig: Uint8List(0),
    );
    final output = Output.fromScriptBytes(
      BigInt.from(100000),
      p2pkhScript.compiled,
    );
    final tx = Transaction(
      version: 0x7100,
      inputs: [nameInput],
      outputs: [output],
    );

    // Hash with full name script
    final nameSignDetails = LegacySignDetailsWithScript(
      tx: tx,
      inputN: 0,
      scriptCode: nameOutputScript,
    );
    final nameHash = LegacySignatureHasher(nameSignDetails).hash;

    // Hash with P2PKH-only script
    final p2pkhSignDetails = LegacySignDetailsWithScript(
      tx: tx,
      inputN: 0,
      scriptCode: p2pkhScript,
    );
    final p2pkhHash = LegacySignatureHasher(p2pkhSignDetails).hash;

    // CRITICAL: These must be different. If they're the same, the name prefix
    // doesn't affect the sighash and our fix is unnecessary.
    expect(nameHash, isNot(equals(p2pkhHash)),
        reason: 'Name script prefix MUST affect sighash');

    // Sign with the correct (full) script and verify
    final sig = ECDSASignature.sign(key, nameHash);
    expect(sig.verify(pubkey, nameHash), isTrue,
        reason: 'Signature must be valid against full name script hash');

    // Sign with wrong (P2PKH-only) script — must NOT verify against name hash
    final wrongSig = ECDSASignature.sign(key, p2pkhHash);
    expect(wrongSig.verify(pubkey, nameHash), isFalse,
        reason: 'P2PKH-only signature must NOT verify against name script hash');

    // Build complete scriptSig
    final inputSig = ECDSAInputSignature(sig);
    final scriptSig = Script([
      ScriptPushData(inputSig.bytes),
      ScriptPushData(pubkey.data),
    ]);
    expect(scriptSig.compiled.length, greaterThan(70),
        reason: 'scriptSig should be ~107 bytes (sig + pubkey)');

    // Verify P2PKHInput.scriptCode is wrong for name outputs
    final pkhInput = P2PKHInput(
      prevOut: prevOut,
      publicKey: pubkey,
    );
    expect(
      bytesToHex(pkhInput.scriptCode.compiled),
      equals(bytesToHex(p2pkhScript.compiled)),
      reason: 'P2PKHInput.scriptCode must be P2PKH-only (confirming the bug)',
    );
  });
}
