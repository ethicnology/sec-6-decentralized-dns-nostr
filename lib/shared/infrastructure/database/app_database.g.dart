// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AddressesTable extends Addresses
    with TableInfo<$AddressesTable, AddressesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AddressesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chainMeta = const VerificationMeta('chain');
  @override
  late final GeneratedColumn<int> chain = GeneratedColumn<int>(
    'chain',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _indexColumnMeta = const VerificationMeta(
    'indexColumn',
  );
  @override
  late final GeneratedColumn<int> indexColumn = GeneratedColumn<int>(
    'idx',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _derivationPathMeta = const VerificationMeta(
    'derivationPath',
  );
  @override
  late final GeneratedColumn<String> derivationPath = GeneratedColumn<String>(
    'derivation_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scriptHashMeta = const VerificationMeta(
    'scriptHash',
  );
  @override
  late final GeneratedColumn<String> scriptHash = GeneratedColumn<String>(
    'script_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasHistoryMeta = const VerificationMeta(
    'hasHistory',
  );
  @override
  late final GeneratedColumn<bool> hasHistory = GeneratedColumn<bool>(
    'has_history',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_history" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    address,
    chain,
    indexColumn,
    derivationPath,
    scriptHash,
    hasHistory,
    lastSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'addresses';
  @override
  VerificationContext validateIntegrity(
    Insertable<AddressesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('chain')) {
      context.handle(
        _chainMeta,
        chain.isAcceptableOrUnknown(data['chain']!, _chainMeta),
      );
    } else if (isInserting) {
      context.missing(_chainMeta);
    }
    if (data.containsKey('idx')) {
      context.handle(
        _indexColumnMeta,
        indexColumn.isAcceptableOrUnknown(data['idx']!, _indexColumnMeta),
      );
    } else if (isInserting) {
      context.missing(_indexColumnMeta);
    }
    if (data.containsKey('derivation_path')) {
      context.handle(
        _derivationPathMeta,
        derivationPath.isAcceptableOrUnknown(
          data['derivation_path']!,
          _derivationPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_derivationPathMeta);
    }
    if (data.containsKey('script_hash')) {
      context.handle(
        _scriptHashMeta,
        scriptHash.isAcceptableOrUnknown(data['script_hash']!, _scriptHashMeta),
      );
    } else if (isInserting) {
      context.missing(_scriptHashMeta);
    }
    if (data.containsKey('has_history')) {
      context.handle(
        _hasHistoryMeta,
        hasHistory.isAcceptableOrUnknown(data['has_history']!, _hasHistoryMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {address};
  @override
  AddressesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AddressesData(
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      chain: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chain'],
      )!,
      indexColumn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}idx'],
      )!,
      derivationPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}derivation_path'],
      )!,
      scriptHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}script_hash'],
      )!,
      hasHistory: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_history'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $AddressesTable createAlias(String alias) {
    return $AddressesTable(attachedDatabase, alias);
  }
}

