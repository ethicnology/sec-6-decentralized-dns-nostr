import 'dart:typed_data';

import 'package:coinlib/coinlib.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test that signing a name input with the full name output script
/// produces a valid signature, unlike using just the P2PKH scriptCode.
void main() {
  setUpAll(() async {
    await loadCoinlib();
  });

  group('Name input signing', () {
    test('signature with full name script is valid', () {
      // Simulate a name output scriptPubKey:
      // OP_NAME_NEW <20-byte commitment> OP_2DROP OP_DUP OP_HASH160 <20-byte hash> OP_EQUALVERIFY OP_CHECKSIG
      //
      // 51 14 <commitment> 6d 76 a9 14 <pubkeyhash> 88 ac

      final key = ECPrivateKey.generate();
      final pubkey = key.pubkey;
      final pubkeyHash = hash160(pubkey.data);
      final commitment = generateRandomBytes(20);

      // Build the full name output script
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

      // Build a simple test transaction
      final prevOut = OutPoint(Uint8List(32), 0);
      final nameInput = RawInput(
        prevOut: prevOut,
        scriptSig: Uint8List(0),
      );

      // A simple output
      final output = Output.fromScriptBytes(
        BigInt.from(100000),
        P2PKH.fromPublicKey(pubkey).script.compiled,
      );

      final tx = Transaction(
        version: 0x7100,
        inputs: [nameInput],
        outputs: [output],
      );

      // Sign with full name output script as scriptCode
      final signDetails = LegacySignDetailsWithScript(
        tx: tx,
        inputN: 0,
        scriptCode: nameOutputScript,
      );
      final hasher = LegacySignatureHasher(signDetails);
      final sig = ECDSASignature.sign(key, hasher.hash);

      // Verify the signature is valid
      expect(sig.verify(pubkey, hasher.hash), isTrue);

      // Build the scriptSig
      final inputSig = ECDSAInputSignature(sig);
      final scriptSig = Script([
        ScriptPushData(inputSig.bytes),
        ScriptPushData(pubkey.data),
      ]);

      expect(scriptSig.compiled.isNotEmpty, isTrue);

      // Verify that using P2PKH-only scriptCode produces a DIFFERENT hash
      final p2pkhScript = P2PKH.fromPublicKey(pubkey).script;
      final p2pkhSignDetails = LegacySignDetailsWithScript(
        tx: tx,
        inputN: 0,
        scriptCode: p2pkhScript,
      );
      final p2pkhHasher = LegacySignatureHasher(p2pkhSignDetails);

      // The hashes MUST be different — this proves the name prefix matters
      expect(hasher.hash, isNot(equals(p2pkhHasher.hash)));
    });

    test('P2PKHInput uses wrong scriptCode for name outputs', () {
      // This test demonstrates the bug: P2PKHInput.scriptCode is just P2PKH,
      // not the full name output script. So signLegacy produces wrong sighash.
      final key = ECPrivateKey.generate();
      final pubkey = key.pubkey;

      final pkhInput = P2PKHInput(
        prevOut: OutPoint(Uint8List(32), 0),
        publicKey: pubkey,
      );

      // P2PKHInput.scriptCode is just P2PKH (no name prefix)
      final p2pkhOnlyScript = P2PKH.fromPublicKey(pubkey).script;
      expect(
        bytesToHex(pkhInput.scriptCode.compiled),
        equals(bytesToHex(p2pkhOnlyScript.compiled)),
      );
      // This proves P2PKHInput can't sign name outputs correctly
    });
  });
}
