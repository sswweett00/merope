// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'developer_database.dart';

// ignore_for_file: type=lint
class $DeveloperAppsTable extends DeveloperApps
    with TableInfo<$DeveloperAppsTable, DeveloperApp> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeveloperAppsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _clientIdNormalizedMeta =
      const VerificationMeta('clientIdNormalized');
  @override
  late final GeneratedColumn<String> clientIdNormalized =
      GeneratedColumn<String>('client_id_normalized', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          $customConstraints: 'UNIQUE NOT NULL');
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        ownerId,
        name,
        description,
        clientId,
        clientIdNormalized,
        data,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'developer_apps';
  @override
  VerificationContext validateIntegrity(Insertable<DeveloperApp> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('client_id_normalized')) {
      context.handle(
          _clientIdNormalizedMeta,
          clientIdNormalized.isAcceptableOrUnknown(
              data['client_id_normalized']!, _clientIdNormalizedMeta));
    } else if (isInserting) {
      context.missing(_clientIdNormalizedMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {id},
        {clientIdNormalized},
      ];
  @override
  DeveloperApp map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeveloperApp(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id'])!,
      clientIdNormalized: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}client_id_normalized'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DeveloperAppsTable createAlias(String alias) {
    return $DeveloperAppsTable(attachedDatabase, alias);
  }
}