class AddressesData extends DataClass implements Insertable<AddressesData> {
  final String address;
  final int chain;
  final int indexColumn;
  final String derivationPath;
  final String scriptHash;
  final bool hasHistory;
  final DateTime? lastSyncAt;
  const AddressesData({
    required this.address,
    required this.chain,
    required this.indexColumn,
    required this.derivationPath,
    required this.scriptHash,
    required this.hasHistory,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['address'] = Variable<String>(address);
    map['chain'] = Variable<int>(chain);
    map['idx'] = Variable<int>(indexColumn);
    map['derivation_path'] = Variable<String>(derivationPath);
    map['script_hash'] = Variable<String>(scriptHash);
    map['has_history'] = Variable<bool>(hasHistory);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  AddressesCompanion toCompanion(bool nullToAbsent) {
    return AddressesCompanion(
      address: Value(address),
      chain: Value(chain),
      indexColumn: Value(indexColumn),
      derivationPath: Value(derivationPath),
      scriptHash: Value(scriptHash),
      hasHistory: Value(hasHistory),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory AddressesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AddressesData(
      address: serializer.fromJson<String>(json['address']),
      chain: serializer.fromJson<int>(json['chain']),
      indexColumn: serializer.fromJson<int>(json['indexColumn']),
      derivationPath: serializer.fromJson<String>(json['derivationPath']),
      scriptHash: serializer.fromJson<String>(json['scriptHash']),
      hasHistory: serializer.fromJson<bool>(json['hasHistory']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'address': serializer.toJson<String>(address),
      'chain': serializer.toJson<int>(chain),
      'indexColumn': serializer.toJson<int>(indexColumn),
      'derivationPath': serializer.toJson<String>(derivationPath),
      'scriptHash': serializer.toJson<String>(scriptHash),
      'hasHistory': serializer.toJson<bool>(hasHistory),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  AddressesData copyWith({
    String? address,
    int? chain,
    int? indexColumn,
    String? derivationPath,
    String? scriptHash,
    bool? hasHistory,
    Value<DateTime?> lastSyncAt = const Value.absent(),
  }) => AddressesData(
    address: address ?? this.address,
    chain: chain ?? this.chain,
    indexColumn: indexColumn ?? this.indexColumn,
    derivationPath: derivationPath ?? this.derivationPath,
    scriptHash: scriptHash ?? this.scriptHash,
    hasHistory: hasHistory ?? this.hasHistory,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  AddressesData copyWithCompanion(AddressesCompanion data) {
    return AddressesData(
      address: data.address.present ? data.address.value : this.address,
      chain: data.chain.present ? data.chain.value : this.chain,
      indexColumn: data.indexColumn.present
          ? data.indexColumn.value
          : this.indexColumn,
      derivationPath: data.derivationPath.present
          ? data.derivationPath.value
          : this.derivationPath,
      scriptHash: data.scriptHash.present
          ? data.scriptHash.value
          : this.scriptHash,
      hasHistory: data.hasHistory.present
          ? data.hasHistory.value
          : this.hasHistory,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AddressesData(')
          ..write('address: $address, ')
          ..write('chain: $chain, ')
          ..write('indexColumn: $indexColumn, ')
          ..write('derivationPath: $derivationPath, ')
          ..write('scriptHash: $scriptHash, ')
          ..write('hasHistory: $hasHistory, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    address,
    chain,
    indexColumn,
    derivationPath,
    scriptHash,
    hasHistory,
    lastSyncAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AddressesData &&
          other.address == this.address &&
          other.chain == this.chain &&
          other.indexColumn == this.indexColumn &&
          other.derivationPath == this.derivationPath &&
          other.scriptHash == this.scriptHash &&
          other.hasHistory == this.hasHistory &&
          other.lastSyncAt == this.lastSyncAt);
}

class AddressesCompanion extends UpdateCompanion<AddressesData> {
  final Value<String> address;
  final Value<int> chain;
  final Value<int> indexColumn;
  final Value<String> derivationPath;
  final Value<String> scriptHash;
  final Value<bool> hasHistory;
  final Value<DateTime?> lastSyncAt;
  final Value<int> rowid;
  const AddressesCompanion({
    this.address = const Value.absent(),
    this.chain = const Value.absent(),
    this.indexColumn = const Value.absent(),
    this.derivationPath = const Value.absent(),
    this.scriptHash = const Value.absent(),
    this.hasHistory = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AddressesCompanion.insert({
    required String address,
    required int chain,
    required int indexColumn,
    required String derivationPath,
    required String scriptHash,
    this.hasHistory = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : address = Value(address),
       chain = Value(chain),
       indexColumn = Value(indexColumn),
       derivationPath = Value(derivationPath),
       scriptHash = Value(scriptHash);
  static Insertable<AddressesData> custom({
    Expression<String>? address,
    Expression<int>? chain,
    Expression<int>? indexColumn,
    Expression<String>? derivationPath,
    Expression<String>? scriptHash,
    Expression<bool>? hasHistory,
    Expression<DateTime>? lastSyncAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (address != null) 'address': address,
      if (chain != null) 'chain': chain,
      if (indexColumn != null) 'idx': indexColumn,
      if (derivationPath != null) 'derivation_path': derivationPath,
      if (scriptHash != null) 'script_hash': scriptHash,
      if (hasHistory != null) 'has_history': hasHistory,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AddressesCompanion copyWith({
    Value<String>? address,
    Value<int>? chain,
    Value<int>? indexColumn,
    Value<String>? derivationPath,
    Value<String>? scriptHash,
    Value<bool>? hasHistory,
    Value<DateTime?>? lastSyncAt,
    Value<int>? rowid,
  }) {
    return AddressesCompanion(
      address: address ?? this.address,
      chain: chain ?? this.chain,
      indexColumn: indexColumn ?? this.indexColumn,
      derivationPath: derivationPath ?? this.derivationPath,
      scriptHash: scriptHash ?? this.scriptHash,
      hasHistory: hasHistory ?? this.hasHistory,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (chain.present) {
      map['chain'] = Variable<int>(chain.value);
    }
    if (indexColumn.present) {
      map['idx'] = Variable<int>(indexColumn.value);
    }
    if (derivationPath.present) {
      map['derivation_path'] = Variable<String>(derivationPath.value);
    }
    if (scriptHash.present) {
      map['script_hash'] = Variable<String>(scriptHash.value);
    }
    if (hasHistory.present) {
      map['has_history'] = Variable<bool>(hasHistory.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AddressesCompanion(')
          ..write('address: $address, ')
          ..write('chain: $chain, ')
          ..write('indexColumn: $indexColumn, ')
          ..write('derivationPath: $derivationPath, ')
          ..write('scriptHash: $scriptHash, ')
          ..write('hasHistory: $hasHistory, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UtxosTable extends Utxos with TableInfo<$UtxosTable, Utxo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UtxosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _txidMeta = const VerificationMeta('txid');
  @override
  late final GeneratedColumn<String> txid = GeneratedColumn<String>(
    'txid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _voutMeta = const VerificationMeta('vout');
  @override
  late final GeneratedColumn<int> vout = GeneratedColumn<int>(
    'vout',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES addresses (address)',
    ),
  );
  static const VerificationMeta _isNameUtxoMeta = const VerificationMeta(
    'isNameUtxo',
  );
  @override
  late final GeneratedColumn<bool> isNameUtxo = GeneratedColumn<bool>(
    'is_name_utxo',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_name_utxo" IN (0, 1))',
    ),
  );
  static const VerificationMeta _nameOpTypeMeta = const VerificationMeta(
    'nameOpType',
  );
  @override
  late final GeneratedColumn<String> nameOpType = GeneratedColumn<String>(
    'name_op_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameOpHashMeta = const VerificationMeta(
    'nameOpHash',
  );
  @override
  late final GeneratedColumn<String> nameOpHash = GeneratedColumn<String>(
    'name_op_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameOpNameMeta = const VerificationMeta(
    'nameOpName',
  );
  @override
  late final GeneratedColumn<String> nameOpName = GeneratedColumn<String>(
    'name_op_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameOpValueMeta = const VerificationMeta(
    'nameOpValue',
  );
  @override
  late final GeneratedColumn<String> nameOpValue = GeneratedColumn<String>(
    'name_op_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    txid,
    vout,
    value,
    address,
    isNameUtxo,
    nameOpType,
    nameOpHash,
    nameOpName,
    nameOpValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'utxos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Utxo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('txid')) {
      context.handle(
        _txidMeta,
        txid.isAcceptableOrUnknown(data['txid']!, _txidMeta),
      );
    } else if (isInserting) {
      context.missing(_txidMeta);
    }
    if (data.containsKey('vout')) {
      context.handle(
        _voutMeta,
        vout.isAcceptableOrUnknown(data['vout']!, _voutMeta),
      );
    } else if (isInserting) {
      context.missing(_voutMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('is_name_utxo')) {
      context.handle(
        _isNameUtxoMeta,
        isNameUtxo.isAcceptableOrUnknown(
          data['is_name_utxo']!,
          _isNameUtxoMeta,
        ),
      );
    }
    if (data.containsKey('name_op_type')) {
      context.handle(
        _nameOpTypeMeta,
        nameOpType.isAcceptableOrUnknown(
          data['name_op_type']!,
          _nameOpTypeMeta,
        ),
      );
    }
    if (data.containsKey('name_op_hash')) {
      context.handle(
        _nameOpHashMeta,
        nameOpHash.isAcceptableOrUnknown(
          data['name_op_hash']!,
          _nameOpHashMeta,
        ),
      );
    }
    if (data.containsKey('name_op_name')) {
      context.handle(
        _nameOpNameMeta,
        nameOpName.isAcceptableOrUnknown(
          data['name_op_name']!,
          _nameOpNameMeta,
        ),
      );
    }
    if (data.containsKey('name_op_value')) {
      context.handle(
        _nameOpValueMeta,
        nameOpValue.isAcceptableOrUnknown(
          data['name_op_value']!,
          _nameOpValueMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {txid, vout};
  @override
  Utxo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Utxo(
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}txid'],
      )!,
      vout: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vout'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      isNameUtxo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_name_utxo'],
      ),
      nameOpType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_op_type'],
      ),
      nameOpHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_op_hash'],
      ),
      nameOpName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_op_name'],
      ),
      nameOpValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_op_value'],
      ),
    );
  }

  @override
  $UtxosTable createAlias(String alias) {
    return $UtxosTable(attachedDatabase, alias);
  }
}

class Utxo extends DataClass implements Insertable<Utxo> {
  final String txid;
  final int vout;
  final int value;
  final String address;

  /// null = not yet checked, true = has nameOp, false = no nameOp
  final bool? isNameUtxo;
  final String? nameOpType;
  final String? nameOpHash;
  final String? nameOpName;
  final String? nameOpValue;
  const Utxo({
    required this.txid,
    required this.vout,
    required this.value,
    required this.address,
    this.isNameUtxo,
    this.nameOpType,
    this.nameOpHash,
    this.nameOpName,
    this.nameOpValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['txid'] = Variable<String>(txid);
    map['vout'] = Variable<int>(vout);
    map['value'] = Variable<int>(value);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || isNameUtxo != null) {
      map['is_name_utxo'] = Variable<bool>(isNameUtxo);
    }
    if (!nullToAbsent || nameOpType != null) {
      map['name_op_type'] = Variable<String>(nameOpType);
    }
    if (!nullToAbsent || nameOpHash != null) {
      map['name_op_hash'] = Variable<String>(nameOpHash);
    }
    if (!nullToAbsent || nameOpName != null) {
      map['name_op_name'] = Variable<String>(nameOpName);
    }
    if (!nullToAbsent || nameOpValue != null) {
      map['name_op_value'] = Variable<String>(nameOpValue);
    }
    return map;
  }

  UtxosCompanion toCompanion(bool nullToAbsent) {
    return UtxosCompanion(
      txid: Value(txid),
      vout: Value(vout),
      value: Value(value),
      address: Value(address),
      isNameUtxo: isNameUtxo == null && nullToAbsent
          ? const Value.absent()
          : Value(isNameUtxo),
      nameOpType: nameOpType == null && nullToAbsent
          ? const Value.absent()
          : Value(nameOpType),
      nameOpHash: nameOpHash == null && nullToAbsent
          ? const Value.absent()
          : Value(nameOpHash),
      nameOpName: nameOpName == null && nullToAbsent
          ? const Value.absent()
          : Value(nameOpName),
      nameOpValue: nameOpValue == null && nullToAbsent
          ? const Value.absent()
          : Value(nameOpValue),
    );
  }

  factory Utxo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Utxo(
      txid: serializer.fromJson<String>(json['txid']),
      vout: serializer.fromJson<int>(json['vout']),
      value: serializer.fromJson<int>(json['value']),
      address: serializer.fromJson<String>(json['address']),
      isNameUtxo: serializer.fromJson<bool?>(json['isNameUtxo']),
      nameOpType: serializer.fromJson<String?>(json['nameOpType']),
      nameOpHash: serializer.fromJson<String?>(json['nameOpHash']),
      nameOpName: serializer.fromJson<String?>(json['nameOpName']),
      nameOpValue: serializer.fromJson<String?>(json['nameOpValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'txid': serializer.toJson<String>(txid),
      'vout': serializer.toJson<int>(vout),
      'value': serializer.toJson<int>(value),
      'address': serializer.toJson<String>(address),
      'isNameUtxo': serializer.toJson<bool?>(isNameUtxo),
      'nameOpType': serializer.toJson<String?>(nameOpType),
      'nameOpHash': serializer.toJson<String?>(nameOpHash),
      'nameOpName': serializer.toJson<String?>(nameOpName),
      'nameOpValue': serializer.toJson<String?>(nameOpValue),
    };
  }

  Utxo copyWith({
    String? txid,
    int? vout,
    int? value,
    String? address,
    Value<bool?> isNameUtxo = const Value.absent(),
    Value<String?> nameOpType = const Value.absent(),
    Value<String?> nameOpHash = const Value.absent(),
    Value<String?> nameOpName = const Value.absent(),
    Value<String?> nameOpValue = const Value.absent(),
  }) => Utxo(
    txid: txid ?? this.txid,
    vout: vout ?? this.vout,
    value: value ?? this.value,
    address: address ?? this.address,
    isNameUtxo: isNameUtxo.present ? isNameUtxo.value : this.isNameUtxo,
    nameOpType: nameOpType.present ? nameOpType.value : this.nameOpType,
    nameOpHash: nameOpHash.present ? nameOpHash.value : this.nameOpHash,
    nameOpName: nameOpName.present ? nameOpName.value : this.nameOpName,
    nameOpValue: nameOpValue.present ? nameOpValue.value : this.nameOpValue,
  );
  Utxo copyWithCompanion(UtxosCompanion data) {
    return Utxo(
      txid: data.txid.present ? data.txid.value : this.txid,
      vout: data.vout.present ? data.vout.value : this.vout,
      value: data.value.present ? data.value.value : this.value,
      address: data.address.present ? data.address.value : this.address,
      isNameUtxo: data.isNameUtxo.present
          ? data.isNameUtxo.value
          : this.isNameUtxo,
      nameOpType: data.nameOpType.present
          ? data.nameOpType.value
          : this.nameOpType,
      nameOpHash: data.nameOpHash.present
          ? data.nameOpHash.value
          : this.nameOpHash,
      nameOpName: data.nameOpName.present
          ? data.nameOpName.value
          : this.nameOpName,
      nameOpValue: data.nameOpValue.present
          ? data.nameOpValue.value
          : this.nameOpValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Utxo(')
          ..write('txid: $txid, ')
          ..write('vout: $vout, ')
          ..write('value: $value, ')
          ..write('address: $address, ')
          ..write('isNameUtxo: $isNameUtxo, ')
          ..write('nameOpType: $nameOpType, ')
          ..write('nameOpHash: $nameOpHash, ')
          ..write('nameOpName: $nameOpName, ')
          ..write('nameOpValue: $nameOpValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    txid,
    vout,
    value,
    address,
    isNameUtxo,
    nameOpType,
    nameOpHash,
    nameOpName,
    nameOpValue,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Utxo &&
          other.txid == this.txid &&
          other.vout == this.vout &&
          other.value == this.value &&
          other.address == this.address &&
          other.isNameUtxo == this.isNameUtxo &&
          other.nameOpType == this.nameOpType &&
          other.nameOpHash == this.nameOpHash &&
          other.nameOpName == this.nameOpName &&
          other.nameOpValue == this.nameOpValue);
}

class UtxosCompanion extends UpdateCompanion<Utxo> {
  final Value<String> txid;
  final Value<int> vout;
  final Value<int> value;
  final Value<String> address;
  final Value<bool?> isNameUtxo;
  final Value<String?> nameOpType;
  final Value<String?> nameOpHash;
  final Value<String?> nameOpName;
  final Value<String?> nameOpValue;
  final Value<int> rowid;
  const UtxosCompanion({
    this.txid = const Value.absent(),
    this.vout = const Value.absent(),
    this.value = const Value.absent(),
    this.address = const Value.absent(),
    this.isNameUtxo = const Value.absent(),
    this.nameOpType = const Value.absent(),
    this.nameOpHash = const Value.absent(),
    this.nameOpName = const Value.absent(),
    this.nameOpValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UtxosCompanion.insert({
    required String txid,
    required int vout,
    required int value,
    required String address,
    this.isNameUtxo = const Value.absent(),
    this.nameOpType = const Value.absent(),
    this.nameOpHash = const Value.absent(),
    this.nameOpName = const Value.absent(),
    this.nameOpValue = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : txid = Value(txid),
       vout = Value(vout),
       value = Value(value),
       address = Value(address);
  static Insertable<Utxo> custom({
    Expression<String>? txid,
    Expression<int>? vout,
    Expression<int>? value,
    Expression<String>? address,
    Expression<bool>? isNameUtxo,
    Expression<String>? nameOpType,
    Expression<String>? nameOpHash,
    Expression<String>? nameOpName,
    Expression<String>? nameOpValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (txid != null) 'txid': txid,
      if (vout != null) 'vout': vout,
      if (value != null) 'value': value,
      if (address != null) 'address': address,
      if (isNameUtxo != null) 'is_name_utxo': isNameUtxo,
      if (nameOpType != null) 'name_op_type': nameOpType,
      if (nameOpHash != null) 'name_op_hash': nameOpHash,
      if (nameOpName != null) 'name_op_name': nameOpName,
      if (nameOpValue != null) 'name_op_value': nameOpValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UtxosCompanion copyWith({
    Value<String>? txid,
    Value<int>? vout,
    Value<int>? value,
    Value<String>? address,
    Value<bool?>? isNameUtxo,
    Value<String?>? nameOpType,
    Value<String?>? nameOpHash,
    Value<String?>? nameOpName,
    Value<String?>? nameOpValue,
    Value<int>? rowid,
  }) {
    return UtxosCompanion(
      txid: txid ?? this.txid,
      vout: vout ?? this.vout,
      value: value ?? this.value,
      address: address ?? this.address,
      isNameUtxo: isNameUtxo ?? this.isNameUtxo,
      nameOpType: nameOpType ?? this.nameOpType,
      nameOpHash: nameOpHash ?? this.nameOpHash,
      nameOpName: nameOpName ?? this.nameOpName,
      nameOpValue: nameOpValue ?? this.nameOpValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (txid.present) {
      map['txid'] = Variable<String>(txid.value);
    }
    if (vout.present) {
      map['vout'] = Variable<int>(vout.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (isNameUtxo.present) {
      map['is_name_utxo'] = Variable<bool>(isNameUtxo.value);
    }
    if (nameOpType.present) {
      map['name_op_type'] = Variable<String>(nameOpType.value);
    }
    if (nameOpHash.present) {
      map['name_op_hash'] = Variable<String>(nameOpHash.value);
    }
    if (nameOpName.present) {
      map['name_op_name'] = Variable<String>(nameOpName.value);
    }
    if (nameOpValue.present) {
      map['name_op_value'] = Variable<String>(nameOpValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UtxosCompanion(')
          ..write('txid: $txid, ')
          ..write('vout: $vout, ')
          ..write('value: $value, ')
          ..write('address: $address, ')
          ..write('isNameUtxo: $isNameUtxo, ')
          ..write('nameOpType: $nameOpType, ')
          ..write('nameOpHash: $nameOpHash, ')
          ..write('nameOpName: $nameOpName, ')
          ..write('nameOpValue: $nameOpValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedTransactionsTable extends CachedTransactions
    with TableInfo<$CachedTransactionsTable, CachedTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _txidMeta = const VerificationMeta('txid');
  @override
  late final GeneratedColumn<String> txid = GeneratedColumn<String>(
    'txid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawJsonMeta = const VerificationMeta(
    'rawJson',
  );
  @override
  late final GeneratedColumn<String> rawJson = GeneratedColumn<String>(
    'raw_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [txid, rawJson, height, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('txid')) {
      context.handle(
        _txidMeta,
        txid.isAcceptableOrUnknown(data['txid']!, _txidMeta),
      );
    } else if (isInserting) {
      context.missing(_txidMeta);
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_rawJsonMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {txid};
  @override
  CachedTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedTransaction(
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}txid'],
      )!,
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedTransactionsTable createAlias(String alias) {
    return $CachedTransactionsTable(attachedDatabase, alias);
  }
}

class CachedTransaction extends DataClass
    implements Insertable<CachedTransaction> {
  final String txid;
  final String rawJson;
  final int height;
  final DateTime cachedAt;
  const CachedTransaction({
    required this.txid,
    required this.rawJson,
    required this.height,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['txid'] = Variable<String>(txid);
    map['raw_json'] = Variable<String>(rawJson);
    map['height'] = Variable<int>(height);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedTransactionsCompanion toCompanion(bool nullToAbsent) {
    return CachedTransactionsCompanion(
      txid: Value(txid),
      rawJson: Value(rawJson),
      height: Value(height),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedTransaction(
      txid: serializer.fromJson<String>(json['txid']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      height: serializer.fromJson<int>(json['height']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'txid': serializer.toJson<String>(txid),
      'rawJson': serializer.toJson<String>(rawJson),
      'height': serializer.toJson<int>(height),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedTransaction copyWith({
    String? txid,
    String? rawJson,
    int? height,
    DateTime? cachedAt,
  }) => CachedTransaction(
    txid: txid ?? this.txid,
    rawJson: rawJson ?? this.rawJson,
    height: height ?? this.height,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedTransaction copyWithCompanion(CachedTransactionsCompanion data) {
    return CachedTransaction(
      txid: data.txid.present ? data.txid.value : this.txid,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      height: data.height.present ? data.height.value : this.height,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedTransaction(')
          ..write('txid: $txid, ')
          ..write('rawJson: $rawJson, ')
          ..write('height: $height, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(txid, rawJson, height, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedTransaction &&
          other.txid == this.txid &&
          other.rawJson == this.rawJson &&
          other.height == this.height &&
          other.cachedAt == this.cachedAt);
}

class CachedTransactionsCompanion extends UpdateCompanion<CachedTransaction> {
  final Value<String> txid;
  final Value<String> rawJson;
  final Value<int> height;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CachedTransactionsCompanion({
    this.txid = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.height = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedTransactionsCompanion.insert({
    required String txid,
    required String rawJson,
    this.height = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : txid = Value(txid),
       rawJson = Value(rawJson),
       cachedAt = Value(cachedAt);
  static Insertable<CachedTransaction> custom({
    Expression<String>? txid,
    Expression<String>? rawJson,
    Expression<int>? height,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (txid != null) 'txid': txid,
      if (rawJson != null) 'raw_json': rawJson,
      if (height != null) 'height': height,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedTransactionsCompanion copyWith({
    Value<String>? txid,
    Value<String>? rawJson,
    Value<int>? height,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CachedTransactionsCompanion(
      txid: txid ?? this.txid,
      rawJson: rawJson ?? this.rawJson,
      height: height ?? this.height,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (txid.present) {
      map['txid'] = Variable<String>(txid.value);
    }
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedTransactionsCompanion(')
          ..write('txid: $txid, ')
          ..write('rawJson: $rawJson, ')
          ..write('height: $height, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionHistoryTable extends TransactionHistory
    with TableInfo<$TransactionHistoryTable, TransactionHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _txidMeta = const VerificationMeta('txid');
  @override
  late final GeneratedColumn<String> txid = GeneratedColumn<String>(
    'txid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [txid, height];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('txid')) {
      context.handle(
        _txidMeta,
        txid.isAcceptableOrUnknown(data['txid']!, _txidMeta),
      );
    } else if (isInserting) {
      context.missing(_txidMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {txid};
  @override
  TransactionHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionHistoryData(
      txid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}txid'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
    );
  }

  @override
  $TransactionHistoryTable createAlias(String alias) {
    return $TransactionHistoryTable(attachedDatabase, alias);
  }
}

class TransactionHistoryData extends DataClass
    implements Insertable<TransactionHistoryData> {
  final String txid;
  final int height;
  const TransactionHistoryData({required this.txid, required this.height});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['txid'] = Variable<String>(txid);
    map['height'] = Variable<int>(height);
    return map;
  }

  TransactionHistoryCompanion toCompanion(bool nullToAbsent) {
    return TransactionHistoryCompanion(
      txid: Value(txid),
      height: Value(height),
    );
  }

  factory TransactionHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionHistoryData(
      txid: serializer.fromJson<String>(json['txid']),
      height: serializer.fromJson<int>(json['height']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'txid': serializer.toJson<String>(txid),
      'height': serializer.toJson<int>(height),
    };
  }

  TransactionHistoryData copyWith({String? txid, int? height}) =>
      TransactionHistoryData(
        txid: txid ?? this.txid,
        height: height ?? this.height,
      );
  TransactionHistoryData copyWithCompanion(TransactionHistoryCompanion data) {
    return TransactionHistoryData(
      txid: data.txid.present ? data.txid.value : this.txid,
      height: data.height.present ? data.height.value : this.height,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionHistoryData(')
          ..write('txid: $txid, ')
          ..write('height: $height')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(txid, height);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionHistoryData &&
          other.txid == this.txid &&
          other.height == this.height);
}

class TransactionHistoryCompanion
    extends UpdateCompanion<TransactionHistoryData> {
  final Value<String> txid;
  final Value<int> height;
  final Value<int> rowid;
  const TransactionHistoryCompanion({
    this.txid = const Value.absent(),
    this.height = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionHistoryCompanion.insert({
    required String txid,
    this.height = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : txid = Value(txid);
  static Insertable<TransactionHistoryData> custom({
    Expression<String>? txid,
    Expression<int>? height,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (txid != null) 'txid': txid,
      if (height != null) 'height': height,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionHistoryCompanion copyWith({
    Value<String>? txid,
    Value<int>? height,
    Value<int>? rowid,
  }) {
    return TransactionHistoryCompanion(
      txid: txid ?? this.txid,
      height: height ?? this.height,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (txid.present) {
      map['txid'] = Variable<String>(txid.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionHistoryCompanion(')
          ..write('txid: $txid, ')
          ..write('height: $height, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingRegistrationsTable extends PendingRegistrations
    with TableInfo<$PendingRegistrationsTable, PendingRegistration> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingRegistrationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saltHexMeta = const VerificationMeta(
    'saltHex',
  );
  @override
  late final GeneratedColumn<String> saltHex = GeneratedColumn<String>(
    'salt_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commitmentHexMeta = const VerificationMeta(
    'commitmentHex',
  );
  @override
  late final GeneratedColumn<String> commitmentHex = GeneratedColumn<String>(
    'commitment_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameNewTxidMeta = const VerificationMeta(
    'nameNewTxid',
  );
  @override
  late final GeneratedColumn<String> nameNewTxid = GeneratedColumn<String>(
    'name_new_txid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameFirstUpdateTxidMeta =
      const VerificationMeta('nameFirstUpdateTxid');
  @override
  late final GeneratedColumn<String> nameFirstUpdateTxid =
      GeneratedColumn<String>(
        'name_first_update_txid',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending_new'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    saltHex,
    commitmentHex,
    nameNewTxid,
    nameFirstUpdateTxid,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_registrations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingRegistration> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('salt_hex')) {
      context.handle(
        _saltHexMeta,
        saltHex.isAcceptableOrUnknown(data['salt_hex']!, _saltHexMeta),
      );
    } else if (isInserting) {
      context.missing(_saltHexMeta);
    }
    if (data.containsKey('commitment_hex')) {
      context.handle(
        _commitmentHexMeta,
        commitmentHex.isAcceptableOrUnknown(
          data['commitment_hex']!,
          _commitmentHexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_commitmentHexMeta);
    }
    if (data.containsKey('name_new_txid')) {
      context.handle(
        _nameNewTxidMeta,
        nameNewTxid.isAcceptableOrUnknown(
          data['name_new_txid']!,
          _nameNewTxidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameNewTxidMeta);
    }
    if (data.containsKey('name_first_update_txid')) {
      context.handle(
        _nameFirstUpdateTxidMeta,
        nameFirstUpdateTxid.isAcceptableOrUnknown(
          data['name_first_update_txid']!,
          _nameFirstUpdateTxidMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingRegistration map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingRegistration(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      saltHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}salt_hex'],
      )!,
      commitmentHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}commitment_hex'],
      )!,
      nameNewTxid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_new_txid'],
      )!,
      nameFirstUpdateTxid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_first_update_txid'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PendingRegistrationsTable createAlias(String alias) {
    return $PendingRegistrationsTable(attachedDatabase, alias);
  }
}

class PendingRegistration extends DataClass
    implements Insertable<PendingRegistration> {
  final int id;
  final String name;
  final String saltHex;
  final String commitmentHex;
  final String nameNewTxid;
  final String? nameFirstUpdateTxid;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PendingRegistration({
    required this.id,
    required this.name,
    required this.saltHex,
    required this.commitmentHex,
    required this.nameNewTxid,
    this.nameFirstUpdateTxid,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['salt_hex'] = Variable<String>(saltHex);
    map['commitment_hex'] = Variable<String>(commitmentHex);
    map['name_new_txid'] = Variable<String>(nameNewTxid);
    if (!nullToAbsent || nameFirstUpdateTxid != null) {
      map['name_first_update_txid'] = Variable<String>(nameFirstUpdateTxid);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PendingRegistrationsCompanion toCompanion(bool nullToAbsent) {
    return PendingRegistrationsCompanion(
      id: Value(id),
      name: Value(name),
      saltHex: Value(saltHex),
      commitmentHex: Value(commitmentHex),
      nameNewTxid: Value(nameNewTxid),
      nameFirstUpdateTxid: nameFirstUpdateTxid == null && nullToAbsent
          ? const Value.absent()
          : Value(nameFirstUpdateTxid),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PendingRegistration.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingRegistration(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      saltHex: serializer.fromJson<String>(json['saltHex']),
      commitmentHex: serializer.fromJson<String>(json['commitmentHex']),
      nameNewTxid: serializer.fromJson<String>(json['nameNewTxid']),
      nameFirstUpdateTxid: serializer.fromJson<String?>(
        json['nameFirstUpdateTxid'],
      ),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'saltHex': serializer.toJson<String>(saltHex),
      'commitmentHex': serializer.toJson<String>(commitmentHex),
      'nameNewTxid': serializer.toJson<String>(nameNewTxid),
      'nameFirstUpdateTxid': serializer.toJson<String?>(nameFirstUpdateTxid),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PendingRegistration copyWith({
    int? id,
    String? name,
    String? saltHex,
    String? commitmentHex,
    String? nameNewTxid,
    Value<String?> nameFirstUpdateTxid = const Value.absent(),
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PendingRegistration(
    id: id ?? this.id,
    name: name ?? this.name,
    saltHex: saltHex ?? this.saltHex,
    commitmentHex: commitmentHex ?? this.commitmentHex,
    nameNewTxid: nameNewTxid ?? this.nameNewTxid,
    nameFirstUpdateTxid: nameFirstUpdateTxid.present
        ? nameFirstUpdateTxid.value
        : this.nameFirstUpdateTxid,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PendingRegistration copyWithCompanion(PendingRegistrationsCompanion data) {
    return PendingRegistration(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      saltHex: data.saltHex.present ? data.saltHex.value : this.saltHex,
      commitmentHex: data.commitmentHex.present
          ? data.commitmentHex.value
          : this.commitmentHex,
      nameNewTxid: data.nameNewTxid.present
          ? data.nameNewTxid.value
          : this.nameNewTxid,
      nameFirstUpdateTxid: data.nameFirstUpdateTxid.present
          ? data.nameFirstUpdateTxid.value
          : this.nameFirstUpdateTxid,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingRegistration(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('saltHex: $saltHex, ')
          ..write('commitmentHex: $commitmentHex, ')
          ..write('nameNewTxid: $nameNewTxid, ')
          ..write('nameFirstUpdateTxid: $nameFirstUpdateTxid, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    saltHex,
    commitmentHex,
    nameNewTxid,
    nameFirstUpdateTxid,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingRegistration &&
          other.id == this.id &&
          other.name == this.name &&
          other.saltHex == this.saltHex &&
          other.commitmentHex == this.commitmentHex &&
          other.nameNewTxid == this.nameNewTxid &&
          other.nameFirstUpdateTxid == this.nameFirstUpdateTxid &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PendingRegistrationsCompanion
    extends UpdateCompanion<PendingRegistration> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> saltHex;
  final Value<String> commitmentHex;
  final Value<String> nameNewTxid;
  final Value<String?> nameFirstUpdateTxid;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PendingRegistrationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.saltHex = const Value.absent(),
    this.commitmentHex = const Value.absent(),
    this.nameNewTxid = const Value.absent(),
    this.nameFirstUpdateTxid = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PendingRegistrationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String saltHex,
    required String commitmentHex,
    required String nameNewTxid,
    this.nameFirstUpdateTxid = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       saltHex = Value(saltHex),
       commitmentHex = Value(commitmentHex),
       nameNewTxid = Value(nameNewTxid),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PendingRegistration> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? saltHex,
    Expression<String>? commitmentHex,
    Expression<String>? nameNewTxid,
    Expression<String>? nameFirstUpdateTxid,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (saltHex != null) 'salt_hex': saltHex,
      if (commitmentHex != null) 'commitment_hex': commitmentHex,
      if (nameNewTxid != null) 'name_new_txid': nameNewTxid,
      if (nameFirstUpdateTxid != null)
        'name_first_update_txid': nameFirstUpdateTxid,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PendingRegistrationsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? saltHex,
    Value<String>? commitmentHex,
    Value<String>? nameNewTxid,
    Value<String?>? nameFirstUpdateTxid,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PendingRegistrationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      saltHex: saltHex ?? this.saltHex,
      commitmentHex: commitmentHex ?? this.commitmentHex,
      nameNewTxid: nameNewTxid ?? this.nameNewTxid,
      nameFirstUpdateTxid: nameFirstUpdateTxid ?? this.nameFirstUpdateTxid,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (saltHex.present) {
      map['salt_hex'] = Variable<String>(saltHex.value);
    }
    if (commitmentHex.present) {
      map['commitment_hex'] = Variable<String>(commitmentHex.value);
    }
    if (nameNewTxid.present) {
      map['name_new_txid'] = Variable<String>(nameNewTxid.value);
    }
    if (nameFirstUpdateTxid.present) {
      map['name_first_update_txid'] = Variable<String>(
        nameFirstUpdateTxid.value,
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingRegistrationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('saltHex: $saltHex, ')
          ..write('commitmentHex: $commitmentHex, ')
          ..write('nameNewTxid: $nameNewTxid, ')
          ..write('nameFirstUpdateTxid: $nameFirstUpdateTxid, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AddressesTable addresses = $AddressesTable(this);
  late final $UtxosTable utxos = $UtxosTable(this);
  late final $CachedTransactionsTable cachedTransactions =
      $CachedTransactionsTable(this);
  late final $TransactionHistoryTable transactionHistory =
      $TransactionHistoryTable(this);
  late final $PendingRegistrationsTable pendingRegistrations =
      $PendingRegistrationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    addresses,
    utxos,
    cachedTransactions,
    transactionHistory,
    pendingRegistrations,
  ];
}

typedef $$AddressesTableCreateCompanionBuilder =
    AddressesCompanion Function({
      required String address,
      required int chain,
      required int indexColumn,
      required String derivationPath,
      required String scriptHash,
      Value<bool> hasHistory,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });
typedef $$AddressesTableUpdateCompanionBuilder =
    AddressesCompanion Function({
      Value<String> address,
      Value<int> chain,
      Value<int> indexColumn,
      Value<String> derivationPath,
      Value<String> scriptHash,
      Value<bool> hasHistory,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });

final class $$AddressesTableReferences
    extends BaseReferences<_$AppDatabase, $AddressesTable, AddressesData> {
  $$AddressesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UtxosTable, List<Utxo>> _utxosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.utxos,
    aliasName: $_aliasNameGenerator(db.addresses.address, db.utxos.address),
  );

  $$UtxosTableProcessedTableManager get utxosRefs {
    final manager = $$UtxosTableTableManager($_db, $_db.utxos).filter(
      (f) => f.address.address.sqlEquals($_itemColumn<String>('address')!),
    );

    final cache = $_typedResult.readTableOrNull(_utxosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AddressesTableFilterComposer
    extends Composer<_$AppDatabase, $AddressesTable> {
  $$AddressesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chain => $composableBuilder(
    column: $table.chain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get indexColumn => $composableBuilder(
    column: $table.indexColumn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get derivationPath => $composableBuilder(
    column: $table.derivationPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scriptHash => $composableBuilder(
    column: $table.scriptHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasHistory => $composableBuilder(
    column: $table.hasHistory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> utxosRefs(
    Expression<bool> Function($$UtxosTableFilterComposer f) f,
  ) {
    final $$UtxosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.address,
      referencedTable: $db.utxos,
      getReferencedColumn: (t) => t.address,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UtxosTableFilterComposer(
            $db: $db,
            $table: $db.utxos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AddressesTableOrderingComposer
    extends Composer<_$AppDatabase, $AddressesTable> {
  $$AddressesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chain => $composableBuilder(
    column: $table.chain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get indexColumn => $composableBuilder(
    column: $table.indexColumn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get derivationPath => $composableBuilder(
    column: $table.derivationPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scriptHash => $composableBuilder(
    column: $table.scriptHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasHistory => $composableBuilder(
    column: $table.hasHistory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AddressesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AddressesTable> {
  $$AddressesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<int> get chain =>
      $composableBuilder(column: $table.chain, builder: (column) => column);

  GeneratedColumn<int> get indexColumn => $composableBuilder(
    column: $table.indexColumn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get derivationPath => $composableBuilder(
    column: $table.derivationPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scriptHash => $composableBuilder(
    column: $table.scriptHash,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasHistory => $composableBuilder(
    column: $table.hasHistory,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  Expression<T> utxosRefs<T extends Object>(
    Expression<T> Function($$UtxosTableAnnotationComposer a) f,
  ) {
    final $$UtxosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.address,
      referencedTable: $db.utxos,
      getReferencedColumn: (t) => t.address,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UtxosTableAnnotationComposer(
            $db: $db,
            $table: $db.utxos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AddressesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AddressesTable,
          AddressesData,
          $$AddressesTableFilterComposer,
          $$AddressesTableOrderingComposer,
          $$AddressesTableAnnotationComposer,
          $$AddressesTableCreateCompanionBuilder,
          $$AddressesTableUpdateCompanionBuilder,
          (AddressesData, $$AddressesTableReferences),
          AddressesData,
          PrefetchHooks Function({bool utxosRefs})
        > {
  $$AddressesTableTableManager(_$AppDatabase db, $AddressesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AddressesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AddressesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AddressesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> address = const Value.absent(),
                Value<int> chain = const Value.absent(),
                Value<int> indexColumn = const Value.absent(),
                Value<String> derivationPath = const Value.absent(),
                Value<String> scriptHash = const Value.absent(),
                Value<bool> hasHistory = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AddressesCompanion(
                address: address,
                chain: chain,
                indexColumn: indexColumn,
                derivationPath: derivationPath,
                scriptHash: scriptHash,
                hasHistory: hasHistory,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String address,
                required int chain,
                required int indexColumn,
                required String derivationPath,
                required String scriptHash,
                Value<bool> hasHistory = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AddressesCompanion.insert(
                address: address,
                chain: chain,
                indexColumn: indexColumn,
                derivationPath: derivationPath,
                scriptHash: scriptHash,
                hasHistory: hasHistory,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AddressesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({utxosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (utxosRefs) db.utxos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (utxosRefs)
                    await $_getPrefetchedData<
                      AddressesData,
                      $AddressesTable,
                      Utxo
                    >(
                      currentTable: table,
                      referencedTable: $$AddressesTableReferences
                          ._utxosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AddressesTableReferences(db, table, p0).utxosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.address == item.address,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AddressesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AddressesTable,
      AddressesData,
      $$AddressesTableFilterComposer,
      $$AddressesTableOrderingComposer,
      $$AddressesTableAnnotationComposer,
      $$AddressesTableCreateCompanionBuilder,
      $$AddressesTableUpdateCompanionBuilder,
      (AddressesData, $$AddressesTableReferences),
      AddressesData,
      PrefetchHooks Function({bool utxosRefs})
    >;
typedef $$UtxosTableCreateCompanionBuilder =
    UtxosCompanion Function({
      required String txid,
      required int vout,
      required int value,
      required String address,
      Value<bool?> isNameUtxo,
      Value<String?> nameOpType,
      Value<String?> nameOpHash,
      Value<String?> nameOpName,
      Value<String?> nameOpValue,
      Value<int> rowid,
    });
typedef $$UtxosTableUpdateCompanionBuilder =
    UtxosCompanion Function({
      Value<String> txid,
      Value<int> vout,
      Value<int> value,
      Value<String> address,
      Value<bool?> isNameUtxo,
      Value<String?> nameOpType,
      Value<String?> nameOpHash,
      Value<String?> nameOpName,
      Value<String?> nameOpValue,
      Value<int> rowid,
    });

final class $$UtxosTableReferences
    extends BaseReferences<_$AppDatabase, $UtxosTable, Utxo> {
  $$UtxosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AddressesTable _addressTable(_$AppDatabase db) =>
      db.addresses.createAlias(
        $_aliasNameGenerator(db.utxos.address, db.addresses.address),
      );

  $$AddressesTableProcessedTableManager get address {
    final $_column = $_itemColumn<String>('address')!;

    final manager = $$AddressesTableTableManager(
      $_db,
      $_db.addresses,
    ).filter((f) => f.address.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_addressTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UtxosTableFilterComposer extends Composer<_$AppDatabase, $UtxosTable> {
  $$UtxosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get txid => $composableBuilder(
    column: $table.txid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vout => $composableBuilder(
    column: $table.vout,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isNameUtxo => $composableBuilder(
    column: $table.isNameUtxo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameOpType => $composableBuilder(
    column: $table.nameOpType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameOpHash => $composableBuilder(
    column: $table.nameOpHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameOpName => $composableBuilder(
    column: $table.nameOpName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameOpValue => $composableBuilder(
    column: $table.nameOpValue,
    builder: (column) => ColumnFilters(column),
  );

  $$AddressesTableFilterComposer get address {
    final $$AddressesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.address,
      referencedTable: $db.addresses,
      getReferencedColumn: (t) => t.address,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AddressesTableFilterComposer(
            $db: $db,
            $table: $db.addresses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UtxosTableOrderingComposer
    extends Composer<_$AppDatabase, $UtxosTable> {
  $$UtxosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get txid => $composableBuilder(
    column: $table.txid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vout => $composableBuilder(
    column: $table.vout,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNameUtxo => $composableBuilder(
    column: $table.isNameUtxo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameOpType => $composableBuilder(
    column: $table.nameOpType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameOpHash => $composableBuilder(
    column: $table.nameOpHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameOpName => $composableBuilder(
    column: $table.nameOpName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameOpValue => $composableBuilder(
    column: $table.nameOpValue,
    builder: (column) => ColumnOrderings(column),
  );

  $$AddressesTableOrderingComposer get address {
    final $$AddressesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.address,
      referencedTable: $db.addresses,
      getReferencedColumn: (t) => t.address,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AddressesTableOrderingComposer(
            $db: $db,
            $table: $db.addresses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UtxosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UtxosTable> {
  $$UtxosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get txid =>
      $composableBuilder(column: $table.txid, builder: (column) => column);

  GeneratedColumn<int> get vout =>
      $composableBuilder(column: $table.vout, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<bool> get isNameUtxo => $composableBuilder(
    column: $table.isNameUtxo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameOpType => $composableBuilder(
    column: $table.nameOpType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameOpHash => $composableBuilder(
    column: $table.nameOpHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameOpName => $composableBuilder(
    column: $table.nameOpName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameOpValue => $composableBuilder(
    column: $table.nameOpValue,
    builder: (column) => column,
  );

  $$AddressesTableAnnotationComposer get address {
    final $$AddressesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.address,
      referencedTable: $db.addresses,
      getReferencedColumn: (t) => t.address,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AddressesTableAnnotationComposer(
            $db: $db,
            $table: $db.addresses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UtxosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UtxosTable,
          Utxo,
          $$UtxosTableFilterComposer,
          $$UtxosTableOrderingComposer,
          $$UtxosTableAnnotationComposer,
          $$UtxosTableCreateCompanionBuilder,
          $$UtxosTableUpdateCompanionBuilder,
          (Utxo, $$UtxosTableReferences),
          Utxo,
          PrefetchHooks Function({bool address})
        > {
  $$UtxosTableTableManager(_$AppDatabase db, $UtxosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UtxosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UtxosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UtxosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> txid = const Value.absent(),
                Value<int> vout = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<bool?> isNameUtxo = const Value.absent(),
                Value<String?> nameOpType = const Value.absent(),
                Value<String?> nameOpHash = const Value.absent(),
                Value<String?> nameOpName = const Value.absent(),
                Value<String?> nameOpValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UtxosCompanion(
                txid: txid,
                vout: vout,
                value: value,
                address: address,
                isNameUtxo: isNameUtxo,
                nameOpType: nameOpType,
                nameOpHash: nameOpHash,
                nameOpName: nameOpName,
                nameOpValue: nameOpValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String txid,
                required int vout,
                required int value,
                required String address,
                Value<bool?> isNameUtxo = const Value.absent(),
                Value<String?> nameOpType = const Value.absent(),
                Value<String?> nameOpHash = const Value.absent(),
                Value<String?> nameOpName = const Value.absent(),
                Value<String?> nameOpValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UtxosCompanion.insert(
                txid: txid,
                vout: vout,
                value: value,
                address: address,
                isNameUtxo: isNameUtxo,
                nameOpType: nameOpType,
                nameOpHash: nameOpHash,
                nameOpName: nameOpName,
                nameOpValue: nameOpValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UtxosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({address = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (address) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.address,
                                referencedTable: $$UtxosTableReferences
                                    ._addressTable(db),
                                referencedColumn: $$UtxosTableReferences
                                    ._addressTable(db)
                                    .address,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UtxosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UtxosTable,
      Utxo,
      $$UtxosTableFilterComposer,
      $$UtxosTableOrderingComposer,
      $$UtxosTableAnnotationComposer,
      $$UtxosTableCreateCompanionBuilder,
      $$UtxosTableUpdateCompanionBuilder,
      (Utxo, $$UtxosTableReferences),
      Utxo,
      PrefetchHooks Function({bool address})
    >;
typedef $$CachedTransactionsTableCreateCompanionBuilder =
    CachedTransactionsCompanion Function({
      required String txid,
      required String rawJson,
      Value<int> height,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$CachedTransactionsTableUpdateCompanionBuilder =
    CachedTransactionsCompanion Function({
      Value<String> txid,
      Value<String> rawJson,
      Value<int> height,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CachedTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedTransactionsTable> {
  $$CachedTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get txid => $composableBuilder(
    column: $table.txid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedTransactionsTable> {
  $$CachedTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get txid => $composableBuilder(
    column: $table.txid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedTransactionsTable> {
  $$CachedTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get txid =>
      $composableBuilder(column: $table.txid, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedTransactionsTable,
          CachedTransaction,
          $$CachedTransactionsTableFilterComposer,
          $$CachedTransactionsTableOrderingComposer,
          $$CachedTransactionsTableAnnotationComposer,
          $$CachedTransactionsTableCreateCompanionBuilder,
          $$CachedTransactionsTableUpdateCompanionBuilder,
          (
            CachedTransaction,
            BaseReferences<
              _$AppDatabase,
              $CachedTransactionsTable,
              CachedTransaction
            >,
          ),
          CachedTransaction,
          PrefetchHooks Function()
        > {
  $$CachedTransactionsTableTableManager(
    _$AppDatabase db,
    $CachedTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> txid = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedTransactionsCompanion(
                txid: txid,
                rawJson: rawJson,
                height: height,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String txid,
                required String rawJson,
                Value<int> height = const Value.absent(),
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedTransactionsCompanion.insert(
                txid: txid,
                rawJson: rawJson,
                height: height,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedTransactionsTable,
      CachedTransaction,
      $$CachedTransactionsTableFilterComposer,
      $$CachedTransactionsTableOrderingComposer,
      $$CachedTransactionsTableAnnotationComposer,
      $$CachedTransactionsTableCreateCompanionBuilder,
      $$CachedTransactionsTableUpdateCompanionBuilder,
      (
        CachedTransaction,
        BaseReferences<
          _$AppDatabase,
          $CachedTransactionsTable,
          CachedTransaction
        >,
      ),
      CachedTransaction,
      PrefetchHooks Function()
    >;
typedef $$TransactionHistoryTableCreateCompanionBuilder =
    TransactionHistoryCompanion Function({
      required String txid,
      Value<int> height,
      Value<int> rowid,
    });
typedef $$TransactionHistoryTableUpdateCompanionBuilder =
    TransactionHistoryCompanion Function({
      Value<String> txid,
      Value<int> height,
      Value<int> rowid,
    });

class $$TransactionHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionHistoryTable> {
  $$TransactionHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get txid => $composableBuilder(
    column: $table.txid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionHistoryTable> {
  $$TransactionHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get txid => $composableBuilder(
    column: $table.txid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionHistoryTable> {
  $$TransactionHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get txid =>
      $composableBuilder(column: $table.txid, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);
}

class $$TransactionHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionHistoryTable,
          TransactionHistoryData,
          $$TransactionHistoryTableFilterComposer,
          $$TransactionHistoryTableOrderingComposer,
          $$TransactionHistoryTableAnnotationComposer,
          $$TransactionHistoryTableCreateCompanionBuilder,
          $$TransactionHistoryTableUpdateCompanionBuilder,
          (
            TransactionHistoryData,
            BaseReferences<
              _$AppDatabase,
              $TransactionHistoryTable,
              TransactionHistoryData
            >,
          ),
          TransactionHistoryData,
          PrefetchHooks Function()
        > {
  $$TransactionHistoryTableTableManager(
    _$AppDatabase db,
    $TransactionHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionHistoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> txid = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionHistoryCompanion(
                txid: txid,
                height: height,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String txid,
                Value<int> height = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionHistoryCompanion.insert(
                txid: txid,
                height: height,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionHistoryTable,
      TransactionHistoryData,
      $$TransactionHistoryTableFilterComposer,
      $$TransactionHistoryTableOrderingComposer,
      $$TransactionHistoryTableAnnotationComposer,
      $$TransactionHistoryTableCreateCompanionBuilder,
      $$TransactionHistoryTableUpdateCompanionBuilder,
      (
        TransactionHistoryData,
        BaseReferences<
          _$AppDatabase,
          $TransactionHistoryTable,
          TransactionHistoryData
        >,
      ),
      TransactionHistoryData,
      PrefetchHooks Function()
    >;
typedef $$PendingRegistrationsTableCreateCompanionBuilder =
    PendingRegistrationsCompanion Function({
      Value<int> id,
      required String name,
      required String saltHex,
      required String commitmentHex,
      required String nameNewTxid,
      Value<String?> nameFirstUpdateTxid,
      Value<String> status,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$PendingRegistrationsTableUpdateCompanionBuilder =
    PendingRegistrationsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> saltHex,
      Value<String> commitmentHex,
      Value<String> nameNewTxid,
      Value<String?> nameFirstUpdateTxid,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$PendingRegistrationsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingRegistrationsTable> {
  $$PendingRegistrationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saltHex => $composableBuilder(
    column: $table.saltHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get commitmentHex => $composableBuilder(
    column: $table.commitmentHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameNewTxid => $composableBuilder(
    column: $table.nameNewTxid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameFirstUpdateTxid => $composableBuilder(
    column: $table.nameFirstUpdateTxid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingRegistrationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingRegistrationsTable> {
  $$PendingRegistrationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saltHex => $composableBuilder(
    column: $table.saltHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get commitmentHex => $composableBuilder(
    column: $table.commitmentHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameNewTxid => $composableBuilder(
    column: $table.nameNewTxid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameFirstUpdateTxid => $composableBuilder(
    column: $table.nameFirstUpdateTxid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingRegistrationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingRegistrationsTable> {
  $$PendingRegistrationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get saltHex =>
      $composableBuilder(column: $table.saltHex, builder: (column) => column);

  GeneratedColumn<String> get commitmentHex => $composableBuilder(
    column: $table.commitmentHex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameNewTxid => $composableBuilder(
    column: $table.nameNewTxid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameFirstUpdateTxid => $composableBuilder(
    column: $table.nameFirstUpdateTxid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PendingRegistrationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingRegistrationsTable,
          PendingRegistration,
          $$PendingRegistrationsTableFilterComposer,
          $$PendingRegistrationsTableOrderingComposer,
          $$PendingRegistrationsTableAnnotationComposer,
          $$PendingRegistrationsTableCreateCompanionBuilder,
          $$PendingRegistrationsTableUpdateCompanionBuilder,
          (
            PendingRegistration,
            BaseReferences<
              _$AppDatabase,
              $PendingRegistrationsTable,
              PendingRegistration
            >,
          ),
          PendingRegistration,
          PrefetchHooks Function()
        > {
  $$PendingRegistrationsTableTableManager(
    _$AppDatabase db,
    $PendingRegistrationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingRegistrationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingRegistrationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PendingRegistrationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> saltHex = const Value.absent(),
                Value<String> commitmentHex = const Value.absent(),
                Value<String> nameNewTxid = const Value.absent(),
                Value<String?> nameFirstUpdateTxid = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PendingRegistrationsCompanion(
                id: id,
                name: name,
                saltHex: saltHex,
                commitmentHex: commitmentHex,
                nameNewTxid: nameNewTxid,
                nameFirstUpdateTxid: nameFirstUpdateTxid,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String saltHex,
                required String commitmentHex,
                required String nameNewTxid,
                Value<String?> nameFirstUpdateTxid = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => PendingRegistrationsCompanion.insert(
                id: id,
                name: name,
                saltHex: saltHex,
                commitmentHex: commitmentHex,
                nameNewTxid: nameNewTxid,
                nameFirstUpdateTxid: nameFirstUpdateTxid,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingRegistrationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingRegistrationsTable,
      PendingRegistration,
      $$PendingRegistrationsTableFilterComposer,
      $$PendingRegistrationsTableOrderingComposer,
      $$PendingRegistrationsTableAnnotationComposer,
      $$PendingRegistrationsTableCreateCompanionBuilder,
      $$PendingRegistrationsTableUpdateCompanionBuilder,
      (
        PendingRegistration,
        BaseReferences<
          _$AppDatabase,
          $PendingRegistrationsTable,
          PendingRegistration
        >,
      ),
      PendingRegistration,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AddressesTableTableManager get addresses =>
      $$AddressesTableTableManager(_db, _db.addresses);
  $$UtxosTableTableManager get utxos =>
      $$UtxosTableTableManager(_db, _db.utxos);
  $$CachedTransactionsTableTableManager get cachedTransactions =>
      $$CachedTransactionsTableTableManager(_db, _db.cachedTransactions);
  $$TransactionHistoryTableTableManager get transactionHistory =>
      $$TransactionHistoryTableTableManager(_db, _db.transactionHistory);
  $$PendingRegistrationsTableTableManager get pendingRegistrations =>
      $$PendingRegistrationsTableTableManager(_db, _db.pendingRegistrations);
}
