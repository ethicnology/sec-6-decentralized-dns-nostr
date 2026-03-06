import 'package:flutter_test/flutter_test.dart';
import 'package:nostr_namecoin/shared/domain/entities/namecoin_value_entity.dart';

const _hexPub =
    'abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789';
const _hexPub2 =
    '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef';

void main() {
  group('NamecoinValueEntity - IFA flat format', () {
    test('parses nostr as string (IFA flat)', () {
      final v = NamecoinValueEntity.fromJson(
        '{"nostr":"$_hexPub","relays":["wss://relay.damus.io"]}',
      );
      expect(v.nostrNames, {'_': _hexPub});
      expect(v.nostrRelays[_hexPub], ['wss://relay.damus.io']);
      expect(v.nostrPubkeys, [_hexPub]);
      expect(v.hasNostr, true);
    });

    test('parses nostr without relays', () {
      final v = NamecoinValueEntity.fromJson('{"nostr":"$_hexPub"}');
      expect(v.nostrNames, {'_': _hexPub});
      expect(v.nostrRelays, isEmpty);
    });

    test('ignores invalid nostr hex', () {
      final v = NamecoinValueEntity.fromJson('{"nostr":"short"}');
      expect(v.nostrNames, isEmpty);
      expect(v.hasNostr, false);
    });
  });

  group('NamecoinValueEntity - NIP-05 embedded format', () {
    test('parses nostr as object with names + relays', () {
      final v = NamecoinValueEntity.fromJson(
        '{"nostr":{"names":{"_":"$_hexPub","alice":"$_hexPub2"},'
        '"relays":{"$_hexPub":["wss://relay.damus.io"]}}}',
      );
      expect(v.nostrNames, {'_': _hexPub, 'alice': _hexPub2});
      expect(v.nostrRelays[_hexPub], ['wss://relay.damus.io']);
      expect(v.nostrPubkeys, contains(_hexPub));
      expect(v.nostrPubkeys, contains(_hexPub2));
    });
  });

  group('NamecoinValueEntity - DNS fields', () {
    test('parses IFA-0001 DNS fields', () {
      final v = NamecoinValueEntity.fromJson(
        '{"ip":"1.2.3.4","ip6":"::1","ns":["ns1.example.com"],'
        '"tor":"abc.onion","email":"a@b.com"}',
      );
      expect(v.ip, '1.2.3.4');
      expect(v.ip6, '::1');
      expect(v.ns, ['ns1.example.com']);
      expect(v.tor, 'abc.onion');
      expect(v.email, 'a@b.com');
      expect(v.hasDns, true);
      expect(v.hasNostr, false);
    });

    test('parses mixed DNS + nostr', () {
      final v = NamecoinValueEntity.fromJson(
        '{"ip":"1.2.3.4","nostr":"$_hexPub","relays":["wss://r.io"]}',
      );
      expect(v.ip, '1.2.3.4');
      expect(v.hasNostr, true);
      expect(v.hasDns, true);
    });
  });

  group('NamecoinValueEntity - non-JSON values', () {
    test('handles plain string values', () {
      final v = NamecoinValueEntity.fromJson('BM-2cXeN1HuY8h7');
      expect(v.hasNostr, false);
      expect(v.hasDns, false);
      expect(v.rawJson, 'BM-2cXeN1HuY8h7');
    });
  });

  group('NamecoinValueEntity - human-readable addressing', () {
    test('d/ namespace → .bit', () {
      expect(
        NamecoinValueEntity.formatNostrAddress('d/alice', '_'),
        'alice.bit',
      );
      expect(
        NamecoinValueEntity.formatNostrAddress('d/bullbitcoin', 'bob'),
        'bob@bullbitcoin.bit',
      );
    });

    test('other namespaces → namespace as TLD', () {
      expect(
        NamecoinValueEntity.formatNostrAddress('xyz/example', '_'),
        'example.xyz',
      );
      expect(
        NamecoinValueEntity.formatNostrAddress('id/company', 'alice'),
        'alice@company.id',
      );
    });
  });
}