class DeveloperApp extends DataClass implements Insertable<DeveloperApp> {
  final String id;
  final String ownerId;
  final String name;
  final String? description;
  final String clientId;
  final String clientIdNormalized;
  final String data;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DeveloperApp(
      {required this.id,
      required this.ownerId,
      required this.name,
      this.description,
      required this.clientId,
      required this.clientIdNormalized,
      required this.data,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['client_id'] = Variable<String>(clientId);
    map['client_id_normalized'] = Variable<String>(clientIdNormalized);
    map['data'] = Variable<String>(data);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DeveloperAppsCompanion toCompanion(bool nullToAbsent) {
    return DeveloperAppsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      clientId: Value(clientId),
      clientIdNormalized: Value(clientIdNormalized),
      data: Value(data),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DeveloperApp.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeveloperApp(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      clientId: serializer.fromJson<String>(json['clientId']),
      clientIdNormalized:
          serializer.fromJson<String>(json['clientIdNormalized']),
      data: serializer.fromJson<String>(json['data']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'clientId': serializer.toJson<String>(clientId),
      'clientIdNormalized': serializer.toJson<String>(clientIdNormalized),
      'data': serializer.toJson<String>(data),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DeveloperApp copyWith(
          {String? id,
          String? ownerId,
          String? name,
          Value<String?> description = const Value.absent(),
          String? clientId,
          String? clientIdNormalized,
          String? data,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DeveloperApp(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        clientId: clientId ?? this.clientId,
        clientIdNormalized: clientIdNormalized ?? this.clientIdNormalized,
        data: data ?? this.data,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DeveloperApp copyWithCompanion(DeveloperAppsCompanion data) {
    return DeveloperApp(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      clientIdNormalized: data.clientIdNormalized.present
          ? data.clientIdNormalized.value
          : this.clientIdNormalized,
      data: data.data.present ? data.data.value : this.data,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeveloperApp(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('clientId: $clientId, ')
          ..write('clientIdNormalized: $clientIdNormalized, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerId, name, description, clientId,
      clientIdNormalized, data, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeveloperApp &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.name == this.name &&
          other.description == this.description &&
          other.clientId == this.clientId &&
          other.clientIdNormalized == this.clientIdNormalized &&
          other.data == this.data &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DeveloperAppsCompanion extends UpdateCompanion<DeveloperApp> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> clientId;
  final Value<String> clientIdNormalized;
  final Value<String> data;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DeveloperAppsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.clientId = const Value.absent(),
    this.clientIdNormalized = const Value.absent(),
    this.data = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeveloperAppsCompanion.insert({
    required String id,
    required String ownerId,
    required String name,
    this.description = const Value.absent(),
    required String clientId,
    required String clientIdNormalized,
    required String data,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        name = Value(name),
        clientId = Value(clientId),
        clientIdNormalized = Value(clientIdNormalized),
        data = Value(data),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<DeveloperApp> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? clientId,
    Expression<String>? clientIdNormalized,
    Expression<String>? data,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (clientId != null) 'client_id': clientId,
      if (clientIdNormalized != null)
        'client_id_normalized': clientIdNormalized,
      if (data != null) 'data': data,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeveloperAppsCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<String>? name,
      Value<String?>? description,
      Value<String>? clientId,
      Value<String>? clientIdNormalized,
      Value<String>? data,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DeveloperAppsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      clientId: clientId ?? this.clientId,
      clientIdNormalized: clientIdNormalized ?? this.clientIdNormalized,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (clientIdNormalized.present) {
      map['client_id_normalized'] = Variable<String>(clientIdNormalized.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeveloperAppsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('clientId: $clientId, ')
          ..write('clientIdNormalized: $clientIdNormalized, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ApiKeysTable extends ApiKeys with TableInfo<$ApiKeysTable, ApiKey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApiKeysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _appIdMeta = const VerificationMeta('appId');
  @override
  late final GeneratedColumn<String> appId = GeneratedColumn<String>(
      'app_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _keyPrefixMeta =
      const VerificationMeta('keyPrefix');
  @override
  late final GeneratedColumn<String> keyPrefix = GeneratedColumn<String>(
      'key_prefix', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scopesMeta = const VerificationMeta('scopes');
  @override
  late final GeneratedColumn<String> scopes = GeneratedColumn<String>(
      'scopes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastUsedAtMeta =
      const VerificationMeta('lastUsedAt');
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
      'last_used_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        appId,
        keyPrefix,
        name,
        scopes,
        data,
        expiresAt,
        createdAt,
        lastUsedAt,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'api_keys';
  @override
  VerificationContext validateIntegrity(Insertable<ApiKey> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('app_id')) {
      context.handle(
          _appIdMeta, appId.isAcceptableOrUnknown(data['app_id']!, _appIdMeta));
    } else if (isInserting) {
      context.missing(_appIdMeta);
    }
    if (data.containsKey('key_prefix')) {
      context.handle(_keyPrefixMeta,
          keyPrefix.isAcceptableOrUnknown(data['key_prefix']!, _keyPrefixMeta));
    } else if (isInserting) {
      context.missing(_keyPrefixMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('scopes')) {
      context.handle(_scopesMeta,
          scopes.isAcceptableOrUnknown(data['scopes']!, _scopesMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
          _lastUsedAtMeta,
          lastUsedAt.isAcceptableOrUnknown(
              data['last_used_at']!, _lastUsedAtMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {id},
      ];
  @override
  ApiKey map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ApiKey(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      appId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_id'])!,
      keyPrefix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key_prefix'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      scopes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scopes']),
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastUsedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_used_at']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $ApiKeysTable createAlias(String alias) {
    return $ApiKeysTable(attachedDatabase, alias);
  }
}

class ApiKey extends DataClass implements Insertable<ApiKey> {
  final String id;
  final String appId;
  final String keyPrefix;
  final String name;
  final String? scopes;
  final String data;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final bool isActive;
  const ApiKey(
      {required this.id,
      required this.appId,
      required this.keyPrefix,
      required this.name,
      this.scopes,
      required this.data,
      this.expiresAt,
      required this.createdAt,
      this.lastUsedAt,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['app_id'] = Variable<String>(appId);
    map['key_prefix'] = Variable<String>(keyPrefix);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || scopes != null) {
      map['scopes'] = Variable<String>(scopes);
    }
    map['data'] = Variable<String>(data);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ApiKeysCompanion toCompanion(bool nullToAbsent) {
    return ApiKeysCompanion(
      id: Value(id),
      appId: Value(appId),
      keyPrefix: Value(keyPrefix),
      name: Value(name),
      scopes:
          scopes == null && nullToAbsent ? const Value.absent() : Value(scopes),
      data: Value(data),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      createdAt: Value(createdAt),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      isActive: Value(isActive),
    );
  }

  factory ApiKey.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ApiKey(
      id: serializer.fromJson<String>(json['id']),
      appId: serializer.fromJson<String>(json['appId']),
      keyPrefix: serializer.fromJson<String>(json['keyPrefix']),
      name: serializer.fromJson<String>(json['name']),
      scopes: serializer.fromJson<String?>(json['scopes']),
      data: serializer.fromJson<String>(json['data']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'appId': serializer.toJson<String>(appId),
      'keyPrefix': serializer.toJson<String>(keyPrefix),
      'name': serializer.toJson<String>(name),
      'scopes': serializer.toJson<String?>(scopes),
      'data': serializer.toJson<String>(data),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ApiKey copyWith(
          {String? id,
          String? appId,
          String? keyPrefix,
          String? name,
          Value<String?> scopes = const Value.absent(),
          String? data,
          Value<DateTime?> expiresAt = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> lastUsedAt = const Value.absent(),
          bool? isActive}) =>
      ApiKey(
        id: id ?? this.id,
        appId: appId ?? this.appId,
        keyPrefix: keyPrefix ?? this.keyPrefix,
        name: name ?? this.name,
        scopes: scopes.present ? scopes.value : this.scopes,
        data: data ?? this.data,
        expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
        createdAt: createdAt ?? this.createdAt,
        lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
        isActive: isActive ?? this.isActive,
      );
  ApiKey copyWithCompanion(ApiKeysCompanion data) {
    return ApiKey(
      id: data.id.present ? data.id.value : this.id,
      appId: data.appId.present ? data.appId.value : this.appId,
      keyPrefix: data.keyPrefix.present ? data.keyPrefix.value : this.keyPrefix,
      name: data.name.present ? data.name.value : this.name,
      scopes: data.scopes.present ? data.scopes.value : this.scopes,
      data: data.data.present ? data.data.value : this.data,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastUsedAt:
          data.lastUsedAt.present ? data.lastUsedAt.value : this.lastUsedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ApiKey(')
          ..write('id: $id, ')
          ..write('appId: $appId, ')
          ..write('keyPrefix: $keyPrefix, ')
          ..write('name: $name, ')
          ..write('scopes: $scopes, ')
          ..write('data: $data, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, appId, keyPrefix, name, scopes, data,
      expiresAt, createdAt, lastUsedAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApiKey &&
          other.id == this.id &&
          other.appId == this.appId &&
          other.keyPrefix == this.keyPrefix &&
          other.name == this.name &&
          other.scopes == this.scopes &&
          other.data == this.data &&
          other.expiresAt == this.expiresAt &&
          other.createdAt == this.createdAt &&
          other.lastUsedAt == this.lastUsedAt &&
          other.isActive == this.isActive);
}

class ApiKeysCompanion extends UpdateCompanion<ApiKey> {
  final Value<String> id;
  final Value<String> appId;
  final Value<String> keyPrefix;
  final Value<String> name;
  final Value<String?> scopes;
  final Value<String> data;
  final Value<DateTime?> expiresAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastUsedAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ApiKeysCompanion({
    this.id = const Value.absent(),
    this.appId = const Value.absent(),
    this.keyPrefix = const Value.absent(),
    this.name = const Value.absent(),
    this.scopes = const Value.absent(),
    this.data = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ApiKeysCompanion.insert({
    required String id,
    required String appId,
    required String keyPrefix,
    required String name,
    this.scopes = const Value.absent(),
    required String data,
    this.expiresAt = const Value.absent(),
    required DateTime createdAt,
    this.lastUsedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        appId = Value(appId),
        keyPrefix = Value(keyPrefix),
        name = Value(name),
        data = Value(data),
        createdAt = Value(createdAt);
  static Insertable<ApiKey> custom({
    Expression<String>? id,
    Expression<String>? appId,
    Expression<String>? keyPrefix,
    Expression<String>? name,
    Expression<String>? scopes,
    Expression<String>? data,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastUsedAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appId != null) 'app_id': appId,
      if (keyPrefix != null) 'key_prefix': keyPrefix,
      if (name != null) 'name': name,
      if (scopes != null) 'scopes': scopes,
      if (data != null) 'data': data,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ApiKeysCompanion copyWith(
      {Value<String>? id,
      Value<String>? appId,
      Value<String>? keyPrefix,
      Value<String>? name,
      Value<String?>? scopes,
      Value<String>? data,
      Value<DateTime?>? expiresAt,
      Value<DateTime>? createdAt,
      Value<DateTime?>? lastUsedAt,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return ApiKeysCompanion(
      id: id ?? this.id,
      appId: appId ?? this.appId,
      keyPrefix: keyPrefix ?? this.keyPrefix,
      name: name ?? this.name,
      scopes: scopes ?? this.scopes,
      data: data ?? this.data,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (appId.present) {
      map['app_id'] = Variable<String>(appId.value);
    }
    if (keyPrefix.present) {
      map['key_prefix'] = Variable<String>(keyPrefix.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (scopes.present) {
      map['scopes'] = Variable<String>(scopes.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApiKeysCompanion(')
          ..write('id: $id, ')
          ..write('appId: $appId, ')
          ..write('keyPrefix: $keyPrefix, ')
          ..write('name: $name, ')
          ..write('scopes: $scopes, ')
          ..write('data: $data, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WebhooksTable extends Webhooks with TableInfo<$WebhooksTable, Webhook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WebhooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _appIdMeta = const VerificationMeta('appId');
  @override
  late final GeneratedColumn<String> appId = GeneratedColumn<String>(
      'app_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetUrlMeta =
      const VerificationMeta('targetUrl');
  @override
  late final GeneratedColumn<String> targetUrl = GeneratedColumn<String>(
      'target_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _eventsMeta = const VerificationMeta('events');
  @override
  late final GeneratedColumn<String> events = GeneratedColumn<String>(
      'events', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        appId,
        name,
        targetUrl,
        events,
        data,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'webhooks';
  @override
  VerificationContext validateIntegrity(Insertable<Webhook> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('app_id')) {
      context.handle(
          _appIdMeta, appId.isAcceptableOrUnknown(data['app_id']!, _appIdMeta));
    } else if (isInserting) {
      context.missing(_appIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_url')) {
      context.handle(_targetUrlMeta,
          targetUrl.isAcceptableOrUnknown(data['target_url']!, _targetUrlMeta));
    } else if (isInserting) {
      context.missing(_targetUrlMeta);
    }
    if (data.containsKey('events')) {
      context.handle(_eventsMeta,
          events.isAcceptableOrUnknown(data['events']!, _eventsMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Webhook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Webhook(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      appId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      targetUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_url'])!,
      events: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}events']),
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $WebhooksTable createAlias(String alias) {
    return $WebhooksTable(attachedDatabase, alias);
  }
}

class Webhook extends DataClass implements Insertable<Webhook> {
  final String id;
  final String appId;
  final String name;
  final String targetUrl;
  final String? events;
  final String data;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Webhook(
      {required this.id,
      required this.appId,
      required this.name,
      required this.targetUrl,
      this.events,
      required this.data,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['app_id'] = Variable<String>(appId);
    map['name'] = Variable<String>(name);
    map['target_url'] = Variable<String>(targetUrl);
    if (!nullToAbsent || events != null) {
      map['events'] = Variable<String>(events);
    }
    map['data'] = Variable<String>(data);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WebhooksCompanion toCompanion(bool nullToAbsent) {
    return WebhooksCompanion(
      id: Value(id),
      appId: Value(appId),
      name: Value(name),
      targetUrl: Value(targetUrl),
      events:
          events == null && nullToAbsent ? const Value.absent() : Value(events),
      data: Value(data),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Webhook.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Webhook(
      id: serializer.fromJson<String>(json['id']),
      appId: serializer.fromJson<String>(json['appId']),
      name: serializer.fromJson<String>(json['name']),
      targetUrl: serializer.fromJson<String>(json['targetUrl']),
      events: serializer.fromJson<String?>(json['events']),
      data: serializer.fromJson<String>(json['data']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'appId': serializer.toJson<String>(appId),
      'name': serializer.toJson<String>(name),
      'targetUrl': serializer.toJson<String>(targetUrl),
      'events': serializer.toJson<String?>(events),
      'data': serializer.toJson<String>(data),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Webhook copyWith(
          {String? id,
          String? appId,
          String? name,
          String? targetUrl,
          Value<String?> events = const Value.absent(),
          String? data,
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Webhook(
        id: id ?? this.id,
        appId: appId ?? this.appId,
        name: name ?? this.name,
        targetUrl: targetUrl ?? this.targetUrl,
        events: events.present ? events.value : this.events,
        data: data ?? this.data,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Webhook copyWithCompanion(WebhooksCompanion data) {
    return Webhook(
      id: data.id.present ? data.id.value : this.id,
      appId: data.appId.present ? data.appId.value : this.appId,
      name: data.name.present ? data.name.value : this.name,
      targetUrl: data.targetUrl.present ? data.targetUrl.value : this.targetUrl,
      events: data.events.present ? data.events.value : this.events,
      data: data.data.present ? data.data.value : this.data,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Webhook(')
          ..write('id: $id, ')
          ..write('appId: $appId, ')
          ..write('name: $name, ')
          ..write('targetUrl: $targetUrl, ')
          ..write('events: $events, ')
          ..write('data: $data, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, appId, name, targetUrl, events, data, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Webhook &&
          other.id == this.id &&
          other.appId == this.appId &&
          other.name == this.name &&
          other.targetUrl == this.targetUrl &&
          other.events == this.events &&
          other.data == this.data &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WebhooksCompanion extends UpdateCompanion<Webhook> {
  final Value<String> id;
  final Value<String> appId;
  final Value<String> name;
  final Value<String> targetUrl;
  final Value<String?> events;
  final Value<String> data;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WebhooksCompanion({
    this.id = const Value.absent(),
    this.appId = const Value.absent(),
    this.name = const Value.absent(),
    this.targetUrl = const Value.absent(),
    this.events = const Value.absent(),
    this.data = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WebhooksCompanion.insert({
    required String id,
    required String appId,
    required String name,
    required String targetUrl,
    this.events = const Value.absent(),
    required String data,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        appId = Value(appId),
        name = Value(name),
        targetUrl = Value(targetUrl),
        data = Value(data),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Webhook> custom({
    Expression<String>? id,
    Expression<String>? appId,
    Expression<String>? name,
    Expression<String>? targetUrl,
    Expression<String>? events,
    Expression<String>? data,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appId != null) 'app_id': appId,
      if (name != null) 'name': name,
      if (targetUrl != null) 'target_url': targetUrl,
      if (events != null) 'events': events,
      if (data != null) 'data': data,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WebhooksCompanion copyWith(
      {Value<String>? id,
      Value<String>? appId,
      Value<String>? name,
      Value<String>? targetUrl,
      Value<String?>? events,
      Value<String>? data,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return WebhooksCompanion(
      id: id ?? this.id,
      appId: appId ?? this.appId,
      name: name ?? this.name,
      targetUrl: targetUrl ?? this.targetUrl,
      events: events ?? this.events,
      data: data ?? this.data,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (appId.present) {
      map['app_id'] = Variable<String>(appId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetUrl.present) {
      map['target_url'] = Variable<String>(targetUrl.value);
    }
    if (events.present) {
      map['events'] = Variable<String>(events.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WebhooksCompanion(')
          ..write('id: $id, ')
          ..write('appId: $appId, ')
          ..write('name: $name, ')
          ..write('targetUrl: $targetUrl, ')
          ..write('events: $events, ')
          ..write('data: $data, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WebhookDeliveryLogsTable extends WebhookDeliveryLogs
    with TableInfo<$WebhookDeliveryLogsTable, WebhookDeliveryLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WebhookDeliveryLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _webhookIdMeta =
      const VerificationMeta('webhookId');
  @override
  late final GeneratedColumn<String> webhookId = GeneratedColumn<String>(
      'webhook_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusCodeMeta =
      const VerificationMeta('statusCode');
  @override
  late final GeneratedColumn<int> statusCode = GeneratedColumn<int>(
      'status_code', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _successMeta =
      const VerificationMeta('success');
  @override
  late final GeneratedColumn<bool> success = GeneratedColumn<bool>(
      'success', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("success" IN (0, 1))'));
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deliveredAtMeta =
      const VerificationMeta('deliveredAt');
  @override
  late final GeneratedColumn<DateTime> deliveredAt = GeneratedColumn<DateTime>(
      'delivered_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, webhookId, payload, statusCode, success, errorMessage, deliveredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'webhook_delivery_logs';
  @override
  VerificationContext validateIntegrity(Insertable<WebhookDeliveryLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('webhook_id')) {
      context.handle(_webhookIdMeta,
          webhookId.isAcceptableOrUnknown(data['webhook_id']!, _webhookIdMeta));
    } else if (isInserting) {
      context.missing(_webhookIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('status_code')) {
      context.handle(
          _statusCodeMeta,
          statusCode.isAcceptableOrUnknown(
              data['status_code']!, _statusCodeMeta));
    } else if (isInserting) {
      context.missing(_statusCodeMeta);
    }
    if (data.containsKey('success')) {
      context.handle(_successMeta,
          success.isAcceptableOrUnknown(data['success']!, _successMeta));
    } else if (isInserting) {
      context.missing(_successMeta);
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    if (data.containsKey('delivered_at')) {
      context.handle(
          _deliveredAtMeta,
          deliveredAt.isAcceptableOrUnknown(
              data['delivered_at']!, _deliveredAtMeta));
    } else if (isInserting) {
      context.missing(_deliveredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  WebhookDeliveryLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WebhookDeliveryLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      webhookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}webhook_id'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      statusCode: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status_code'])!,
      success: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}success'])!,
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
      deliveredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}delivered_at'])!,
    );
  }

  @override
  $WebhookDeliveryLogsTable createAlias(String alias) {
    return $WebhookDeliveryLogsTable(attachedDatabase, alias);
  }
}

class WebhookDeliveryLog extends DataClass
    implements Insertable<WebhookDeliveryLog> {
  final String id;
  final String webhookId;
  final String payload;
  final int statusCode;
  final bool success;
  final String? errorMessage;
  final DateTime deliveredAt;
  const WebhookDeliveryLog(
      {required this.id,
      required this.webhookId,
      required this.payload,
      required this.statusCode,
      required this.success,
      this.errorMessage,
      required this.deliveredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['webhook_id'] = Variable<String>(webhookId);
    map['payload'] = Variable<String>(payload);
    map['status_code'] = Variable<int>(statusCode);
    map['success'] = Variable<bool>(success);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['delivered_at'] = Variable<DateTime>(deliveredAt);
    return map;
  }

  WebhookDeliveryLogsCompanion toCompanion(bool nullToAbsent) {
    return WebhookDeliveryLogsCompanion(
      id: Value(id),
      webhookId: Value(webhookId),
      payload: Value(payload),
      statusCode: Value(statusCode),
      success: Value(success),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      deliveredAt: Value(deliveredAt),
    );
  }

  factory WebhookDeliveryLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WebhookDeliveryLog(
      id: serializer.fromJson<String>(json['id']),
      webhookId: serializer.fromJson<String>(json['webhookId']),
      payload: serializer.fromJson<String>(json['payload']),
      statusCode: serializer.fromJson<int>(json['statusCode']),
      success: serializer.fromJson<bool>(json['success']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      deliveredAt: serializer.fromJson<DateTime>(json['deliveredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'webhookId': serializer.toJson<String>(webhookId),
      'payload': serializer.toJson<String>(payload),
      'statusCode': serializer.toJson<int>(statusCode),
      'success': serializer.toJson<bool>(success),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'deliveredAt': serializer.toJson<DateTime>(deliveredAt),
    };
  }

  WebhookDeliveryLog copyWith(
          {String? id,
          String? webhookId,
          String? payload,
          int? statusCode,
          bool? success,
          Value<String?> errorMessage = const Value.absent(),
          DateTime? deliveredAt}) =>
      WebhookDeliveryLog(
        id: id ?? this.id,
        webhookId: webhookId ?? this.webhookId,
        payload: payload ?? this.payload,
        statusCode: statusCode ?? this.statusCode,
        success: success ?? this.success,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
        deliveredAt: deliveredAt ?? this.deliveredAt,
      );
  WebhookDeliveryLog copyWithCompanion(WebhookDeliveryLogsCompanion data) {
    return WebhookDeliveryLog(
      id: data.id.present ? data.id.value : this.id,
      webhookId: data.webhookId.present ? data.webhookId.value : this.webhookId,
      payload: data.payload.present ? data.payload.value : this.payload,
      statusCode:
          data.statusCode.present ? data.statusCode.value : this.statusCode,
      success: data.success.present ? data.success.value : this.success,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      deliveredAt:
          data.deliveredAt.present ? data.deliveredAt.value : this.deliveredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WebhookDeliveryLog(')
          ..write('id: $id, ')
          ..write('webhookId: $webhookId, ')
          ..write('payload: $payload, ')
          ..write('statusCode: $statusCode, ')
          ..write('success: $success, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('deliveredAt: $deliveredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, webhookId, payload, statusCode, success, errorMessage, deliveredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WebhookDeliveryLog &&
          other.id == this.id &&
          other.webhookId == this.webhookId &&
          other.payload == this.payload &&
          other.statusCode == this.statusCode &&
          other.success == this.success &&
          other.errorMessage == this.errorMessage &&
          other.deliveredAt == this.deliveredAt);
}

class WebhookDeliveryLogsCompanion extends UpdateCompanion<WebhookDeliveryLog> {
  final Value<String> id;
  final Value<String> webhookId;
  final Value<String> payload;
  final Value<int> statusCode;
  final Value<bool> success;
  final Value<String?> errorMessage;
  final Value<DateTime> deliveredAt;
  final Value<int> rowid;
  const WebhookDeliveryLogsCompanion({
    this.id = const Value.absent(),
    this.webhookId = const Value.absent(),
    this.payload = const Value.absent(),
    this.statusCode = const Value.absent(),
    this.success = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WebhookDeliveryLogsCompanion.insert({
    required String id,
    required String webhookId,
    required String payload,
    required int statusCode,
    required bool success,
    this.errorMessage = const Value.absent(),
    required DateTime deliveredAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        webhookId = Value(webhookId),
        payload = Value(payload),
        statusCode = Value(statusCode),
        success = Value(success),
        deliveredAt = Value(deliveredAt);
  static Insertable<WebhookDeliveryLog> custom({
    Expression<String>? id,
    Expression<String>? webhookId,
    Expression<String>? payload,
    Expression<int>? statusCode,
    Expression<bool>? success,
    Expression<String>? errorMessage,
    Expression<DateTime>? deliveredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (webhookId != null) 'webhook_id': webhookId,
      if (payload != null) 'payload': payload,
      if (statusCode != null) 'status_code': statusCode,
      if (success != null) 'success': success,
      if (errorMessage != null) 'error_message': errorMessage,
      if (deliveredAt != null) 'delivered_at': deliveredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WebhookDeliveryLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? webhookId,
      Value<String>? payload,
      Value<int>? statusCode,
      Value<bool>? success,
      Value<String?>? errorMessage,
      Value<DateTime>? deliveredAt,
      Value<int>? rowid}) {
    return WebhookDeliveryLogsCompanion(
      id: id ?? this.id,
      webhookId: webhookId ?? this.webhookId,
      payload: payload ?? this.payload,
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      errorMessage: errorMessage ?? this.errorMessage,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (webhookId.present) {
      map['webhook_id'] = Variable<String>(webhookId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (statusCode.present) {
      map['status_code'] = Variable<int>(statusCode.value);
    }
    if (success.present) {
      map['success'] = Variable<bool>(success.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (deliveredAt.present) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WebhookDeliveryLogsCompanion(')
          ..write('id: $id, ')
          ..write('webhookId: $webhookId, ')
          ..write('payload: $payload, ')
          ..write('statusCode: $statusCode, ')
          ..write('success: $success, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BotsTable extends Bots with TableInfo<$BotsTable, Bot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _appIdMeta = const VerificationMeta('appId');
  @override
  late final GeneratedColumn<String> appId = GeneratedColumn<String>(
      'app_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, appId, name, data, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bots';
  @override
  VerificationContext validateIntegrity(Insertable<Bot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('app_id')) {
      context.handle(
          _appIdMeta, appId.isAcceptableOrUnknown(data['app_id']!, _appIdMeta));
    } else if (isInserting) {
      context.missing(_appIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Bot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bot(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      appId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BotsTable createAlias(String alias) {
    return $BotsTable(attachedDatabase, alias);
  }
}

class Bot extends DataClass implements Insertable<Bot> {
  final String id;
  final String appId;
  final String name;
  final String data;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Bot(
      {required this.id,
      required this.appId,
      required this.name,
      required this.data,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['app_id'] = Variable<String>(appId);
    map['name'] = Variable<String>(name);
    map['data'] = Variable<String>(data);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BotsCompanion toCompanion(bool nullToAbsent) {
    return BotsCompanion(
      id: Value(id),
      appId: Value(appId),
      name: Value(name),
      data: Value(data),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Bot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bot(
      id: serializer.fromJson<String>(json['id']),
      appId: serializer.fromJson<String>(json['appId']),
      name: serializer.fromJson<String>(json['name']),
      data: serializer.fromJson<String>(json['data']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'appId': serializer.toJson<String>(appId),
      'name': serializer.toJson<String>(name),
      'data': serializer.toJson<String>(data),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Bot copyWith(
          {String? id,
          String? appId,
          String? name,
          String? data,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Bot(
        id: id ?? this.id,
        appId: appId ?? this.appId,
        name: name ?? this.name,
        data: data ?? this.data,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Bot copyWithCompanion(BotsCompanion data) {
    return Bot(
      id: data.id.present ? data.id.value : this.id,
      appId: data.appId.present ? data.appId.value : this.appId,
      name: data.name.present ? data.name.value : this.name,
      data: data.data.present ? data.data.value : this.data,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bot(')
          ..write('id: $id, ')
          ..write('appId: $appId, ')
          ..write('name: $name, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, appId, name, data, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bot &&
          other.id == this.id &&
          other.appId == this.appId &&
          other.name == this.name &&
          other.data == this.data &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BotsCompanion extends UpdateCompanion<Bot> {
  final Value<String> id;
  final Value<String> appId;
  final Value<String> name;
  final Value<String> data;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BotsCompanion({
    this.id = const Value.absent(),
    this.appId = const Value.absent(),
    this.name = const Value.absent(),
    this.data = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BotsCompanion.insert({
    required String id,
    required String appId,
    required String name,
    required String data,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        appId = Value(appId),
        name = Value(name),
        data = Value(data),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Bot> custom({
    Expression<String>? id,
    Expression<String>? appId,
    Expression<String>? name,
    Expression<String>? data,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appId != null) 'app_id': appId,
      if (name != null) 'name': name,
      if (data != null) 'data': data,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BotsCompanion copyWith(
      {Value<String>? id,
      Value<String>? appId,
      Value<String>? name,
      Value<String>? data,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return BotsCompanion(
      id: id ?? this.id,
      appId: appId ?? this.appId,
      name: name ?? this.name,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (appId.present) {
      map['app_id'] = Variable<String>(appId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BotsCompanion(')
          ..write('id: $id, ')
          ..write('appId: $appId, ')
          ..write('name: $name, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MetricDataPointsTable extends MetricDataPoints
    with TableInfo<$MetricDataPointsTable, MetricDataPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetricDataPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _appIdMeta = const VerificationMeta('appId');
  @override
  late final GeneratedColumn<String> appId = GeneratedColumn<String>(
      'app_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
      'period', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _metricKeyMeta =
      const VerificationMeta('metricKey');
  @override
  late final GeneratedColumn<String> metricKey = GeneratedColumn<String>(
      'metric_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, appId, period, timestamp, value, label, metricKey];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metric_data_points';
  @override
  VerificationContext validateIntegrity(Insertable<MetricDataPoint> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('app_id')) {
      context.handle(
          _appIdMeta, appId.isAcceptableOrUnknown(data['app_id']!, _appIdMeta));
    } else if (isInserting) {
      context.missing(_appIdMeta);
    }
    if (data.containsKey('period')) {
      context.handle(_periodMeta,
          period.isAcceptableOrUnknown(data['period']!, _periodMeta));
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    }
    if (data.containsKey('metric_key')) {
      context.handle(_metricKeyMeta,
          metricKey.isAcceptableOrUnknown(data['metric_key']!, _metricKeyMeta));
    } else if (isInserting) {
      context.missing(_metricKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  MetricDataPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetricDataPoint(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      appId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_id'])!,
      period: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}period'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label']),
      metricKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metric_key'])!,
    );
  }

  @override
  $MetricDataPointsTable createAlias(String alias) {
    return $MetricDataPointsTable(attachedDatabase, alias);
  }
}

class MetricDataPoint extends DataClass implements Insertable<MetricDataPoint> {
  final String id;
  final String appId;
  final String period;
  final DateTime timestamp;
  final double value;
  final String? label;
  final String metricKey;
  const MetricDataPoint(
      {required this.id,
      required this.appId,
      required this.period,
      required this.timestamp,
      required this.value,
      this.label,
      required this.metricKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['app_id'] = Variable<String>(appId);
    map['period'] = Variable<String>(period);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['value'] = Variable<double>(value);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    map['metric_key'] = Variable<String>(metricKey);
    return map;
  }

  MetricDataPointsCompanion toCompanion(bool nullToAbsent) {
    return MetricDataPointsCompanion(
      id: Value(id),
      appId: Value(appId),
      period: Value(period),
      timestamp: Value(timestamp),
      value: Value(value),
      label:
          label == null && nullToAbsent ? const Value.absent() : Value(label),
      metricKey: Value(metricKey),
    );
  }

  factory MetricDataPoint.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetricDataPoint(
      id: serializer.fromJson<String>(json['id']),
      appId: serializer.fromJson<String>(json['appId']),
      period: serializer.fromJson<String>(json['period']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      value: serializer.fromJson<double>(json['value']),
      label: serializer.fromJson<String?>(json['label']),
      metricKey: serializer.fromJson<String>(json['metricKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'appId': serializer.toJson<String>(appId),
      'period': serializer.toJson<String>(period),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'value': serializer.toJson<double>(value),
      'label': serializer.toJson<String?>(label),
      'metricKey': serializer.toJson<String>(metricKey),
    };
  }

  MetricDataPoint copyWith(
          {String? id,
          String? appId,
          String? period,
          DateTime? timestamp,
          double? value,
          Value<String?> label = const Value.absent(),
          String? metricKey}) =>
      MetricDataPoint(
        id: id ?? this.id,
        appId: appId ?? this.appId,
        period: period ?? this.period,
        timestamp: timestamp ?? this.timestamp,
        value: value ?? this.value,
        label: label.present ? label.value : this.label,
        metricKey: metricKey ?? this.metricKey,
      );
  MetricDataPoint copyWithCompanion(MetricDataPointsCompanion data) {
    return MetricDataPoint(
      id: data.id.present ? data.id.value : this.id,
      appId: data.appId.present ? data.appId.value : this.appId,
      period: data.period.present ? data.period.value : this.period,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      value: data.value.present ? data.value.value : this.value,
      label: data.label.present ? data.label.value : this.label,
      metricKey: data.metricKey.present ? data.metricKey.value : this.metricKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetricDataPoint(')
          ..write('id: $id, ')
          ..write('appId: $appId, ')
          ..write('period: $period, ')
          ..write('timestamp: $timestamp, ')
          ..write('value: $value, ')
          ..write('label: $label, ')
          ..write('metricKey: $metricKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, appId, period, timestamp, value, label, metricKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetricDataPoint &&
          other.id == this.id &&
          other.appId == this.appId &&
          other.period == this.period &&
          other.timestamp == this.timestamp &&
          other.value == this.value &&
          other.label == this.label &&
          other.metricKey == this.metricKey);
}

class MetricDataPointsCompanion extends UpdateCompanion<MetricDataPoint> {
  final Value<String> id;
  final Value<String> appId;
  final Value<String> period;
  final Value<DateTime> timestamp;
  final Value<double> value;
  final Value<String?> label;
  final Value<String> metricKey;
  final Value<int> rowid;
  const MetricDataPointsCompanion({
    this.id = const Value.absent(),
    this.appId = const Value.absent(),
    this.period = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.value = const Value.absent(),
    this.label = const Value.absent(),
    this.metricKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetricDataPointsCompanion.insert({
    required String id,
    required String appId,
    required String period,
    required DateTime timestamp,
    required double value,
    this.label = const Value.absent(),
    required String metricKey,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        appId = Value(appId),
        period = Value(period),
        timestamp = Value(timestamp),
        value = Value(value),
        metricKey = Value(metricKey);
  static Insertable<MetricDataPoint> custom({
    Expression<String>? id,
    Expression<String>? appId,
    Expression<String>? period,
    Expression<DateTime>? timestamp,
    Expression<double>? value,
    Expression<String>? label,
    Expression<String>? metricKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appId != null) 'app_id': appId,
      if (period != null) 'period': period,
      if (timestamp != null) 'timestamp': timestamp,
      if (value != null) 'value': value,
      if (label != null) 'label': label,
      if (metricKey != null) 'metric_key': metricKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetricDataPointsCompanion copyWith(
      {Value<String>? id,
      Value<String>? appId,
      Value<String>? period,
      Value<DateTime>? timestamp,
      Value<double>? value,
      Value<String?>? label,
      Value<String>? metricKey,
      Value<int>? rowid}) {
    return MetricDataPointsCompanion(
      id: id ?? this.id,
      appId: appId ?? this.appId,
      period: period ?? this.period,
      timestamp: timestamp ?? this.timestamp,
      value: value ?? this.value,
      label: label ?? this.label,
      metricKey: metricKey ?? this.metricKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (appId.present) {
      map['app_id'] = Variable<String>(appId.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (metricKey.present) {
      map['metric_key'] = Variable<String>(metricKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetricDataPointsCompanion(')
          ..write('id: $id, ')
          ..write('appId: $appId, ')
          ..write('period: $period, ')
          ..write('timestamp: $timestamp, ')
          ..write('value: $value, ')
          ..write('label: $label, ')
          ..write('metricKey: $metricKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$DeveloperDatabase extends GeneratedDatabase {
  _$DeveloperDatabase(QueryExecutor e) : super(e);
  $DeveloperDatabaseManager get managers => $DeveloperDatabaseManager(this);
  late final $DeveloperAppsTable developerApps = $DeveloperAppsTable(this);
  late final $ApiKeysTable apiKeys = $ApiKeysTable(this);
  late final $WebhooksTable webhooks = $WebhooksTable(this);
  late final $WebhookDeliveryLogsTable webhookDeliveryLogs =
      $WebhookDeliveryLogsTable(this);
  late final $BotsTable bots = $BotsTable(this);
  late final $MetricDataPointsTable metricDataPoints =
      $MetricDataPointsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        developerApps,
        apiKeys,
        webhooks,
        webhookDeliveryLogs,
        bots,
        metricDataPoints
      ];
}

typedef $$DeveloperAppsTableCreateCompanionBuilder = DeveloperAppsCompanion
    Function({
  required String id,
  required String ownerId,
  required String name,
  Value<String?> description,
  required String clientId,
  required String clientIdNormalized,
  required String data,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DeveloperAppsTableUpdateCompanionBuilder = DeveloperAppsCompanion
    Function({
  Value<String> id,
  Value<String> ownerId,
  Value<String> name,
  Value<String?> description,
  Value<String> clientId,
  Value<String> clientIdNormalized,
  Value<String> data,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DeveloperAppsTableTableManager extends RootTableManager<
    _$DeveloperDatabase,
    $DeveloperAppsTable,
    DeveloperApp,
    $$DeveloperAppsTableFilterComposer,
    $$DeveloperAppsTableOrderingComposer,
    $$DeveloperAppsTableCreateCompanionBuilder,
    $$DeveloperAppsTableUpdateCompanionBuilder> {
  $$DeveloperAppsTableTableManager(
      _$DeveloperDatabase db, $DeveloperAppsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$DeveloperAppsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$DeveloperAppsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> clientId = const Value.absent(),
            Value<String> clientIdNormalized = const Value.absent(),
            Value<String> data = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DeveloperAppsCompanion(
            id: id,
            ownerId: ownerId,
            name: name,
            description: description,
            clientId: clientId,
            clientIdNormalized: clientIdNormalized,
            data: data,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required String name,
            Value<String?> description = const Value.absent(),
            required String clientId,
            required String clientIdNormalized,
            required String data,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DeveloperAppsCompanion.insert(
            id: id,
            ownerId: ownerId,
            name: name,
            description: description,
            clientId: clientId,
            clientIdNormalized: clientIdNormalized,
            data: data,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$DeveloperAppsTableFilterComposer
    extends FilterComposer<_$DeveloperDatabase, $DeveloperAppsTable> {
  $$DeveloperAppsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get ownerId => $state.composableBuilder(
      column: $state.table.ownerId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get clientId => $state.composableBuilder(
      column: $state.table.clientId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get clientIdNormalized => $state.composableBuilder(
      column: $state.table.clientIdNormalized,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$DeveloperAppsTableOrderingComposer
    extends OrderingComposer<_$DeveloperDatabase, $DeveloperAppsTable> {
  $$DeveloperAppsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get ownerId => $state.composableBuilder(
      column: $state.table.ownerId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get clientId => $state.composableBuilder(
      column: $state.table.clientId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get clientIdNormalized => $state.composableBuilder(
      column: $state.table.clientIdNormalized,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ApiKeysTableCreateCompanionBuilder = ApiKeysCompanion Function({
  required String id,
  required String appId,
  required String keyPrefix,
  required String name,
  Value<String?> scopes,
  required String data,
  Value<DateTime?> expiresAt,
  required DateTime createdAt,
  Value<DateTime?> lastUsedAt,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$ApiKeysTableUpdateCompanionBuilder = ApiKeysCompanion Function({
  Value<String> id,
  Value<String> appId,
  Value<String> keyPrefix,
  Value<String> name,
  Value<String?> scopes,
  Value<String> data,
  Value<DateTime?> expiresAt,
  Value<DateTime> createdAt,
  Value<DateTime?> lastUsedAt,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$ApiKeysTableTableManager extends RootTableManager<
    _$DeveloperDatabase,
    $ApiKeysTable,
    ApiKey,
    $$ApiKeysTableFilterComposer,
    $$ApiKeysTableOrderingComposer,
    $$ApiKeysTableCreateCompanionBuilder,
    $$ApiKeysTableUpdateCompanionBuilder> {
  $$ApiKeysTableTableManager(_$DeveloperDatabase db, $ApiKeysTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ApiKeysTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ApiKeysTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> appId = const Value.absent(),
            Value<String> keyPrefix = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> scopes = const Value.absent(),
            Value<String> data = const Value.absent(),
            Value<DateTime?> expiresAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastUsedAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ApiKeysCompanion(
            id: id,
            appId: appId,
            keyPrefix: keyPrefix,
            name: name,
            scopes: scopes,
            data: data,
            expiresAt: expiresAt,
            createdAt: createdAt,
            lastUsedAt: lastUsedAt,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String appId,
            required String keyPrefix,
            required String name,
            Value<String?> scopes = const Value.absent(),
            required String data,
            Value<DateTime?> expiresAt = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> lastUsedAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ApiKeysCompanion.insert(
            id: id,
            appId: appId,
            keyPrefix: keyPrefix,
            name: name,
            scopes: scopes,
            data: data,
            expiresAt: expiresAt,
            createdAt: createdAt,
            lastUsedAt: lastUsedAt,
            isActive: isActive,
            rowid: rowid,
          ),
        ));
}

class $$ApiKeysTableFilterComposer
    extends FilterComposer<_$DeveloperDatabase, $ApiKeysTable> {
  $$ApiKeysTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get appId => $state.composableBuilder(
      column: $state.table.appId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get keyPrefix => $state.composableBuilder(
      column: $state.table.keyPrefix,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get scopes => $state.composableBuilder(
      column: $state.table.scopes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get expiresAt => $state.composableBuilder(
      column: $state.table.expiresAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastUsedAt => $state.composableBuilder(
      column: $state.table.lastUsedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ApiKeysTableOrderingComposer
    extends OrderingComposer<_$DeveloperDatabase, $ApiKeysTable> {
  $$ApiKeysTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get appId => $state.composableBuilder(
      column: $state.table.appId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get keyPrefix => $state.composableBuilder(
      column: $state.table.keyPrefix,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get scopes => $state.composableBuilder(
      column: $state.table.scopes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get expiresAt => $state.composableBuilder(
      column: $state.table.expiresAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastUsedAt => $state.composableBuilder(
      column: $state.table.lastUsedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$WebhooksTableCreateCompanionBuilder = WebhooksCompanion Function({
  required String id,
  required String appId,
  required String name,
  required String targetUrl,
  Value<String?> events,
  required String data,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$WebhooksTableUpdateCompanionBuilder = WebhooksCompanion Function({
  Value<String> id,
  Value<String> appId,
  Value<String> name,
  Value<String> targetUrl,
  Value<String?> events,
  Value<String> data,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$WebhooksTableTableManager extends RootTableManager<
    _$DeveloperDatabase,
    $WebhooksTable,
    Webhook,
    $$WebhooksTableFilterComposer,
    $$WebhooksTableOrderingComposer,
    $$WebhooksTableCreateCompanionBuilder,
    $$WebhooksTableUpdateCompanionBuilder> {
  $$WebhooksTableTableManager(_$DeveloperDatabase db, $WebhooksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$WebhooksTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$WebhooksTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> appId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> targetUrl = const Value.absent(),
            Value<String?> events = const Value.absent(),
            Value<String> data = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WebhooksCompanion(
            id: id,
            appId: appId,
            name: name,
            targetUrl: targetUrl,
            events: events,
            data: data,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String appId,
            required String name,
            required String targetUrl,
            Value<String?> events = const Value.absent(),
            required String data,
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              WebhooksCompanion.insert(
            id: id,
            appId: appId,
            name: name,
            targetUrl: targetUrl,
            events: events,
            data: data,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$WebhooksTableFilterComposer
    extends FilterComposer<_$DeveloperDatabase, $WebhooksTable> {
  $$WebhooksTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get appId => $state.composableBuilder(
      column: $state.table.appId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get targetUrl => $state.composableBuilder(
      column: $state.table.targetUrl,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get events => $state.composableBuilder(
      column: $state.table.events,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$WebhooksTableOrderingComposer
    extends OrderingComposer<_$DeveloperDatabase, $WebhooksTable> {
  $$WebhooksTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get appId => $state.composableBuilder(
      column: $state.table.appId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get targetUrl => $state.composableBuilder(
      column: $state.table.targetUrl,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get events => $state.composableBuilder(
      column: $state.table.events,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$WebhookDeliveryLogsTableCreateCompanionBuilder
    = WebhookDeliveryLogsCompanion Function({
  required String id,
  required String webhookId,
  required String payload,
  required int statusCode,
  required bool success,
  Value<String?> errorMessage,
  required DateTime deliveredAt,
  Value<int> rowid,
});
typedef $$WebhookDeliveryLogsTableUpdateCompanionBuilder
    = WebhookDeliveryLogsCompanion Function({
  Value<String> id,
  Value<String> webhookId,
  Value<String> payload,
  Value<int> statusCode,
  Value<bool> success,
  Value<String?> errorMessage,
  Value<DateTime> deliveredAt,
  Value<int> rowid,
});

class $$WebhookDeliveryLogsTableTableManager extends RootTableManager<
    _$DeveloperDatabase,
    $WebhookDeliveryLogsTable,
    WebhookDeliveryLog,
    $$WebhookDeliveryLogsTableFilterComposer,
    $$WebhookDeliveryLogsTableOrderingComposer,
    $$WebhookDeliveryLogsTableCreateCompanionBuilder,
    $$WebhookDeliveryLogsTableUpdateCompanionBuilder> {
  $$WebhookDeliveryLogsTableTableManager(
      _$DeveloperDatabase db, $WebhookDeliveryLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$WebhookDeliveryLogsTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$WebhookDeliveryLogsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> webhookId = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<int> statusCode = const Value.absent(),
            Value<bool> success = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> deliveredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WebhookDeliveryLogsCompanion(
            id: id,
            webhookId: webhookId,
            payload: payload,
            statusCode: statusCode,
            success: success,
            errorMessage: errorMessage,
            deliveredAt: deliveredAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String webhookId,
            required String payload,
            required int statusCode,
            required bool success,
            Value<String?> errorMessage = const Value.absent(),
            required DateTime deliveredAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              WebhookDeliveryLogsCompanion.insert(
            id: id,
            webhookId: webhookId,
            payload: payload,
            statusCode: statusCode,
            success: success,
            errorMessage: errorMessage,
            deliveredAt: deliveredAt,
            rowid: rowid,
          ),
        ));
}

class $$WebhookDeliveryLogsTableFilterComposer
    extends FilterComposer<_$DeveloperDatabase, $WebhookDeliveryLogsTable> {
  $$WebhookDeliveryLogsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get webhookId => $state.composableBuilder(
      column: $state.table.webhookId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get payload => $state.composableBuilder(
      column: $state.table.payload,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statusCode => $state.composableBuilder(
      column: $state.table.statusCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get success => $state.composableBuilder(
      column: $state.table.success,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get errorMessage => $state.composableBuilder(
      column: $state.table.errorMessage,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get deliveredAt => $state.composableBuilder(
      column: $state.table.deliveredAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$WebhookDeliveryLogsTableOrderingComposer
    extends OrderingComposer<_$DeveloperDatabase, $WebhookDeliveryLogsTable> {
  $$WebhookDeliveryLogsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get webhookId => $state.composableBuilder(
      column: $state.table.webhookId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get payload => $state.composableBuilder(
      column: $state.table.payload,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statusCode => $state.composableBuilder(
      column: $state.table.statusCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get success => $state.composableBuilder(
      column: $state.table.success,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get errorMessage => $state.composableBuilder(
      column: $state.table.errorMessage,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get deliveredAt => $state.composableBuilder(
      column: $state.table.deliveredAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$BotsTableCreateCompanionBuilder = BotsCompanion Function({
  required String id,
  required String appId,
  required String name,
  required String data,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$BotsTableUpdateCompanionBuilder = BotsCompanion Function({
  Value<String> id,
  Value<String> appId,
  Value<String> name,
  Value<String> data,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$BotsTableTableManager extends RootTableManager<
    _$DeveloperDatabase,
    $BotsTable,
    Bot,
    $$BotsTableFilterComposer,
    $$BotsTableOrderingComposer,
    $$BotsTableCreateCompanionBuilder,
    $$BotsTableUpdateCompanionBuilder> {
  $$BotsTableTableManager(_$DeveloperDatabase db, $BotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BotsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BotsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> appId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> data = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BotsCompanion(
            id: id,
            appId: appId,
            name: name,
            data: data,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String appId,
            required String name,
            required String data,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BotsCompanion.insert(
            id: id,
            appId: appId,
            name: name,
            data: data,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$BotsTableFilterComposer
    extends FilterComposer<_$DeveloperDatabase, $BotsTable> {
  $$BotsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get appId => $state.composableBuilder(
      column: $state.table.appId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$BotsTableOrderingComposer
    extends OrderingComposer<_$DeveloperDatabase, $BotsTable> {
  $$BotsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get appId => $state.composableBuilder(
      column: $state.table.appId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$MetricDataPointsTableCreateCompanionBuilder
    = MetricDataPointsCompanion Function({
  required String id,
  required String appId,
  required String period,
  required DateTime timestamp,
  required double value,
  Value<String?> label,
  required String metricKey,
  Value<int> rowid,
});
typedef $$MetricDataPointsTableUpdateCompanionBuilder
    = MetricDataPointsCompanion Function({
  Value<String> id,
  Value<String> appId,
  Value<String> period,
  Value<DateTime> timestamp,
  Value<double> value,
  Value<String?> label,
  Value<String> metricKey,
  Value<int> rowid,
});

class $$MetricDataPointsTableTableManager extends RootTableManager<
    _$DeveloperDatabase,
    $MetricDataPointsTable,
    MetricDataPoint,
    $$MetricDataPointsTableFilterComposer,
    $$MetricDataPointsTableOrderingComposer,
    $$MetricDataPointsTableCreateCompanionBuilder,
    $$MetricDataPointsTableUpdateCompanionBuilder> {
  $$MetricDataPointsTableTableManager(
      _$DeveloperDatabase db, $MetricDataPointsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$MetricDataPointsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$MetricDataPointsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> appId = const Value.absent(),
            Value<String> period = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<String?> label = const Value.absent(),
            Value<String> metricKey = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MetricDataPointsCompanion(
            id: id,
            appId: appId,
            period: period,
            timestamp: timestamp,
            value: value,
            label: label,
            metricKey: metricKey,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String appId,
            required String period,
            required DateTime timestamp,
            required double value,
            Value<String?> label = const Value.absent(),
            required String metricKey,
            Value<int> rowid = const Value.absent(),
          }) =>
              MetricDataPointsCompanion.insert(
            id: id,
            appId: appId,
            period: period,
            timestamp: timestamp,
            value: value,
            label: label,
            metricKey: metricKey,
            rowid: rowid,
          ),
        ));
}

class $$MetricDataPointsTableFilterComposer
    extends FilterComposer<_$DeveloperDatabase, $MetricDataPointsTable> {
  $$MetricDataPointsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get appId => $state.composableBuilder(
      column: $state.table.appId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get period => $state.composableBuilder(
      column: $state.table.period,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get label => $state.composableBuilder(
      column: $state.table.label,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get metricKey => $state.composableBuilder(
      column: $state.table.metricKey,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$MetricDataPointsTableOrderingComposer
    extends OrderingComposer<_$DeveloperDatabase, $MetricDataPointsTable> {
  $$MetricDataPointsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get appId => $state.composableBuilder(
      column: $state.table.appId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get period => $state.composableBuilder(
      column: $state.table.period,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get label => $state.composableBuilder(
      column: $state.table.label,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get metricKey => $state.composableBuilder(
      column: $state.table.metricKey,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $DeveloperDatabaseManager {
  final _$DeveloperDatabase _db;
  $DeveloperDatabaseManager(this._db);
  $$DeveloperAppsTableTableManager get developerApps =>
      $$DeveloperAppsTableTableManager(_db, _db.developerApps);
  $$ApiKeysTableTableManager get apiKeys =>
      $$ApiKeysTableTableManager(_db, _db.apiKeys);
  $$WebhooksTableTableManager get webhooks =>
      $$WebhooksTableTableManager(_db, _db.webhooks);
  $$WebhookDeliveryLogsTableTableManager get webhookDeliveryLogs =>
      $$WebhookDeliveryLogsTableTableManager(_db, _db.webhookDeliveryLogs);
  $$BotsTableTableManager get bots => $$BotsTableTableManager(_db, _db.bots);
  $$MetricDataPointsTableTableManager get metricDataPoints =>
      $$MetricDataPointsTableTableManager(_db, _db.metricDataPoints);
}
