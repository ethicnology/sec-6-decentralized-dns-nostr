import 'dart:convert';

/// Parsed Namecoin name value supporting IFA-0001 DNS fields
/// and both Nostr identity formats (IFA flat + NIP-05 embedded).
class NamecoinValueEntity {
  // IFA-0001 DNS fields
  final String? ip;
  final String? ip6;
  final List<String>? ns;
  final String? tor;
  final String? i2p;
  final String? alias;
  final String? translate;
  final String? email;
  final List<String>? txt;

  // Nostr identity (normalized from either format)
  // Key "_" = owner/root identity, other keys = named users
  final Map<String, String> nostrNames;
  final Map<String, List<String>> nostrRelays;

  final String rawJson;

  const NamecoinValueEntity({
    this.ip,
    this.ip6,
    this.ns,
    this.tor,
    this.i2p,
    this.alias,
    this.translate,
    this.email,
    this.txt,
    this.nostrNames = const {},
    this.nostrRelays = const {},
    required this.rawJson,
  });

  static final _hexPattern = RegExp(r'^[0-9a-f]{64}$');

  /// Parse a Namecoin value JSON string.
  /// Handles both Nostr formats:
  ///   - IFA flat: `{"nostr":"hex","relays":[...]}`
  ///   - NIP-05:   `{"nostr":{"names":{...},"relays":{...}}}`
  factory NamecoinValueEntity.fromJson(String jsonString) {
    final Map<String, dynamic> map;
    try {
      map = jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (_) {
      // Not valid JSON — return with just rawJson
      return NamecoinValueEntity(rawJson: jsonString);
    }

    // Parse DNS fields
    final ip = map['ip'] as String?;
    final ip6 = map['ip6'] as String?;
    final ns = (map['ns'] as List<dynamic>?)?.cast<String>();
    final tor = map['tor'] as String?;
    final i2p = map['i2p'] as String?;
    final alias = map['alias'] as String?;
    final translate = map['translate'] as String?;
    final email = map['email'] as String?;
    final txt = (map['txt'] as List<dynamic>?)?.cast<String>();

    // Parse Nostr identity
    var nostrNames = <String, String>{};
    var nostrRelays = <String, List<String>>{};

    final nostrField = map['nostr'];
    if (nostrField is String && _hexPattern.hasMatch(nostrField)) {
      // Format A: IFA flat — single pubkey as string
      nostrNames = {'_': nostrField};
      final relays = (map['relays'] as List<dynamic>?)?.cast<String>();
      if (relays != null && relays.isNotEmpty) {
        nostrRelays = {nostrField: relays};
      }
    } else if (nostrField is Map) {
      // Format B: NIP-05 embedded — names + relays maps
      final names = nostrField['names'];
      if (names is Map) {
        for (final entry in names.entries) {
          final key = entry.key as String;
          final value = entry.value as String;
          if (_hexPattern.hasMatch(value)) {
            nostrNames[key] = value;
          }
        }
      }
      final relays = nostrField['relays'];
      if (relays is Map) {
        for (final entry in relays.entries) {
          final key = entry.key as String;
          final value = entry.value;
          if (value is List) {
            nostrRelays[key] = value.cast<String>();
          }
        }
      }
    }

    return NamecoinValueEntity(
      ip: ip,
      ip6: ip6,
      ns: ns,
      tor: tor,
      i2p: i2p,
      alias: alias,
      translate: translate,
      email: email,
      txt: txt,
      nostrNames: nostrNames,
      nostrRelays: nostrRelays,
      rawJson: jsonString,
    );
  }

  /// All Nostr pubkeys found in this value.
  List<String> get nostrPubkeys => nostrNames.values.toList();

  /// Whether this value contains any Nostr identity.
  bool get hasNostr => nostrNames.isNotEmpty;

  /// Whether this value contains any DNS records.
  bool get hasDns =>
      ip != null ||
      ip6 != null ||
      (ns != null && ns!.isNotEmpty) ||
      tor != null ||
      i2p != null ||
      alias != null ||
      translate != null;

  /// Get the human-readable Nostr address for a given name entry.
  /// [fullname] is the Namecoin name (e.g. "d/bullbitcoin").
  /// [nameKey] is the key from nostrNames (e.g. "_", "alice").
  static String formatNostrAddress(String fullname, String nameKey) {
    if (nameKey == '_') return fullname;
    return '$nameKey@$fullname';
  }

  int get byteLength => utf8.encode(rawJson).length;

  @override
  String toString() =>
      'NamecoinValueEntity(nostrNames: $nostrNames, hasDns: $hasDns, '
      'byteLength: $byteLength)';
}
