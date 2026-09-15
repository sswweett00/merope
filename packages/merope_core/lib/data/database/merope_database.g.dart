// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merope_database.dart';

// ignore_for_file: type=lint
class $OperationLogsTable extends OperationLogs
    with TableInfo<$OperationLogsTable, OperationLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OperationLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _performedByMeta =
      const VerificationMeta('performedBy');
  @override
  late final GeneratedColumn<String> performedBy = GeneratedColumn<String>(
      'performed_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _performedAtMeta =
      const VerificationMeta('performedAt');
  @override
  late final GeneratedColumn<DateTime> performedAt = GeneratedColumn<DateTime>(
      'performed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _clientSequenceMeta =
      const VerificationMeta('clientSequence');
  @override
  late final GeneratedColumn<int> clientSequence = GeneratedColumn<int>(
      'client_sequence', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entityType,
        entityId,
        operation,
        performedBy,
        performedAt,
        metadata,
        clientSequence,
        isSynced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'operation_logs';
  @override
  VerificationContext validateIntegrity(Insertable<OperationLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('performed_by')) {
      context.handle(
          _performedByMeta,
          performedBy.isAcceptableOrUnknown(
              data['performed_by']!, _performedByMeta));
    } else if (isInserting) {
      context.missing(_performedByMeta);
    }
    if (data.containsKey('performed_at')) {
      context.handle(
          _performedAtMeta,
          performedAt.isAcceptableOrUnknown(
              data['performed_at']!, _performedAtMeta));
    } else if (isInserting) {
      context.missing(_performedAtMeta);
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    if (data.containsKey('client_sequence')) {
      context.handle(
          _clientSequenceMeta,
          clientSequence.isAcceptableOrUnknown(
              data['client_sequence']!, _clientSequenceMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  OperationLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OperationLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      performedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}performed_by'])!,
      performedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}performed_at'])!,
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
      clientSequence: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}client_sequence']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
    );
  }

  @override
  $OperationLogsTable createAlias(String alias) {
    return $OperationLogsTable(attachedDatabase, alias);
  }
}

class OperationLog extends DataClass implements Insertable<OperationLog> {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final String performedBy;
  final DateTime performedAt;
  final String? metadata;
  final int? clientSequence;
  final bool isSynced;
  const OperationLog(
      {required this.id,
      required this.entityType,
      required this.entityId,
      required this.operation,
      required this.performedBy,
      required this.performedAt,
      this.metadata,
      this.clientSequence,
      required this.isSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['performed_by'] = Variable<String>(performedBy);
    map['performed_at'] = Variable<DateTime>(performedAt);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    if (!nullToAbsent || clientSequence != null) {
      map['client_sequence'] = Variable<int>(clientSequence);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  OperationLogsCompanion toCompanion(bool nullToAbsent) {
    return OperationLogsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      performedBy: Value(performedBy),
      performedAt: Value(performedAt),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      clientSequence: clientSequence == null && nullToAbsent
          ? const Value.absent()
          : Value(clientSequence),
      isSynced: Value(isSynced),
    );
  }

  factory OperationLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OperationLog(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      performedBy: serializer.fromJson<String>(json['performedBy']),
      performedAt: serializer.fromJson<DateTime>(json['performedAt']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      clientSequence: serializer.fromJson<int?>(json['clientSequence']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'performedBy': serializer.toJson<String>(performedBy),
      'performedAt': serializer.toJson<DateTime>(performedAt),
      'metadata': serializer.toJson<String?>(metadata),
      'clientSequence': serializer.toJson<int?>(clientSequence),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  OperationLog copyWith(
          {String? id,
          String? entityType,
          String? entityId,
          String? operation,
          String? performedBy,
          DateTime? performedAt,
          Value<String?> metadata = const Value.absent(),
          Value<int?> clientSequence = const Value.absent(),
          bool? isSynced}) =>
      OperationLog(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        operation: operation ?? this.operation,
        performedBy: performedBy ?? this.performedBy,
        performedAt: performedAt ?? this.performedAt,
        metadata: metadata.present ? metadata.value : this.metadata,
        clientSequence:
            clientSequence.present ? clientSequence.value : this.clientSequence,
        isSynced: isSynced ?? this.isSynced,
      );
  OperationLog copyWithCompanion(OperationLogsCompanion data) {
    return OperationLog(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      performedBy:
          data.performedBy.present ? data.performedBy.value : this.performedBy,
      performedAt:
          data.performedAt.present ? data.performedAt.value : this.performedAt,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      clientSequence: data.clientSequence.present
          ? data.clientSequence.value
          : this.clientSequence,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OperationLog(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('performedBy: $performedBy, ')
          ..write('performedAt: $performedAt, ')
          ..write('metadata: $metadata, ')
          ..write('clientSequence: $clientSequence, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityType, entityId, operation,
      performedBy, performedAt, metadata, clientSequence, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OperationLog &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.performedBy == this.performedBy &&
          other.performedAt == this.performedAt &&
          other.metadata == this.metadata &&
          other.clientSequence == this.clientSequence &&
          other.isSynced == this.isSynced);
}

class OperationLogsCompanion extends UpdateCompanion<OperationLog> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> performedBy;
  final Value<DateTime> performedAt;
  final Value<String?> metadata;
  final Value<int?> clientSequence;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const OperationLogsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.performedBy = const Value.absent(),
    this.performedAt = const Value.absent(),
    this.metadata = const Value.absent(),
    this.clientSequence = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OperationLogsCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String performedBy,
    required DateTime performedAt,
    this.metadata = const Value.absent(),
    this.clientSequence = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entityType = Value(entityType),
        entityId = Value(entityId),
        operation = Value(operation),
        performedBy = Value(performedBy),
        performedAt = Value(performedAt);
  static Insertable<OperationLog> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? performedBy,
    Expression<DateTime>? performedAt,
    Expression<String>? metadata,
    Expression<int>? clientSequence,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (performedBy != null) 'performed_by': performedBy,
      if (performedAt != null) 'performed_at': performedAt,
      if (metadata != null) 'metadata': metadata,
      if (clientSequence != null) 'client_sequence': clientSequence,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OperationLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? operation,
      Value<String>? performedBy,
      Value<DateTime>? performedAt,
      Value<String?>? metadata,
      Value<int?>? clientSequence,
      Value<bool>? isSynced,
      Value<int>? rowid}) {
    return OperationLogsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      performedBy: performedBy ?? this.performedBy,
      performedAt: performedAt ?? this.performedAt,
      metadata: metadata ?? this.metadata,
      clientSequence: clientSequence ?? this.clientSequence,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (performedBy.present) {
      map['performed_by'] = Variable<String>(performedBy.value);
    }
    if (performedAt.present) {
      map['performed_at'] = Variable<DateTime>(performedAt.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (clientSequence.present) {
      map['client_sequence'] = Variable<int>(clientSequence.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OperationLogsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('performedBy: $performedBy, ')
          ..write('performedAt: $performedAt, ')
          ..write('metadata: $metadata, ')
          ..write('clientSequence: $clientSequence, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
      [id, username, email, passwordHash, avatarUrl, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
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
        {username},
        {email},
      ];
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String username;
  final String email;
  final String passwordHash;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User(
      {required this.id,
      required this.username,
      required this.email,
      required this.passwordHash,
      this.avatarUrl,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    map['email'] = Variable<String>(email);
    map['password_hash'] = Variable<String>(passwordHash);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      email: Value(email),
      passwordHash: Value(passwordHash),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      email: serializer.fromJson<String>(json['email']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'email': serializer.toJson<String>(email),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith(
          {String? id,
          String? username,
          String? email,
          String? passwordHash,
          Value<String?> avatarUrl = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        passwordHash: passwordHash ?? this.passwordHash,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, username, email, passwordHash, avatarUrl, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.email == this.email &&
          other.passwordHash == this.passwordHash &&
          other.avatarUrl == this.avatarUrl &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> username;
  final Value<String> email;
  final Value<String> passwordHash;
  final Value<String?> avatarUrl;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String username,
    required String email,
    required String passwordHash,
    this.avatarUrl = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        username = Value(username),
        email = Value(email),
        passwordHash = Value(passwordHash),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? email,
    Expression<String>? passwordHash,
    Expression<String>? avatarUrl,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? username,
      Value<String>? email,
      Value<String>? passwordHash,
      Value<String?>? avatarUrl,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      avatarUrl: avatarUrl ?? this.avatarUrl,
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
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
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
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _channelIdMeta =
      const VerificationMeta('channelId');
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
      'channel_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorIdMeta =
      const VerificationMeta('authorId');
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
      'author_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorNameMeta =
      const VerificationMeta('authorName');
  @override
  late final GeneratedColumn<String> authorName = GeneratedColumn<String>(
      'author_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _authorAvatarMeta =
      const VerificationMeta('authorAvatar');
  @override
  late final GeneratedColumn<String> authorAvatar = GeneratedColumn<String>(
      'author_avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
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
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isEncryptedMeta =
      const VerificationMeta('isEncrypted');
  @override
  late final GeneratedColumn<bool> isEncrypted = GeneratedColumn<bool>(
      'is_encrypted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_encrypted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _reactionsMeta =
      const VerificationMeta('reactions');
  @override
  late final GeneratedColumn<String> reactions = GeneratedColumn<String>(
      'reactions', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _threadIdMeta =
      const VerificationMeta('threadId');
  @override
  late final GeneratedColumn<String> threadId = GeneratedColumn<String>(
      'thread_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        channelId,
        authorId,
        authorName,
        authorAvatar,
        content,
        createdAt,
        updatedAt,
        isEncrypted,
        reactions,
        threadId,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<Message> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(_channelIdMeta,
          channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta));
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(_authorIdMeta,
          authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta));
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('author_name')) {
      context.handle(
          _authorNameMeta,
          authorName.isAcceptableOrUnknown(
              data['author_name']!, _authorNameMeta));
    }
    if (data.containsKey('author_avatar')) {
      context.handle(
          _authorAvatarMeta,
          authorAvatar.isAcceptableOrUnknown(
              data['author_avatar']!, _authorAvatarMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
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
    }
    if (data.containsKey('is_encrypted')) {
      context.handle(
          _isEncryptedMeta,
          isEncrypted.isAcceptableOrUnknown(
              data['is_encrypted']!, _isEncryptedMeta));
    }
    if (data.containsKey('reactions')) {
      context.handle(_reactionsMeta,
          reactions.isAcceptableOrUnknown(data['reactions']!, _reactionsMeta));
    }
    if (data.containsKey('thread_id')) {
      context.handle(_threadIdMeta,
          threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
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
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      channelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel_id'])!,
      authorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_id'])!,
      authorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_name']),
      authorAvatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_avatar']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isEncrypted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_encrypted'])!,
      reactions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reactions']),
      threadId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thread_id']),
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  final String id;
  final String channelId;
  final String authorId;
  final String? authorName;
  final String? authorAvatar;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEncrypted;
  final String? reactions;
  final String? threadId;
  final int version;
  const Message(
      {required this.id,
      required this.channelId,
      required this.authorId,
      this.authorName,
      this.authorAvatar,
      required this.content,
      required this.createdAt,
      required this.updatedAt,
      required this.isEncrypted,
      this.reactions,
      this.threadId,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['channel_id'] = Variable<String>(channelId);
    map['author_id'] = Variable<String>(authorId);
    if (!nullToAbsent || authorName != null) {
      map['author_name'] = Variable<String>(authorName);
    }
    if (!nullToAbsent || authorAvatar != null) {
      map['author_avatar'] = Variable<String>(authorAvatar);
    }
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_encrypted'] = Variable<bool>(isEncrypted);
    if (!nullToAbsent || reactions != null) {
      map['reactions'] = Variable<String>(reactions);
    }
    if (!nullToAbsent || threadId != null) {
      map['thread_id'] = Variable<String>(threadId);
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      channelId: Value(channelId),
      authorId: Value(authorId),
      authorName: authorName == null && nullToAbsent
          ? const Value.absent()
          : Value(authorName),
      authorAvatar: authorAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(authorAvatar),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isEncrypted: Value(isEncrypted),
      reactions: reactions == null && nullToAbsent
          ? const Value.absent()
          : Value(reactions),
      threadId: threadId == null && nullToAbsent
          ? const Value.absent()
          : Value(threadId),
      version: Value(version),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<String>(json['id']),
      channelId: serializer.fromJson<String>(json['channelId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      authorName: serializer.fromJson<String?>(json['authorName']),
      authorAvatar: serializer.fromJson<String?>(json['authorAvatar']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isEncrypted: serializer.fromJson<bool>(json['isEncrypted']),
      reactions: serializer.fromJson<String?>(json['reactions']),
      threadId: serializer.fromJson<String?>(json['threadId']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'channelId': serializer.toJson<String>(channelId),
      'authorId': serializer.toJson<String>(authorId),
      'authorName': serializer.toJson<String?>(authorName),
      'authorAvatar': serializer.toJson<String?>(authorAvatar),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isEncrypted': serializer.toJson<bool>(isEncrypted),
      'reactions': serializer.toJson<String?>(reactions),
      'threadId': serializer.toJson<String?>(threadId),
      'version': serializer.toJson<int>(version),
    };
  }

  Message copyWith(
          {String? id,
          String? channelId,
          String? authorId,
          Value<String?> authorName = const Value.absent(),
          Value<String?> authorAvatar = const Value.absent(),
          String? content,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? isEncrypted,
          Value<String?> reactions = const Value.absent(),
          Value<String?> threadId = const Value.absent(),
          int? version}) =>
      Message(
        id: id ?? this.id,
        channelId: channelId ?? this.channelId,
        authorId: authorId ?? this.authorId,
        authorName: authorName.present ? authorName.value : this.authorName,
        authorAvatar:
            authorAvatar.present ? authorAvatar.value : this.authorAvatar,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isEncrypted: isEncrypted ?? this.isEncrypted,
        reactions: reactions.present ? reactions.value : this.reactions,
        threadId: threadId.present ? threadId.value : this.threadId,
        version: version ?? this.version,
      );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      id: data.id.present ? data.id.value : this.id,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      authorName:
          data.authorName.present ? data.authorName.value : this.authorName,
      authorAvatar: data.authorAvatar.present
          ? data.authorAvatar.value
          : this.authorAvatar,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isEncrypted:
          data.isEncrypted.present ? data.isEncrypted.value : this.isEncrypted,
      reactions: data.reactions.present ? data.reactions.value : this.reactions,
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('authorId: $authorId, ')
          ..write('authorName: $authorName, ')
          ..write('authorAvatar: $authorAvatar, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('reactions: $reactions, ')
          ..write('threadId: $threadId, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      channelId,
      authorId,
      authorName,
      authorAvatar,
      content,
      createdAt,
      updatedAt,
      isEncrypted,
      reactions,
      threadId,
      version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.channelId == this.channelId &&
          other.authorId == this.authorId &&
          other.authorName == this.authorName &&
          other.authorAvatar == this.authorAvatar &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isEncrypted == this.isEncrypted &&
          other.reactions == this.reactions &&
          other.threadId == this.threadId &&
          other.version == this.version);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<String> id;
  final Value<String> channelId;
  final Value<String> authorId;
  final Value<String?> authorName;
  final Value<String?> authorAvatar;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isEncrypted;
  final Value<String?> reactions;
  final Value<String?> threadId;
  final Value<int> version;
  final Value<int> rowid;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.channelId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.authorName = const Value.absent(),
    this.authorAvatar = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isEncrypted = const Value.absent(),
    this.reactions = const Value.absent(),
    this.threadId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String id,
    required String channelId,
    required String authorId,
    this.authorName = const Value.absent(),
    this.authorAvatar = const Value.absent(),
    required String content,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.isEncrypted = const Value.absent(),
    this.reactions = const Value.absent(),
    this.threadId = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        channelId = Value(channelId),
        authorId = Value(authorId),
        content = Value(content),
        createdAt = Value(createdAt);
  static Insertable<Message> custom({
    Expression<String>? id,
    Expression<String>? channelId,
    Expression<String>? authorId,
    Expression<String>? authorName,
    Expression<String>? authorAvatar,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isEncrypted,
    Expression<String>? reactions,
    Expression<String>? threadId,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (channelId != null) 'channel_id': channelId,
      if (authorId != null) 'author_id': authorId,
      if (authorName != null) 'author_name': authorName,
      if (authorAvatar != null) 'author_avatar': authorAvatar,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isEncrypted != null) 'is_encrypted': isEncrypted,
      if (reactions != null) 'reactions': reactions,
      if (threadId != null) 'thread_id': threadId,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? channelId,
      Value<String>? authorId,
      Value<String?>? authorName,
      Value<String?>? authorAvatar,
      Value<String>? content,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isEncrypted,
      Value<String?>? reactions,
      Value<String?>? threadId,
      Value<int>? version,
      Value<int>? rowid}) {
    return MessagesCompanion(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      reactions: reactions ?? this.reactions,
      threadId: threadId ?? this.threadId,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (authorAvatar.present) {
      map['author_avatar'] = Variable<String>(authorAvatar.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isEncrypted.present) {
      map['is_encrypted'] = Variable<bool>(isEncrypted.value);
    }
    if (reactions.present) {
      map['reactions'] = Variable<String>(reactions.value);
    }
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('authorId: $authorId, ')
          ..write('authorName: $authorName, ')
          ..write('authorAvatar: $authorAvatar, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('reactions: $reactions, ')
          ..write('threadId: $threadId, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubCommunitiesTable extends SubCommunities
    with TableInfo<$SubCommunitiesTable, SubCommunity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubCommunitiesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bannerUrlMeta =
      const VerificationMeta('bannerUrl');
  @override
  late final GeneratedColumn<String> bannerUrl = GeneratedColumn<String>(
      'banner_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isPrivateMeta =
      const VerificationMeta('isPrivate');
  @override
  late final GeneratedColumn<bool> isPrivate = GeneratedColumn<bool>(
      'is_private', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_private" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isVerifiedMeta =
      const VerificationMeta('isVerified');
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
      'is_verified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_verified" IN (0, 1))'),
      defaultValue: const Constant(false));
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
        slug,
        description,
        avatarUrl,
        bannerUrl,
        isPrivate,
        isVerified,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sub_communities';
  @override
  VerificationContext validateIntegrity(Insertable<SubCommunity> instance,
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
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    if (data.containsKey('banner_url')) {
      context.handle(_bannerUrlMeta,
          bannerUrl.isAcceptableOrUnknown(data['banner_url']!, _bannerUrlMeta));
    }
    if (data.containsKey('is_private')) {
      context.handle(_isPrivateMeta,
          isPrivate.isAcceptableOrUnknown(data['is_private']!, _isPrivateMeta));
    }
    if (data.containsKey('is_verified')) {
      context.handle(
          _isVerifiedMeta,
          isVerified.isAcceptableOrUnknown(
              data['is_verified']!, _isVerifiedMeta));
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
  SubCommunity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubCommunity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      bannerUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}banner_url']),
      isPrivate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_private'])!,
      isVerified: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_verified'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SubCommunitiesTable createAlias(String alias) {
    return $SubCommunitiesTable(attachedDatabase, alias);
  }
}

class SubCommunity extends DataClass implements Insertable<SubCommunity> {
  final String id;
  final String ownerId;
  final String name;
  final String slug;
  final String description;
  final String? avatarUrl;
  final String? bannerUrl;
  final bool isPrivate;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SubCommunity(
      {required this.id,
      required this.ownerId,
      required this.name,
      required this.slug,
      required this.description,
      this.avatarUrl,
      this.bannerUrl,
      required this.isPrivate,
      required this.isVerified,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || bannerUrl != null) {
      map['banner_url'] = Variable<String>(bannerUrl);
    }
    map['is_private'] = Variable<bool>(isPrivate);
    map['is_verified'] = Variable<bool>(isVerified);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SubCommunitiesCompanion toCompanion(bool nullToAbsent) {
    return SubCommunitiesCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      name: Value(name),
      slug: Value(slug),
      description: Value(description),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      bannerUrl: bannerUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(bannerUrl),
      isPrivate: Value(isPrivate),
      isVerified: Value(isVerified),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SubCommunity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubCommunity(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      description: serializer.fromJson<String>(json['description']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      bannerUrl: serializer.fromJson<String?>(json['bannerUrl']),
      isPrivate: serializer.fromJson<bool>(json['isPrivate']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
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
      'slug': serializer.toJson<String>(slug),
      'description': serializer.toJson<String>(description),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'bannerUrl': serializer.toJson<String?>(bannerUrl),
      'isPrivate': serializer.toJson<bool>(isPrivate),
      'isVerified': serializer.toJson<bool>(isVerified),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SubCommunity copyWith(
          {String? id,
          String? ownerId,
          String? name,
          String? slug,
          String? description,
          Value<String?> avatarUrl = const Value.absent(),
          Value<String?> bannerUrl = const Value.absent(),
          bool? isPrivate,
          bool? isVerified,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SubCommunity(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        description: description ?? this.description,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        bannerUrl: bannerUrl.present ? bannerUrl.value : this.bannerUrl,
        isPrivate: isPrivate ?? this.isPrivate,
        isVerified: isVerified ?? this.isVerified,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SubCommunity copyWithCompanion(SubCommunitiesCompanion data) {
    return SubCommunity(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      description:
          data.description.present ? data.description.value : this.description,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      bannerUrl: data.bannerUrl.present ? data.bannerUrl.value : this.bannerUrl,
      isPrivate: data.isPrivate.present ? data.isPrivate.value : this.isPrivate,
      isVerified:
          data.isVerified.present ? data.isVerified.value : this.isVerified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubCommunity(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('bannerUrl: $bannerUrl, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('isVerified: $isVerified, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerId, name, slug, description,
      avatarUrl, bannerUrl, isPrivate, isVerified, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubCommunity &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.description == this.description &&
          other.avatarUrl == this.avatarUrl &&
          other.bannerUrl == this.bannerUrl &&
          other.isPrivate == this.isPrivate &&
          other.isVerified == this.isVerified &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubCommunitiesCompanion extends UpdateCompanion<SubCommunity> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> name;
  final Value<String> slug;
  final Value<String> description;
  final Value<String?> avatarUrl;
  final Value<String?> bannerUrl;
  final Value<bool> isPrivate;
  final Value<bool> isVerified;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SubCommunitiesCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.description = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.bannerUrl = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubCommunitiesCompanion.insert({
    required String id,
    required String ownerId,
    required String name,
    required String slug,
    required String description,
    this.avatarUrl = const Value.absent(),
    this.bannerUrl = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.isVerified = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        name = Value(name),
        slug = Value(slug),
        description = Value(description),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SubCommunity> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<String>? description,
    Expression<String>? avatarUrl,
    Expression<String>? bannerUrl,
    Expression<bool>? isPrivate,
    Expression<bool>? isVerified,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (description != null) 'description': description,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (bannerUrl != null) 'banner_url': bannerUrl,
      if (isPrivate != null) 'is_private': isPrivate,
      if (isVerified != null) 'is_verified': isVerified,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubCommunitiesCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<String>? name,
      Value<String>? slug,
      Value<String>? description,
      Value<String?>? avatarUrl,
      Value<String?>? bannerUrl,
      Value<bool>? isPrivate,
      Value<bool>? isVerified,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SubCommunitiesCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      isPrivate: isPrivate ?? this.isPrivate,
      isVerified: isVerified ?? this.isVerified,
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
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (bannerUrl.present) {
      map['banner_url'] = Variable<String>(bannerUrl.value);
    }
    if (isPrivate.present) {
      map['is_private'] = Variable<bool>(isPrivate.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
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
    return (StringBuffer('SubCommunitiesCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('bannerUrl: $bannerUrl, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('isVerified: $isVerified, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommunityMembersTable extends CommunityMembers
    with TableInfo<$CommunityMembersTable, CommunityMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommunityMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _communityIdMeta =
      const VerificationMeta('communityId');
  @override
  late final GeneratedColumn<String> communityId = GeneratedColumn<String>(
      'community_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _joinedAtMeta =
      const VerificationMeta('joinedAt');
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
      'joined_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, communityId, userId, role, joinedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'community_members';
  @override
  VerificationContext validateIntegrity(Insertable<CommunityMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('community_id')) {
      context.handle(
          _communityIdMeta,
          communityId.isAcceptableOrUnknown(
              data['community_id']!, _communityIdMeta));
    } else if (isInserting) {
      context.missing(_communityIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('joined_at')) {
      context.handle(_joinedAtMeta,
          joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta));
    } else if (isInserting) {
      context.missing(_joinedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  CommunityMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommunityMember(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      communityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}community_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      joinedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}joined_at'])!,
    );
  }

  @override
  $CommunityMembersTable createAlias(String alias) {
    return $CommunityMembersTable(attachedDatabase, alias);
  }
}

class CommunityMember extends DataClass implements Insertable<CommunityMember> {
  final String id;
  final String communityId;
  final String userId;
  final String role;
  final DateTime joinedAt;
  const CommunityMember(
      {required this.id,
      required this.communityId,
      required this.userId,
      required this.role,
      required this.joinedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['community_id'] = Variable<String>(communityId);
    map['user_id'] = Variable<String>(userId);
    map['role'] = Variable<String>(role);
    map['joined_at'] = Variable<DateTime>(joinedAt);
    return map;
  }

  CommunityMembersCompanion toCompanion(bool nullToAbsent) {
    return CommunityMembersCompanion(
      id: Value(id),
      communityId: Value(communityId),
      userId: Value(userId),
      role: Value(role),
      joinedAt: Value(joinedAt),
    );
  }

  factory CommunityMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommunityMember(
      id: serializer.fromJson<String>(json['id']),
      communityId: serializer.fromJson<String>(json['communityId']),
      userId: serializer.fromJson<String>(json['userId']),
      role: serializer.fromJson<String>(json['role']),
      joinedAt: serializer.fromJson<DateTime>(json['joinedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'communityId': serializer.toJson<String>(communityId),
      'userId': serializer.toJson<String>(userId),
      'role': serializer.toJson<String>(role),
      'joinedAt': serializer.toJson<DateTime>(joinedAt),
    };
  }

  CommunityMember copyWith(
          {String? id,
          String? communityId,
          String? userId,
          String? role,
          DateTime? joinedAt}) =>
      CommunityMember(
        id: id ?? this.id,
        communityId: communityId ?? this.communityId,
        userId: userId ?? this.userId,
        role: role ?? this.role,
        joinedAt: joinedAt ?? this.joinedAt,
      );
  CommunityMember copyWithCompanion(CommunityMembersCompanion data) {
    return CommunityMember(
      id: data.id.present ? data.id.value : this.id,
      communityId:
          data.communityId.present ? data.communityId.value : this.communityId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommunityMember(')
          ..write('id: $id, ')
          ..write('communityId: $communityId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('joinedAt: $joinedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, communityId, userId, role, joinedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommunityMember &&
          other.id == this.id &&
          other.communityId == this.communityId &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.joinedAt == this.joinedAt);
}

class CommunityMembersCompanion extends UpdateCompanion<CommunityMember> {
  final Value<String> id;
  final Value<String> communityId;
  final Value<String> userId;
  final Value<String> role;
  final Value<DateTime> joinedAt;
  final Value<int> rowid;
  const CommunityMembersCompanion({
    this.id = const Value.absent(),
    this.communityId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommunityMembersCompanion.insert({
    required String id,
    required String communityId,
    required String userId,
    required String role,
    required DateTime joinedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        communityId = Value(communityId),
        userId = Value(userId),
        role = Value(role),
        joinedAt = Value(joinedAt);
  static Insertable<CommunityMember> custom({
    Expression<String>? id,
    Expression<String>? communityId,
    Expression<String>? userId,
    Expression<String>? role,
    Expression<DateTime>? joinedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (communityId != null) 'community_id': communityId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommunityMembersCompanion copyWith(
      {Value<String>? id,
      Value<String>? communityId,
      Value<String>? userId,
      Value<String>? role,
      Value<DateTime>? joinedAt,
      Value<int>? rowid}) {
    return CommunityMembersCompanion(
      id: id ?? this.id,
      communityId: communityId ?? this.communityId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (communityId.present) {
      map['community_id'] = Variable<String>(communityId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommunityMembersCompanion(')
          ..write('id: $id, ')
          ..write('communityId: $communityId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommunityEventsTable extends CommunityEvents
    with TableInfo<$CommunityEventsTable, CommunityEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommunityEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _creatorIdMeta =
      const VerificationMeta('creatorId');
  @override
  late final GeneratedColumn<String> creatorId = GeneratedColumn<String>(
      'creator_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _communityIdMeta =
      const VerificationMeta('communityId');
  @override
  late final GeneratedColumn<String> communityId = GeneratedColumn<String>(
      'community_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _locationNameMeta =
      const VerificationMeta('locationName');
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
      'location_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        creatorId,
        communityId,
        title,
        description,
        startTime,
        endTime,
        locationName,
        latitude,
        longitude,
        status,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'community_events';
  @override
  VerificationContext validateIntegrity(Insertable<CommunityEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('creator_id')) {
      context.handle(_creatorIdMeta,
          creatorId.isAcceptableOrUnknown(data['creator_id']!, _creatorIdMeta));
    } else if (isInserting) {
      context.missing(_creatorIdMeta);
    }
    if (data.containsKey('community_id')) {
      context.handle(
          _communityIdMeta,
          communityId.isAcceptableOrUnknown(
              data['community_id']!, _communityIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('location_name')) {
      context.handle(
          _locationNameMeta,
          locationName.isAcceptableOrUnknown(
              data['location_name']!, _locationNameMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  CommunityEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommunityEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      creatorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}creator_id'])!,
      communityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}community_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time'])!,
      locationName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_name']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CommunityEventsTable createAlias(String alias) {
    return $CommunityEventsTable(attachedDatabase, alias);
  }
}

class CommunityEvent extends DataClass implements Insertable<CommunityEvent> {
  final String id;
  final String creatorId;
  final String? communityId;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String? locationName;
  final double? latitude;
  final double? longitude;
  final String status;
  final DateTime createdAt;
  const CommunityEvent(
      {required this.id,
      required this.creatorId,
      this.communityId,
      required this.title,
      required this.description,
      required this.startTime,
      required this.endTime,
      this.locationName,
      this.latitude,
      this.longitude,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['creator_id'] = Variable<String>(creatorId);
    if (!nullToAbsent || communityId != null) {
      map['community_id'] = Variable<String>(communityId);
    }
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    if (!nullToAbsent || locationName != null) {
      map['location_name'] = Variable<String>(locationName);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CommunityEventsCompanion toCompanion(bool nullToAbsent) {
    return CommunityEventsCompanion(
      id: Value(id),
      creatorId: Value(creatorId),
      communityId: communityId == null && nullToAbsent
          ? const Value.absent()
          : Value(communityId),
      title: Value(title),
      description: Value(description),
      startTime: Value(startTime),
      endTime: Value(endTime),
      locationName: locationName == null && nullToAbsent
          ? const Value.absent()
          : Value(locationName),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory CommunityEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommunityEvent(
      id: serializer.fromJson<String>(json['id']),
      creatorId: serializer.fromJson<String>(json['creatorId']),
      communityId: serializer.fromJson<String?>(json['communityId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      locationName: serializer.fromJson<String?>(json['locationName']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'creatorId': serializer.toJson<String>(creatorId),
      'communityId': serializer.toJson<String?>(communityId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'locationName': serializer.toJson<String?>(locationName),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CommunityEvent copyWith(
          {String? id,
          String? creatorId,
          Value<String?> communityId = const Value.absent(),
          String? title,
          String? description,
          DateTime? startTime,
          DateTime? endTime,
          Value<String?> locationName = const Value.absent(),
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          String? status,
          DateTime? createdAt}) =>
      CommunityEvent(
        id: id ?? this.id,
        creatorId: creatorId ?? this.creatorId,
        communityId: communityId.present ? communityId.value : this.communityId,
        title: title ?? this.title,
        description: description ?? this.description,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        locationName:
            locationName.present ? locationName.value : this.locationName,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  CommunityEvent copyWithCompanion(CommunityEventsCompanion data) {
    return CommunityEvent(
      id: data.id.present ? data.id.value : this.id,
      creatorId: data.creatorId.present ? data.creatorId.value : this.creatorId,
      communityId:
          data.communityId.present ? data.communityId.value : this.communityId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommunityEvent(')
          ..write('id: $id, ')
          ..write('creatorId: $creatorId, ')
          ..write('communityId: $communityId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('locationName: $locationName, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      creatorId,
      communityId,
      title,
      description,
      startTime,
      endTime,
      locationName,
      latitude,
      longitude,
      status,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommunityEvent &&
          other.id == this.id &&
          other.creatorId == this.creatorId &&
          other.communityId == this.communityId &&
          other.title == this.title &&
          other.description == this.description &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.locationName == this.locationName &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class CommunityEventsCompanion extends UpdateCompanion<CommunityEvent> {
  final Value<String> id;
  final Value<String> creatorId;
  final Value<String?> communityId;
  final Value<String> title;
  final Value<String> description;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<String?> locationName;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CommunityEventsCompanion({
    this.id = const Value.absent(),
    this.creatorId = const Value.absent(),
    this.communityId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.locationName = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommunityEventsCompanion.insert({
    required String id,
    required String creatorId,
    this.communityId = const Value.absent(),
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    this.locationName = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    required String status,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        creatorId = Value(creatorId),
        title = Value(title),
        description = Value(description),
        startTime = Value(startTime),
        endTime = Value(endTime),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<CommunityEvent> custom({
    Expression<String>? id,
    Expression<String>? creatorId,
    Expression<String>? communityId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? locationName,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (creatorId != null) 'creator_id': creatorId,
      if (communityId != null) 'community_id': communityId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (locationName != null) 'location_name': locationName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommunityEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? creatorId,
      Value<String?>? communityId,
      Value<String>? title,
      Value<String>? description,
      Value<DateTime>? startTime,
      Value<DateTime>? endTime,
      Value<String?>? locationName,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CommunityEventsCompanion(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      communityId: communityId ?? this.communityId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (creatorId.present) {
      map['creator_id'] = Variable<String>(creatorId.value);
    }
    if (communityId.present) {
      map['community_id'] = Variable<String>(communityId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommunityEventsCompanion(')
          ..write('id: $id, ')
          ..write('creatorId: $creatorId, ')
          ..write('communityId: $communityId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('locationName: $locationName, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CollectivesTable extends Collectives
    with TableInfo<$CollectivesTable, Collective> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectivesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, slug, description, icon, category, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collectives';
  @override
  VerificationContext validateIntegrity(Insertable<Collective> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Collective map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Collective(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CollectivesTable createAlias(String alias) {
    return $CollectivesTable(attachedDatabase, alias);
  }
}

class Collective extends DataClass implements Insertable<Collective> {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String? icon;
  final String category;
  final DateTime createdAt;
  const Collective(
      {required this.id,
      required this.name,
      required this.slug,
      required this.description,
      this.icon,
      required this.category,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['category'] = Variable<String>(category);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CollectivesCompanion toCompanion(bool nullToAbsent) {
    return CollectivesCompanion(
      id: Value(id),
      name: Value(name),
      slug: Value(slug),
      description: Value(description),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      category: Value(category),
      createdAt: Value(createdAt),
    );
  }

  factory Collective.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Collective(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      description: serializer.fromJson<String>(json['description']),
      icon: serializer.fromJson<String?>(json['icon']),
      category: serializer.fromJson<String>(json['category']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'description': serializer.toJson<String>(description),
      'icon': serializer.toJson<String?>(icon),
      'category': serializer.toJson<String>(category),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Collective copyWith(
          {String? id,
          String? name,
          String? slug,
          String? description,
          Value<String?> icon = const Value.absent(),
          String? category,
          DateTime? createdAt}) =>
      Collective(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        description: description ?? this.description,
        icon: icon.present ? icon.value : this.icon,
        category: category ?? this.category,
        createdAt: createdAt ?? this.createdAt,
      );
  Collective copyWithCompanion(CollectivesCompanion data) {
    return Collective(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      description:
          data.description.present ? data.description.value : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Collective(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, slug, description, icon, category, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Collective &&
          other.id == this.id &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.category == this.category &&
          other.createdAt == this.createdAt);
}

class CollectivesCompanion extends UpdateCompanion<Collective> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> slug;
  final Value<String> description;
  final Value<String?> icon;
  final Value<String> category;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CollectivesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CollectivesCompanion.insert({
    required String id,
    required String name,
    required String slug,
    required String description,
    this.icon = const Value.absent(),
    required String category,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        slug = Value(slug),
        description = Value(description),
        category = Value(category),
        createdAt = Value(createdAt);
  static Insertable<Collective> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<String>? category,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (category != null) 'category': category,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CollectivesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? slug,
      Value<String>? description,
      Value<String?>? icon,
      Value<String>? category,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CollectivesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectivesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CollectiveThreadsTable extends CollectiveThreads
    with TableInfo<$CollectiveThreadsTable, CollectiveThread> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectiveThreadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _collectiveIdMeta =
      const VerificationMeta('collectiveId');
  @override
  late final GeneratedColumn<String> collectiveId = GeneratedColumn<String>(
      'collective_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorIdMeta =
      const VerificationMeta('authorId');
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
      'author_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorNameMeta =
      const VerificationMeta('authorName');
  @override
  late final GeneratedColumn<String> authorName = GeneratedColumn<String>(
      'author_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorAvatarMeta =
      const VerificationMeta('authorAvatar');
  @override
  late final GeneratedColumn<String> authorAvatar = GeneratedColumn<String>(
      'author_avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _resonanceMeta =
      const VerificationMeta('resonance');
  @override
  late final GeneratedColumn<int> resonance = GeneratedColumn<int>(
      'resonance', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isPinnedMeta =
      const VerificationMeta('isPinned');
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
      'is_pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isLockedMeta =
      const VerificationMeta('isLocked');
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
      'is_locked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_locked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        collectiveId,
        authorId,
        authorName,
        authorAvatar,
        title,
        content,
        resonance,
        isPinned,
        isLocked,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collective_threads';
  @override
  VerificationContext validateIntegrity(Insertable<CollectiveThread> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('collective_id')) {
      context.handle(
          _collectiveIdMeta,
          collectiveId.isAcceptableOrUnknown(
              data['collective_id']!, _collectiveIdMeta));
    } else if (isInserting) {
      context.missing(_collectiveIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(_authorIdMeta,
          authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta));
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('author_name')) {
      context.handle(
          _authorNameMeta,
          authorName.isAcceptableOrUnknown(
              data['author_name']!, _authorNameMeta));
    } else if (isInserting) {
      context.missing(_authorNameMeta);
    }
    if (data.containsKey('author_avatar')) {
      context.handle(
          _authorAvatarMeta,
          authorAvatar.isAcceptableOrUnknown(
              data['author_avatar']!, _authorAvatarMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('resonance')) {
      context.handle(_resonanceMeta,
          resonance.isAcceptableOrUnknown(data['resonance']!, _resonanceMeta));
    }
    if (data.containsKey('is_pinned')) {
      context.handle(_isPinnedMeta,
          isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta));
    }
    if (data.containsKey('is_locked')) {
      context.handle(_isLockedMeta,
          isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  CollectiveThread map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectiveThread(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      collectiveId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}collective_id'])!,
      authorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_id'])!,
      authorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_name'])!,
      authorAvatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_avatar']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      resonance: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}resonance'])!,
      isPinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_pinned'])!,
      isLocked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_locked'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CollectiveThreadsTable createAlias(String alias) {
    return $CollectiveThreadsTable(attachedDatabase, alias);
  }
}

class CollectiveThread extends DataClass
    implements Insertable<CollectiveThread> {
  final String id;
  final String collectiveId;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String title;
  final String content;
  final int resonance;
  final bool isPinned;
  final bool isLocked;
  final DateTime createdAt;
  const CollectiveThread(
      {required this.id,
      required this.collectiveId,
      required this.authorId,
      required this.authorName,
      this.authorAvatar,
      required this.title,
      required this.content,
      required this.resonance,
      required this.isPinned,
      required this.isLocked,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['collective_id'] = Variable<String>(collectiveId);
    map['author_id'] = Variable<String>(authorId);
    map['author_name'] = Variable<String>(authorName);
    if (!nullToAbsent || authorAvatar != null) {
      map['author_avatar'] = Variable<String>(authorAvatar);
    }
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['resonance'] = Variable<int>(resonance);
    map['is_pinned'] = Variable<bool>(isPinned);
    map['is_locked'] = Variable<bool>(isLocked);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CollectiveThreadsCompanion toCompanion(bool nullToAbsent) {
    return CollectiveThreadsCompanion(
      id: Value(id),
      collectiveId: Value(collectiveId),
      authorId: Value(authorId),
      authorName: Value(authorName),
      authorAvatar: authorAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(authorAvatar),
      title: Value(title),
      content: Value(content),
      resonance: Value(resonance),
      isPinned: Value(isPinned),
      isLocked: Value(isLocked),
      createdAt: Value(createdAt),
    );
  }

  factory CollectiveThread.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectiveThread(
      id: serializer.fromJson<String>(json['id']),
      collectiveId: serializer.fromJson<String>(json['collectiveId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      authorName: serializer.fromJson<String>(json['authorName']),
      authorAvatar: serializer.fromJson<String?>(json['authorAvatar']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      resonance: serializer.fromJson<int>(json['resonance']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'collectiveId': serializer.toJson<String>(collectiveId),
      'authorId': serializer.toJson<String>(authorId),
      'authorName': serializer.toJson<String>(authorName),
      'authorAvatar': serializer.toJson<String?>(authorAvatar),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'resonance': serializer.toJson<int>(resonance),
      'isPinned': serializer.toJson<bool>(isPinned),
      'isLocked': serializer.toJson<bool>(isLocked),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CollectiveThread copyWith(
          {String? id,
          String? collectiveId,
          String? authorId,
          String? authorName,
          Value<String?> authorAvatar = const Value.absent(),
          String? title,
          String? content,
          int? resonance,
          bool? isPinned,
          bool? isLocked,
          DateTime? createdAt}) =>
      CollectiveThread(
        id: id ?? this.id,
        collectiveId: collectiveId ?? this.collectiveId,
        authorId: authorId ?? this.authorId,
        authorName: authorName ?? this.authorName,
        authorAvatar:
            authorAvatar.present ? authorAvatar.value : this.authorAvatar,
        title: title ?? this.title,
        content: content ?? this.content,
        resonance: resonance ?? this.resonance,
        isPinned: isPinned ?? this.isPinned,
        isLocked: isLocked ?? this.isLocked,
        createdAt: createdAt ?? this.createdAt,
      );
  CollectiveThread copyWithCompanion(CollectiveThreadsCompanion data) {
    return CollectiveThread(
      id: data.id.present ? data.id.value : this.id,
      collectiveId: data.collectiveId.present
          ? data.collectiveId.value
          : this.collectiveId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      authorName:
          data.authorName.present ? data.authorName.value : this.authorName,
      authorAvatar: data.authorAvatar.present
          ? data.authorAvatar.value
          : this.authorAvatar,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      resonance: data.resonance.present ? data.resonance.value : this.resonance,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      isLocked: data.isLocked.present ? data.isLocked.value : this.isLocked,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectiveThread(')
          ..write('id: $id, ')
          ..write('collectiveId: $collectiveId, ')
          ..write('authorId: $authorId, ')
          ..write('authorName: $authorName, ')
          ..write('authorAvatar: $authorAvatar, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('resonance: $resonance, ')
          ..write('isPinned: $isPinned, ')
          ..write('isLocked: $isLocked, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, collectiveId, authorId, authorName,
      authorAvatar, title, content, resonance, isPinned, isLocked, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectiveThread &&
          other.id == this.id &&
          other.collectiveId == this.collectiveId &&
          other.authorId == this.authorId &&
          other.authorName == this.authorName &&
          other.authorAvatar == this.authorAvatar &&
          other.title == this.title &&
          other.content == this.content &&
          other.resonance == this.resonance &&
          other.isPinned == this.isPinned &&
          other.isLocked == this.isLocked &&
          other.createdAt == this.createdAt);
}

class CollectiveThreadsCompanion extends UpdateCompanion<CollectiveThread> {
  final Value<String> id;
  final Value<String> collectiveId;
  final Value<String> authorId;
  final Value<String> authorName;
  final Value<String?> authorAvatar;
  final Value<String> title;
  final Value<String> content;
  final Value<int> resonance;
  final Value<bool> isPinned;
  final Value<bool> isLocked;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CollectiveThreadsCompanion({
    this.id = const Value.absent(),
    this.collectiveId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.authorName = const Value.absent(),
    this.authorAvatar = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.resonance = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CollectiveThreadsCompanion.insert({
    required String id,
    required String collectiveId,
    required String authorId,
    required String authorName,
    this.authorAvatar = const Value.absent(),
    required String title,
    required String content,
    this.resonance = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isLocked = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        collectiveId = Value(collectiveId),
        authorId = Value(authorId),
        authorName = Value(authorName),
        title = Value(title),
        content = Value(content),
        createdAt = Value(createdAt);
  static Insertable<CollectiveThread> custom({
    Expression<String>? id,
    Expression<String>? collectiveId,
    Expression<String>? authorId,
    Expression<String>? authorName,
    Expression<String>? authorAvatar,
    Expression<String>? title,
    Expression<String>? content,
    Expression<int>? resonance,
    Expression<bool>? isPinned,
    Expression<bool>? isLocked,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (collectiveId != null) 'collective_id': collectiveId,
      if (authorId != null) 'author_id': authorId,
      if (authorName != null) 'author_name': authorName,
      if (authorAvatar != null) 'author_avatar': authorAvatar,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (resonance != null) 'resonance': resonance,
      if (isPinned != null) 'is_pinned': isPinned,
      if (isLocked != null) 'is_locked': isLocked,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CollectiveThreadsCompanion copyWith(
      {Value<String>? id,
      Value<String>? collectiveId,
      Value<String>? authorId,
      Value<String>? authorName,
      Value<String?>? authorAvatar,
      Value<String>? title,
      Value<String>? content,
      Value<int>? resonance,
      Value<bool>? isPinned,
      Value<bool>? isLocked,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CollectiveThreadsCompanion(
      id: id ?? this.id,
      collectiveId: collectiveId ?? this.collectiveId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      title: title ?? this.title,
      content: content ?? this.content,
      resonance: resonance ?? this.resonance,
      isPinned: isPinned ?? this.isPinned,
      isLocked: isLocked ?? this.isLocked,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (collectiveId.present) {
      map['collective_id'] = Variable<String>(collectiveId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (authorAvatar.present) {
      map['author_avatar'] = Variable<String>(authorAvatar.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (resonance.present) {
      map['resonance'] = Variable<int>(resonance.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectiveThreadsCompanion(')
          ..write('id: $id, ')
          ..write('collectiveId: $collectiveId, ')
          ..write('authorId: $authorId, ')
          ..write('authorName: $authorName, ')
          ..write('authorAvatar: $authorAvatar, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('resonance: $resonance, ')
          ..write('isPinned: $isPinned, ')
          ..write('isLocked: $isLocked, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ThreadRepliesTable extends ThreadReplies
    with TableInfo<$ThreadRepliesTable, ThreadReply> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThreadRepliesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _threadIdMeta =
      const VerificationMeta('threadId');
  @override
  late final GeneratedColumn<String> threadId = GeneratedColumn<String>(
      'thread_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorIdMeta =
      const VerificationMeta('authorId');
  @override
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
      'author_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorNameMeta =
      const VerificationMeta('authorName');
  @override
  late final GeneratedColumn<String> authorName = GeneratedColumn<String>(
      'author_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorAvatarMeta =
      const VerificationMeta('authorAvatar');
  @override
  late final GeneratedColumn<String> authorAvatar = GeneratedColumn<String>(
      'author_avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _resonanceMeta =
      const VerificationMeta('resonance');
  @override
  late final GeneratedColumn<int> resonance = GeneratedColumn<int>(
      'resonance', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        threadId,
        authorId,
        authorName,
        authorAvatar,
        content,
        resonance,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'thread_replies';
  @override
  VerificationContext validateIntegrity(Insertable<ThreadReply> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('thread_id')) {
      context.handle(_threadIdMeta,
          threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta));
    } else if (isInserting) {
      context.missing(_threadIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(_authorIdMeta,
          authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta));
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('author_name')) {
      context.handle(
          _authorNameMeta,
          authorName.isAcceptableOrUnknown(
              data['author_name']!, _authorNameMeta));
    } else if (isInserting) {
      context.missing(_authorNameMeta);
    }
    if (data.containsKey('author_avatar')) {
      context.handle(
          _authorAvatarMeta,
          authorAvatar.isAcceptableOrUnknown(
              data['author_avatar']!, _authorAvatarMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('resonance')) {
      context.handle(_resonanceMeta,
          resonance.isAcceptableOrUnknown(data['resonance']!, _resonanceMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ThreadReply map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ThreadReply(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      threadId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thread_id'])!,
      authorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_id'])!,
      authorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_name'])!,
      authorAvatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_avatar']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      resonance: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}resonance'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ThreadRepliesTable createAlias(String alias) {
    return $ThreadRepliesTable(attachedDatabase, alias);
  }
}

class ThreadReply extends DataClass implements Insertable<ThreadReply> {
  final String id;
  final String threadId;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final int resonance;
  final DateTime createdAt;
  const ThreadReply(
      {required this.id,
      required this.threadId,
      required this.authorId,
      required this.authorName,
      this.authorAvatar,
      required this.content,
      required this.resonance,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['thread_id'] = Variable<String>(threadId);
    map['author_id'] = Variable<String>(authorId);
    map['author_name'] = Variable<String>(authorName);
    if (!nullToAbsent || authorAvatar != null) {
      map['author_avatar'] = Variable<String>(authorAvatar);
    }
    map['content'] = Variable<String>(content);
    map['resonance'] = Variable<int>(resonance);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ThreadRepliesCompanion toCompanion(bool nullToAbsent) {
    return ThreadRepliesCompanion(
      id: Value(id),
      threadId: Value(threadId),
      authorId: Value(authorId),
      authorName: Value(authorName),
      authorAvatar: authorAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(authorAvatar),
      content: Value(content),
      resonance: Value(resonance),
      createdAt: Value(createdAt),
    );
  }

  factory ThreadReply.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ThreadReply(
      id: serializer.fromJson<String>(json['id']),
      threadId: serializer.fromJson<String>(json['threadId']),
      authorId: serializer.fromJson<String>(json['authorId']),
      authorName: serializer.fromJson<String>(json['authorName']),
      authorAvatar: serializer.fromJson<String?>(json['authorAvatar']),
      content: serializer.fromJson<String>(json['content']),
      resonance: serializer.fromJson<int>(json['resonance']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'threadId': serializer.toJson<String>(threadId),
      'authorId': serializer.toJson<String>(authorId),
      'authorName': serializer.toJson<String>(authorName),
      'authorAvatar': serializer.toJson<String?>(authorAvatar),
      'content': serializer.toJson<String>(content),
      'resonance': serializer.toJson<int>(resonance),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ThreadReply copyWith(
          {String? id,
          String? threadId,
          String? authorId,
          String? authorName,
          Value<String?> authorAvatar = const Value.absent(),
          String? content,
          int? resonance,
          DateTime? createdAt}) =>
      ThreadReply(
        id: id ?? this.id,
        threadId: threadId ?? this.threadId,
        authorId: authorId ?? this.authorId,
        authorName: authorName ?? this.authorName,
        authorAvatar:
            authorAvatar.present ? authorAvatar.value : this.authorAvatar,
        content: content ?? this.content,
        resonance: resonance ?? this.resonance,
        createdAt: createdAt ?? this.createdAt,
      );
  ThreadReply copyWithCompanion(ThreadRepliesCompanion data) {
    return ThreadReply(
      id: data.id.present ? data.id.value : this.id,
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      authorName:
          data.authorName.present ? data.authorName.value : this.authorName,
      authorAvatar: data.authorAvatar.present
          ? data.authorAvatar.value
          : this.authorAvatar,
      content: data.content.present ? data.content.value : this.content,
      resonance: data.resonance.present ? data.resonance.value : this.resonance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ThreadReply(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('authorId: $authorId, ')
          ..write('authorName: $authorName, ')
          ..write('authorAvatar: $authorAvatar, ')
          ..write('content: $content, ')
          ..write('resonance: $resonance, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, threadId, authorId, authorName,
      authorAvatar, content, resonance, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThreadReply &&
          other.id == this.id &&
          other.threadId == this.threadId &&
          other.authorId == this.authorId &&
          other.authorName == this.authorName &&
          other.authorAvatar == this.authorAvatar &&
          other.content == this.content &&
          other.resonance == this.resonance &&
          other.createdAt == this.createdAt);
}

class ThreadRepliesCompanion extends UpdateCompanion<ThreadReply> {
  final Value<String> id;
  final Value<String> threadId;
  final Value<String> authorId;
  final Value<String> authorName;
  final Value<String?> authorAvatar;
  final Value<String> content;
  final Value<int> resonance;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ThreadRepliesCompanion({
    this.id = const Value.absent(),
    this.threadId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.authorName = const Value.absent(),
    this.authorAvatar = const Value.absent(),
    this.content = const Value.absent(),
    this.resonance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ThreadRepliesCompanion.insert({
    required String id,
    required String threadId,
    required String authorId,
    required String authorName,
    this.authorAvatar = const Value.absent(),
    required String content,
    this.resonance = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        threadId = Value(threadId),
        authorId = Value(authorId),
        authorName = Value(authorName),
        content = Value(content),
        createdAt = Value(createdAt);
  static Insertable<ThreadReply> custom({
    Expression<String>? id,
    Expression<String>? threadId,
    Expression<String>? authorId,
    Expression<String>? authorName,
    Expression<String>? authorAvatar,
    Expression<String>? content,
    Expression<int>? resonance,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (threadId != null) 'thread_id': threadId,
      if (authorId != null) 'author_id': authorId,
      if (authorName != null) 'author_name': authorName,
      if (authorAvatar != null) 'author_avatar': authorAvatar,
      if (content != null) 'content': content,
      if (resonance != null) 'resonance': resonance,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ThreadRepliesCompanion copyWith(
      {Value<String>? id,
      Value<String>? threadId,
      Value<String>? authorId,
      Value<String>? authorName,
      Value<String?>? authorAvatar,
      Value<String>? content,
      Value<int>? resonance,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ThreadRepliesCompanion(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      resonance: resonance ?? this.resonance,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (authorAvatar.present) {
      map['author_avatar'] = Variable<String>(authorAvatar.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (resonance.present) {
      map['resonance'] = Variable<int>(resonance.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThreadRepliesCompanion(')
          ..write('id: $id, ')
          ..write('threadId: $threadId, ')
          ..write('authorId: $authorId, ')
          ..write('authorName: $authorName, ')
          ..write('authorAvatar: $authorAvatar, ')
          ..write('content: $content, ')
          ..write('resonance: $resonance, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fromAccountIdMeta =
      const VerificationMeta('fromAccountId');
  @override
  late final GeneratedColumn<String> fromAccountId = GeneratedColumn<String>(
      'from_account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _toAccountIdMeta =
      const VerificationMeta('toAccountId');
  @override
  late final GeneratedColumn<String> toAccountId = GeneratedColumn<String>(
      'to_account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _feeMeta = const VerificationMeta('fee');
  @override
  late final GeneratedColumn<double> fee = GeneratedColumn<double>(
      'fee', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _receiptUrlMeta =
      const VerificationMeta('receiptUrl');
  @override
  late final GeneratedColumn<String> receiptUrl = GeneratedColumn<String>(
      'receipt_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fraudScoreMeta =
      const VerificationMeta('fraudScore');
  @override
  late final GeneratedColumn<double> fraudScore = GeneratedColumn<double>(
      'fraud_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fromAccountId,
        toAccountId,
        amount,
        currency,
        status,
        createdAt,
        fee,
        category,
        receiptUrl,
        fraudScore,
        metadata
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('from_account_id')) {
      context.handle(
          _fromAccountIdMeta,
          fromAccountId.isAcceptableOrUnknown(
              data['from_account_id']!, _fromAccountIdMeta));
    } else if (isInserting) {
      context.missing(_fromAccountIdMeta);
    }
    if (data.containsKey('to_account_id')) {
      context.handle(
          _toAccountIdMeta,
          toAccountId.isAcceptableOrUnknown(
              data['to_account_id']!, _toAccountIdMeta));
    } else if (isInserting) {
      context.missing(_toAccountIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('fee')) {
      context.handle(
          _feeMeta, fee.isAcceptableOrUnknown(data['fee']!, _feeMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('receipt_url')) {
      context.handle(
          _receiptUrlMeta,
          receiptUrl.isAcceptableOrUnknown(
              data['receipt_url']!, _receiptUrlMeta));
    }
    if (data.containsKey('fraud_score')) {
      context.handle(
          _fraudScoreMeta,
          fraudScore.isAcceptableOrUnknown(
              data['fraud_score']!, _fraudScoreMeta));
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fromAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}from_account_id'])!,
      toAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_account_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      fee: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fee']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      receiptUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receipt_url']),
      fraudScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fraud_score']),
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String fromAccountId;
  final String toAccountId;
  final double amount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final double? fee;
  final String? category;
  final String? receiptUrl;
  final double? fraudScore;
  final String? metadata;
  const Transaction(
      {required this.id,
      required this.fromAccountId,
      required this.toAccountId,
      required this.amount,
      required this.currency,
      required this.status,
      required this.createdAt,
      this.fee,
      this.category,
      this.receiptUrl,
      this.fraudScore,
      this.metadata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['from_account_id'] = Variable<String>(fromAccountId);
    map['to_account_id'] = Variable<String>(toAccountId);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || fee != null) {
      map['fee'] = Variable<double>(fee);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || receiptUrl != null) {
      map['receipt_url'] = Variable<String>(receiptUrl);
    }
    if (!nullToAbsent || fraudScore != null) {
      map['fraud_score'] = Variable<double>(fraudScore);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      fromAccountId: Value(fromAccountId),
      toAccountId: Value(toAccountId),
      amount: Value(amount),
      currency: Value(currency),
      status: Value(status),
      createdAt: Value(createdAt),
      fee: fee == null && nullToAbsent ? const Value.absent() : Value(fee),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      receiptUrl: receiptUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptUrl),
      fraudScore: fraudScore == null && nullToAbsent
          ? const Value.absent()
          : Value(fraudScore),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      fromAccountId: serializer.fromJson<String>(json['fromAccountId']),
      toAccountId: serializer.fromJson<String>(json['toAccountId']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      fee: serializer.fromJson<double?>(json['fee']),
      category: serializer.fromJson<String?>(json['category']),
      receiptUrl: serializer.fromJson<String?>(json['receiptUrl']),
      fraudScore: serializer.fromJson<double?>(json['fraudScore']),
      metadata: serializer.fromJson<String?>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fromAccountId': serializer.toJson<String>(fromAccountId),
      'toAccountId': serializer.toJson<String>(toAccountId),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'fee': serializer.toJson<double?>(fee),
      'category': serializer.toJson<String?>(category),
      'receiptUrl': serializer.toJson<String?>(receiptUrl),
      'fraudScore': serializer.toJson<double?>(fraudScore),
      'metadata': serializer.toJson<String?>(metadata),
    };
  }

  Transaction copyWith(
          {String? id,
          String? fromAccountId,
          String? toAccountId,
          double? amount,
          String? currency,
          String? status,
          DateTime? createdAt,
          Value<double?> fee = const Value.absent(),
          Value<String?> category = const Value.absent(),
          Value<String?> receiptUrl = const Value.absent(),
          Value<double?> fraudScore = const Value.absent(),
          Value<String?> metadata = const Value.absent()}) =>
      Transaction(
        id: id ?? this.id,
        fromAccountId: fromAccountId ?? this.fromAccountId,
        toAccountId: toAccountId ?? this.toAccountId,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        fee: fee.present ? fee.value : this.fee,
        category: category.present ? category.value : this.category,
        receiptUrl: receiptUrl.present ? receiptUrl.value : this.receiptUrl,
        fraudScore: fraudScore.present ? fraudScore.value : this.fraudScore,
        metadata: metadata.present ? metadata.value : this.metadata,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      fromAccountId: data.fromAccountId.present
          ? data.fromAccountId.value
          : this.fromAccountId,
      toAccountId:
          data.toAccountId.present ? data.toAccountId.value : this.toAccountId,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      fee: data.fee.present ? data.fee.value : this.fee,
      category: data.category.present ? data.category.value : this.category,
      receiptUrl:
          data.receiptUrl.present ? data.receiptUrl.value : this.receiptUrl,
      fraudScore:
          data.fraudScore.present ? data.fraudScore.value : this.fraudScore,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('fee: $fee, ')
          ..write('category: $category, ')
          ..write('receiptUrl: $receiptUrl, ')
          ..write('fraudScore: $fraudScore, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      fromAccountId,
      toAccountId,
      amount,
      currency,
      status,
      createdAt,
      fee,
      category,
      receiptUrl,
      fraudScore,
      metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.fromAccountId == this.fromAccountId &&
          other.toAccountId == this.toAccountId &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.fee == this.fee &&
          other.category == this.category &&
          other.receiptUrl == this.receiptUrl &&
          other.fraudScore == this.fraudScore &&
          other.metadata == this.metadata);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String> fromAccountId;
  final Value<String> toAccountId;
  final Value<double> amount;
  final Value<String> currency;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<double?> fee;
  final Value<String?> category;
  final Value<String?> receiptUrl;
  final Value<double?> fraudScore;
  final Value<String?> metadata;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.fromAccountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.fee = const Value.absent(),
    this.category = const Value.absent(),
    this.receiptUrl = const Value.absent(),
    this.fraudScore = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String fromAccountId,
    required String toAccountId,
    required double amount,
    required String currency,
    required String status,
    required DateTime createdAt,
    this.fee = const Value.absent(),
    this.category = const Value.absent(),
    this.receiptUrl = const Value.absent(),
    this.fraudScore = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        fromAccountId = Value(fromAccountId),
        toAccountId = Value(toAccountId),
        amount = Value(amount),
        currency = Value(currency),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? fromAccountId,
    Expression<String>? toAccountId,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<double>? fee,
    Expression<String>? category,
    Expression<String>? receiptUrl,
    Expression<double>? fraudScore,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromAccountId != null) 'from_account_id': fromAccountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (fee != null) 'fee': fee,
      if (category != null) 'category': category,
      if (receiptUrl != null) 'receipt_url': receiptUrl,
      if (fraudScore != null) 'fraud_score': fraudScore,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? fromAccountId,
      Value<String>? toAccountId,
      Value<double>? amount,
      Value<String>? currency,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<double?>? fee,
      Value<String?>? category,
      Value<String?>? receiptUrl,
      Value<double?>? fraudScore,
      Value<String?>? metadata,
      Value<int>? rowid}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      toAccountId: toAccountId ?? this.toAccountId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      fee: fee ?? this.fee,
      category: category ?? this.category,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      fraudScore: fraudScore ?? this.fraudScore,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fromAccountId.present) {
      map['from_account_id'] = Variable<String>(fromAccountId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<String>(toAccountId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (fee.present) {
      map['fee'] = Variable<double>(fee.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (receiptUrl.present) {
      map['receipt_url'] = Variable<String>(receiptUrl.value);
    }
    if (fraudScore.present) {
      map['fraud_score'] = Variable<double>(fraudScore.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('fee: $fee, ')
          ..write('category: $category, ')
          ..write('receiptUrl: $receiptUrl, ')
          ..write('fraudScore: $fraudScore, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AudioTracksTable extends AudioTracks
    with TableInfo<$AudioTracksTable, AudioTrack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AudioTracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
      'artist', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _audioUrlMeta =
      const VerificationMeta('audioUrl');
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
      'audio_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, artist, audioUrl, durationSeconds];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audio_tracks';
  @override
  VerificationContext validateIntegrity(Insertable<AudioTrack> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('artist')) {
      context.handle(_artistMeta,
          artist.isAcceptableOrUnknown(data['artist']!, _artistMeta));
    } else if (isInserting) {
      context.missing(_artistMeta);
    }
    if (data.containsKey('audio_url')) {
      context.handle(_audioUrlMeta,
          audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta));
    } else if (isInserting) {
      context.missing(_audioUrlMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  AudioTrack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AudioTrack(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      artist: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist'])!,
      audioUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_url'])!,
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
    );
  }

  @override
  $AudioTracksTable createAlias(String alias) {
    return $AudioTracksTable(attachedDatabase, alias);
  }
}

class AudioTrack extends DataClass implements Insertable<AudioTrack> {
  final String id;
  final String title;
  final String artist;
  final String audioUrl;
  final int durationSeconds;
  const AudioTrack(
      {required this.id,
      required this.title,
      required this.artist,
      required this.audioUrl,
      required this.durationSeconds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['artist'] = Variable<String>(artist);
    map['audio_url'] = Variable<String>(audioUrl);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    return map;
  }

  AudioTracksCompanion toCompanion(bool nullToAbsent) {
    return AudioTracksCompanion(
      id: Value(id),
      title: Value(title),
      artist: Value(artist),
      audioUrl: Value(audioUrl),
      durationSeconds: Value(durationSeconds),
    );
  }

  factory AudioTrack.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudioTrack(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      artist: serializer.fromJson<String>(json['artist']),
      audioUrl: serializer.fromJson<String>(json['audioUrl']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'artist': serializer.toJson<String>(artist),
      'audioUrl': serializer.toJson<String>(audioUrl),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
    };
  }

  AudioTrack copyWith(
          {String? id,
          String? title,
          String? artist,
          String? audioUrl,
          int? durationSeconds}) =>
      AudioTrack(
        id: id ?? this.id,
        title: title ?? this.title,
        artist: artist ?? this.artist,
        audioUrl: audioUrl ?? this.audioUrl,
        durationSeconds: durationSeconds ?? this.durationSeconds,
      );
  AudioTrack copyWithCompanion(AudioTracksCompanion data) {
    return AudioTrack(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      artist: data.artist.present ? data.artist.value : this.artist,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AudioTrack(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, artist, audioUrl, durationSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioTrack &&
          other.id == this.id &&
          other.title == this.title &&
          other.artist == this.artist &&
          other.audioUrl == this.audioUrl &&
          other.durationSeconds == this.durationSeconds);
}

class AudioTracksCompanion extends UpdateCompanion<AudioTrack> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> artist;
  final Value<String> audioUrl;
  final Value<int> durationSeconds;
  final Value<int> rowid;
  const AudioTracksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AudioTracksCompanion.insert({
    required String id,
    required String title,
    required String artist,
    required String audioUrl,
    required int durationSeconds,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        artist = Value(artist),
        audioUrl = Value(audioUrl),
        durationSeconds = Value(durationSeconds);
  static Insertable<AudioTrack> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? artist,
    Expression<String>? audioUrl,
    Expression<int>? durationSeconds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (artist != null) 'artist': artist,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AudioTracksCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? artist,
      Value<String>? audioUrl,
      Value<int>? durationSeconds,
      Value<int>? rowid}) {
    return AudioTracksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      audioUrl: audioUrl ?? this.audioUrl,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AudioTracksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaylistsTable extends Playlists
    with TableInfo<$PlaylistsTable, Playlist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _trackIdsMeta =
      const VerificationMeta('trackIds');
  @override
  late final GeneratedColumn<String> trackIds = GeneratedColumn<String>(
      'track_ids', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, ownerId, title, trackIds, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlists';
  @override
  VerificationContext validateIntegrity(Insertable<Playlist> instance,
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
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('track_ids')) {
      context.handle(_trackIdsMeta,
          trackIds.isAcceptableOrUnknown(data['track_ids']!, _trackIdsMeta));
    } else if (isInserting) {
      context.missing(_trackIdsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Playlist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Playlist(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      trackIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}track_ids'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PlaylistsTable createAlias(String alias) {
    return $PlaylistsTable(attachedDatabase, alias);
  }
}

class Playlist extends DataClass implements Insertable<Playlist> {
  final String id;
  final String ownerId;
  final String title;
  final String trackIds;
  final DateTime createdAt;
  const Playlist(
      {required this.id,
      required this.ownerId,
      required this.title,
      required this.trackIds,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['title'] = Variable<String>(title);
    map['track_ids'] = Variable<String>(trackIds);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PlaylistsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      title: Value(title),
      trackIds: Value(trackIds),
      createdAt: Value(createdAt),
    );
  }

  factory Playlist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Playlist(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      title: serializer.fromJson<String>(json['title']),
      trackIds: serializer.fromJson<String>(json['trackIds']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'title': serializer.toJson<String>(title),
      'trackIds': serializer.toJson<String>(trackIds),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Playlist copyWith(
          {String? id,
          String? ownerId,
          String? title,
          String? trackIds,
          DateTime? createdAt}) =>
      Playlist(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        title: title ?? this.title,
        trackIds: trackIds ?? this.trackIds,
        createdAt: createdAt ?? this.createdAt,
      );
  Playlist copyWithCompanion(PlaylistsCompanion data) {
    return Playlist(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      title: data.title.present ? data.title.value : this.title,
      trackIds: data.trackIds.present ? data.trackIds.value : this.trackIds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Playlist(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('title: $title, ')
          ..write('trackIds: $trackIds, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerId, title, trackIds, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Playlist &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.title == this.title &&
          other.trackIds == this.trackIds &&
          other.createdAt == this.createdAt);
}

class PlaylistsCompanion extends UpdateCompanion<Playlist> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> title;
  final Value<String> trackIds;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PlaylistsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.title = const Value.absent(),
    this.trackIds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaylistsCompanion.insert({
    required String id,
    required String ownerId,
    required String title,
    required String trackIds,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        title = Value(title),
        trackIds = Value(trackIds),
        createdAt = Value(createdAt);
  static Insertable<Playlist> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? title,
    Expression<String>? trackIds,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (title != null) 'title': title,
      if (trackIds != null) 'track_ids': trackIds,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaylistsCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<String>? title,
      Value<String>? trackIds,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PlaylistsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      trackIds: trackIds ?? this.trackIds,
      createdAt: createdAt ?? this.createdAt,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (trackIds.present) {
      map['track_ids'] = Variable<String>(trackIds.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('title: $title, ')
          ..write('trackIds: $trackIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoriesTable extends Stories with TableInfo<$StoriesTable, Story> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _viewCountMeta =
      const VerificationMeta('viewCount');
  @override
  late final GeneratedColumn<int> viewCount = GeneratedColumn<int>(
      'view_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _reactionCountMeta =
      const VerificationMeta('reactionCount');
  @override
  late final GeneratedColumn<int> reactionCount = GeneratedColumn<int>(
      'reaction_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isViewedMeta =
      const VerificationMeta('isViewed');
  @override
  late final GeneratedColumn<bool> isViewed = GeneratedColumn<bool>(
      'is_viewed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_viewed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        createdAt,
        expiresAt,
        viewCount,
        reactionCount,
        isViewed,
        isArchived
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stories';
  @override
  VerificationContext validateIntegrity(Insertable<Story> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('view_count')) {
      context.handle(_viewCountMeta,
          viewCount.isAcceptableOrUnknown(data['view_count']!, _viewCountMeta));
    }
    if (data.containsKey('reaction_count')) {
      context.handle(
          _reactionCountMeta,
          reactionCount.isAcceptableOrUnknown(
              data['reaction_count']!, _reactionCountMeta));
    }
    if (data.containsKey('is_viewed')) {
      context.handle(_isViewedMeta,
          isViewed.isAcceptableOrUnknown(data['is_viewed']!, _isViewedMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
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
  Story map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Story(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at'])!,
      viewCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}view_count'])!,
      reactionCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reaction_count'])!,
      isViewed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_viewed'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
    );
  }

  @override
  $StoriesTable createAlias(String alias) {
    return $StoriesTable(attachedDatabase, alias);
  }
}

class Story extends DataClass implements Insertable<Story> {
  final String id;
  final String userId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final int viewCount;
  final int reactionCount;
  final bool isViewed;
  final bool isArchived;
  const Story(
      {required this.id,
      required this.userId,
      required this.createdAt,
      required this.expiresAt,
      required this.viewCount,
      required this.reactionCount,
      required this.isViewed,
      required this.isArchived});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    map['view_count'] = Variable<int>(viewCount);
    map['reaction_count'] = Variable<int>(reactionCount);
    map['is_viewed'] = Variable<bool>(isViewed);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  StoriesCompanion toCompanion(bool nullToAbsent) {
    return StoriesCompanion(
      id: Value(id),
      userId: Value(userId),
      createdAt: Value(createdAt),
      expiresAt: Value(expiresAt),
      viewCount: Value(viewCount),
      reactionCount: Value(reactionCount),
      isViewed: Value(isViewed),
      isArchived: Value(isArchived),
    );
  }

  factory Story.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Story(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      viewCount: serializer.fromJson<int>(json['viewCount']),
      reactionCount: serializer.fromJson<int>(json['reactionCount']),
      isViewed: serializer.fromJson<bool>(json['isViewed']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'viewCount': serializer.toJson<int>(viewCount),
      'reactionCount': serializer.toJson<int>(reactionCount),
      'isViewed': serializer.toJson<bool>(isViewed),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  Story copyWith(
          {String? id,
          String? userId,
          DateTime? createdAt,
          DateTime? expiresAt,
          int? viewCount,
          int? reactionCount,
          bool? isViewed,
          bool? isArchived}) =>
      Story(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        expiresAt: expiresAt ?? this.expiresAt,
        viewCount: viewCount ?? this.viewCount,
        reactionCount: reactionCount ?? this.reactionCount,
        isViewed: isViewed ?? this.isViewed,
        isArchived: isArchived ?? this.isArchived,
      );
  Story copyWithCompanion(StoriesCompanion data) {
    return Story(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      viewCount: data.viewCount.present ? data.viewCount.value : this.viewCount,
      reactionCount: data.reactionCount.present
          ? data.reactionCount.value
          : this.reactionCount,
      isViewed: data.isViewed.present ? data.isViewed.value : this.isViewed,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Story(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('viewCount: $viewCount, ')
          ..write('reactionCount: $reactionCount, ')
          ..write('isViewed: $isViewed, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, createdAt, expiresAt, viewCount,
      reactionCount, isViewed, isArchived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Story &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt &&
          other.viewCount == this.viewCount &&
          other.reactionCount == this.reactionCount &&
          other.isViewed == this.isViewed &&
          other.isArchived == this.isArchived);
}

class StoriesCompanion extends UpdateCompanion<Story> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> expiresAt;
  final Value<int> viewCount;
  final Value<int> reactionCount;
  final Value<bool> isViewed;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const StoriesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.viewCount = const Value.absent(),
    this.reactionCount = const Value.absent(),
    this.isViewed = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoriesCompanion.insert({
    required String id,
    required String userId,
    required DateTime createdAt,
    required DateTime expiresAt,
    this.viewCount = const Value.absent(),
    this.reactionCount = const Value.absent(),
    this.isViewed = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        createdAt = Value(createdAt),
        expiresAt = Value(expiresAt);
  static Insertable<Story> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? viewCount,
    Expression<int>? reactionCount,
    Expression<bool>? isViewed,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (viewCount != null) 'view_count': viewCount,
      if (reactionCount != null) 'reaction_count': reactionCount,
      if (isViewed != null) 'is_viewed': isViewed,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<DateTime>? createdAt,
      Value<DateTime>? expiresAt,
      Value<int>? viewCount,
      Value<int>? reactionCount,
      Value<bool>? isViewed,
      Value<bool>? isArchived,
      Value<int>? rowid}) {
    return StoriesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      viewCount: viewCount ?? this.viewCount,
      reactionCount: reactionCount ?? this.reactionCount,
      isViewed: isViewed ?? this.isViewed,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (viewCount.present) {
      map['view_count'] = Variable<int>(viewCount.value);
    }
    if (reactionCount.present) {
      map['reaction_count'] = Variable<int>(reactionCount.value);
    }
    if (isViewed.present) {
      map['is_viewed'] = Variable<bool>(isViewed.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoriesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('viewCount: $viewCount, ')
          ..write('reactionCount: $reactionCount, ')
          ..write('isViewed: $isViewed, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StorySegmentsTable extends StorySegments
    with TableInfo<$StorySegmentsTable, StorySegment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StorySegmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _storyIdMeta =
      const VerificationMeta('storyId');
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
      'story_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mediaTypeMeta =
      const VerificationMeta('mediaType');
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
      'media_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mediaUrlMeta =
      const VerificationMeta('mediaUrl');
  @override
  late final GeneratedColumn<String> mediaUrl = GeneratedColumn<String>(
      'media_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _thumbnailUrlMeta =
      const VerificationMeta('thumbnailUrl');
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
      'thumbnail_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _textContentMeta =
      const VerificationMeta('textContent');
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
      'text_content', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        storyId,
        mediaType,
        mediaUrl,
        thumbnailUrl,
        duration,
        textContent,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'story_segments';
  @override
  VerificationContext validateIntegrity(Insertable<StorySegment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('story_id')) {
      context.handle(_storyIdMeta,
          storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta));
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('media_type')) {
      context.handle(_mediaTypeMeta,
          mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta));
    } else if (isInserting) {
      context.missing(_mediaTypeMeta);
    }
    if (data.containsKey('media_url')) {
      context.handle(_mediaUrlMeta,
          mediaUrl.isAcceptableOrUnknown(data['media_url']!, _mediaUrlMeta));
    } else if (isInserting) {
      context.missing(_mediaUrlMeta);
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
          _thumbnailUrlMeta,
          thumbnailUrl.isAcceptableOrUnknown(
              data['thumbnail_url']!, _thumbnailUrlMeta));
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    }
    if (data.containsKey('text_content')) {
      context.handle(
          _textContentMeta,
          textContent.isAcceptableOrUnknown(
              data['text_content']!, _textContentMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  StorySegment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StorySegment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      storyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}story_id'])!,
      mediaType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}media_type'])!,
      mediaUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}media_url'])!,
      thumbnailUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thumbnail_url']),
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])!,
      textContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_content']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $StorySegmentsTable createAlias(String alias) {
    return $StorySegmentsTable(attachedDatabase, alias);
  }
}

class StorySegment extends DataClass implements Insertable<StorySegment> {
  final String id;
  final String storyId;
  final String mediaType;
  final String mediaUrl;
  final String? thumbnailUrl;
  final int duration;
  final String? textContent;
  final DateTime createdAt;
  const StorySegment(
      {required this.id,
      required this.storyId,
      required this.mediaType,
      required this.mediaUrl,
      this.thumbnailUrl,
      required this.duration,
      this.textContent,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['story_id'] = Variable<String>(storyId);
    map['media_type'] = Variable<String>(mediaType);
    map['media_url'] = Variable<String>(mediaUrl);
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    map['duration'] = Variable<int>(duration);
    if (!nullToAbsent || textContent != null) {
      map['text_content'] = Variable<String>(textContent);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StorySegmentsCompanion toCompanion(bool nullToAbsent) {
    return StorySegmentsCompanion(
      id: Value(id),
      storyId: Value(storyId),
      mediaType: Value(mediaType),
      mediaUrl: Value(mediaUrl),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      duration: Value(duration),
      textContent: textContent == null && nullToAbsent
          ? const Value.absent()
          : Value(textContent),
      createdAt: Value(createdAt),
    );
  }

  factory StorySegment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StorySegment(
      id: serializer.fromJson<String>(json['id']),
      storyId: serializer.fromJson<String>(json['storyId']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      mediaUrl: serializer.fromJson<String>(json['mediaUrl']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      duration: serializer.fromJson<int>(json['duration']),
      textContent: serializer.fromJson<String?>(json['textContent']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storyId': serializer.toJson<String>(storyId),
      'mediaType': serializer.toJson<String>(mediaType),
      'mediaUrl': serializer.toJson<String>(mediaUrl),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'duration': serializer.toJson<int>(duration),
      'textContent': serializer.toJson<String?>(textContent),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StorySegment copyWith(
          {String? id,
          String? storyId,
          String? mediaType,
          String? mediaUrl,
          Value<String?> thumbnailUrl = const Value.absent(),
          int? duration,
          Value<String?> textContent = const Value.absent(),
          DateTime? createdAt}) =>
      StorySegment(
        id: id ?? this.id,
        storyId: storyId ?? this.storyId,
        mediaType: mediaType ?? this.mediaType,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        thumbnailUrl:
            thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
        duration: duration ?? this.duration,
        textContent: textContent.present ? textContent.value : this.textContent,
        createdAt: createdAt ?? this.createdAt,
      );
  StorySegment copyWithCompanion(StorySegmentsCompanion data) {
    return StorySegment(
      id: data.id.present ? data.id.value : this.id,
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      mediaUrl: data.mediaUrl.present ? data.mediaUrl.value : this.mediaUrl,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      duration: data.duration.present ? data.duration.value : this.duration,
      textContent:
          data.textContent.present ? data.textContent.value : this.textContent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StorySegment(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('mediaType: $mediaType, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('duration: $duration, ')
          ..write('textContent: $textContent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, storyId, mediaType, mediaUrl,
      thumbnailUrl, duration, textContent, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StorySegment &&
          other.id == this.id &&
          other.storyId == this.storyId &&
          other.mediaType == this.mediaType &&
          other.mediaUrl == this.mediaUrl &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.duration == this.duration &&
          other.textContent == this.textContent &&
          other.createdAt == this.createdAt);
}

class StorySegmentsCompanion extends UpdateCompanion<StorySegment> {
  final Value<String> id;
  final Value<String> storyId;
  final Value<String> mediaType;
  final Value<String> mediaUrl;
  final Value<String?> thumbnailUrl;
  final Value<int> duration;
  final Value<String?> textContent;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StorySegmentsCompanion({
    this.id = const Value.absent(),
    this.storyId = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.mediaUrl = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.duration = const Value.absent(),
    this.textContent = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StorySegmentsCompanion.insert({
    required String id,
    required String storyId,
    required String mediaType,
    required String mediaUrl,
    this.thumbnailUrl = const Value.absent(),
    this.duration = const Value.absent(),
    this.textContent = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        storyId = Value(storyId),
        mediaType = Value(mediaType),
        mediaUrl = Value(mediaUrl),
        createdAt = Value(createdAt);
  static Insertable<StorySegment> custom({
    Expression<String>? id,
    Expression<String>? storyId,
    Expression<String>? mediaType,
    Expression<String>? mediaUrl,
    Expression<String>? thumbnailUrl,
    Expression<int>? duration,
    Expression<String>? textContent,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storyId != null) 'story_id': storyId,
      if (mediaType != null) 'media_type': mediaType,
      if (mediaUrl != null) 'media_url': mediaUrl,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (duration != null) 'duration': duration,
      if (textContent != null) 'text_content': textContent,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StorySegmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? storyId,
      Value<String>? mediaType,
      Value<String>? mediaUrl,
      Value<String?>? thumbnailUrl,
      Value<int>? duration,
      Value<String?>? textContent,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return StorySegmentsCompanion(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      mediaType: mediaType ?? this.mediaType,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      textContent: textContent ?? this.textContent,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (mediaUrl.present) {
      map['media_url'] = Variable<String>(mediaUrl.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (textContent.present) {
      map['text_content'] = Variable<String>(textContent.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StorySegmentsCompanion(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('mediaType: $mediaType, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('duration: $duration, ')
          ..write('textContent: $textContent, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoryViewsTable extends StoryViews
    with TableInfo<$StoryViewsTable, StoryView> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoryViewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _storyIdMeta =
      const VerificationMeta('storyId');
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
      'story_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _viewedAtMeta =
      const VerificationMeta('viewedAt');
  @override
  late final GeneratedColumn<DateTime> viewedAt = GeneratedColumn<DateTime>(
      'viewed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [storyId, userId, viewedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'story_views';
  @override
  VerificationContext validateIntegrity(Insertable<StoryView> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('story_id')) {
      context.handle(_storyIdMeta,
          storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta));
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('viewed_at')) {
      context.handle(_viewedAtMeta,
          viewedAt.isAcceptableOrUnknown(data['viewed_at']!, _viewedAtMeta));
    } else if (isInserting) {
      context.missing(_viewedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {storyId, userId},
      ];
  @override
  StoryView map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoryView(
      storyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}story_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      viewedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}viewed_at'])!,
    );
  }

  @override
  $StoryViewsTable createAlias(String alias) {
    return $StoryViewsTable(attachedDatabase, alias);
  }
}

class StoryView extends DataClass implements Insertable<StoryView> {
  final String storyId;
  final String userId;
  final DateTime viewedAt;
  const StoryView(
      {required this.storyId, required this.userId, required this.viewedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['story_id'] = Variable<String>(storyId);
    map['user_id'] = Variable<String>(userId);
    map['viewed_at'] = Variable<DateTime>(viewedAt);
    return map;
  }

  StoryViewsCompanion toCompanion(bool nullToAbsent) {
    return StoryViewsCompanion(
      storyId: Value(storyId),
      userId: Value(userId),
      viewedAt: Value(viewedAt),
    );
  }

  factory StoryView.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoryView(
      storyId: serializer.fromJson<String>(json['storyId']),
      userId: serializer.fromJson<String>(json['userId']),
      viewedAt: serializer.fromJson<DateTime>(json['viewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'storyId': serializer.toJson<String>(storyId),
      'userId': serializer.toJson<String>(userId),
      'viewedAt': serializer.toJson<DateTime>(viewedAt),
    };
  }

  StoryView copyWith({String? storyId, String? userId, DateTime? viewedAt}) =>
      StoryView(
        storyId: storyId ?? this.storyId,
        userId: userId ?? this.userId,
        viewedAt: viewedAt ?? this.viewedAt,
      );
  StoryView copyWithCompanion(StoryViewsCompanion data) {
    return StoryView(
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      userId: data.userId.present ? data.userId.value : this.userId,
      viewedAt: data.viewedAt.present ? data.viewedAt.value : this.viewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoryView(')
          ..write('storyId: $storyId, ')
          ..write('userId: $userId, ')
          ..write('viewedAt: $viewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(storyId, userId, viewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoryView &&
          other.storyId == this.storyId &&
          other.userId == this.userId &&
          other.viewedAt == this.viewedAt);
}

class StoryViewsCompanion extends UpdateCompanion<StoryView> {
  final Value<String> storyId;
  final Value<String> userId;
  final Value<DateTime> viewedAt;
  final Value<int> rowid;
  const StoryViewsCompanion({
    this.storyId = const Value.absent(),
    this.userId = const Value.absent(),
    this.viewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoryViewsCompanion.insert({
    required String storyId,
    required String userId,
    required DateTime viewedAt,
    this.rowid = const Value.absent(),
  })  : storyId = Value(storyId),
        userId = Value(userId),
        viewedAt = Value(viewedAt);
  static Insertable<StoryView> custom({
    Expression<String>? storyId,
    Expression<String>? userId,
    Expression<DateTime>? viewedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (storyId != null) 'story_id': storyId,
      if (userId != null) 'user_id': userId,
      if (viewedAt != null) 'viewed_at': viewedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoryViewsCompanion copyWith(
      {Value<String>? storyId,
      Value<String>? userId,
      Value<DateTime>? viewedAt,
      Value<int>? rowid}) {
    return StoryViewsCompanion(
      storyId: storyId ?? this.storyId,
      userId: userId ?? this.userId,
      viewedAt: viewedAt ?? this.viewedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (viewedAt.present) {
      map['viewed_at'] = Variable<DateTime>(viewedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoryViewsCompanion(')
          ..write('storyId: $storyId, ')
          ..write('userId: $userId, ')
          ..write('viewedAt: $viewedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoryReactionsTable extends StoryReactions
    with TableInfo<$StoryReactionsTable, StoryReaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoryReactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _storyIdMeta =
      const VerificationMeta('storyId');
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
      'story_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, storyId, userId, emoji, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'story_reactions';
  @override
  VerificationContext validateIntegrity(Insertable<StoryReaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('story_id')) {
      context.handle(_storyIdMeta,
          storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta));
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  StoryReaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoryReaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      storyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}story_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $StoryReactionsTable createAlias(String alias) {
    return $StoryReactionsTable(attachedDatabase, alias);
  }
}

class StoryReaction extends DataClass implements Insertable<StoryReaction> {
  final String id;
  final String storyId;
  final String userId;
  final String emoji;
  final DateTime createdAt;
  const StoryReaction(
      {required this.id,
      required this.storyId,
      required this.userId,
      required this.emoji,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['story_id'] = Variable<String>(storyId);
    map['user_id'] = Variable<String>(userId);
    map['emoji'] = Variable<String>(emoji);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StoryReactionsCompanion toCompanion(bool nullToAbsent) {
    return StoryReactionsCompanion(
      id: Value(id),
      storyId: Value(storyId),
      userId: Value(userId),
      emoji: Value(emoji),
      createdAt: Value(createdAt),
    );
  }

  factory StoryReaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoryReaction(
      id: serializer.fromJson<String>(json['id']),
      storyId: serializer.fromJson<String>(json['storyId']),
      userId: serializer.fromJson<String>(json['userId']),
      emoji: serializer.fromJson<String>(json['emoji']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storyId': serializer.toJson<String>(storyId),
      'userId': serializer.toJson<String>(userId),
      'emoji': serializer.toJson<String>(emoji),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StoryReaction copyWith(
          {String? id,
          String? storyId,
          String? userId,
          String? emoji,
          DateTime? createdAt}) =>
      StoryReaction(
        id: id ?? this.id,
        storyId: storyId ?? this.storyId,
        userId: userId ?? this.userId,
        emoji: emoji ?? this.emoji,
        createdAt: createdAt ?? this.createdAt,
      );
  StoryReaction copyWithCompanion(StoryReactionsCompanion data) {
    return StoryReaction(
      id: data.id.present ? data.id.value : this.id,
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      userId: data.userId.present ? data.userId.value : this.userId,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoryReaction(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('userId: $userId, ')
          ..write('emoji: $emoji, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, storyId, userId, emoji, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoryReaction &&
          other.id == this.id &&
          other.storyId == this.storyId &&
          other.userId == this.userId &&
          other.emoji == this.emoji &&
          other.createdAt == this.createdAt);
}

class StoryReactionsCompanion extends UpdateCompanion<StoryReaction> {
  final Value<String> id;
  final Value<String> storyId;
  final Value<String> userId;
  final Value<String> emoji;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StoryReactionsCompanion({
    this.id = const Value.absent(),
    this.storyId = const Value.absent(),
    this.userId = const Value.absent(),
    this.emoji = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoryReactionsCompanion.insert({
    required String id,
    required String storyId,
    required String userId,
    required String emoji,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        storyId = Value(storyId),
        userId = Value(userId),
        emoji = Value(emoji),
        createdAt = Value(createdAt);
  static Insertable<StoryReaction> custom({
    Expression<String>? id,
    Expression<String>? storyId,
    Expression<String>? userId,
    Expression<String>? emoji,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storyId != null) 'story_id': storyId,
      if (userId != null) 'user_id': userId,
      if (emoji != null) 'emoji': emoji,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoryReactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? storyId,
      Value<String>? userId,
      Value<String>? emoji,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return StoryReactionsCompanion(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      userId: userId ?? this.userId,
      emoji: emoji ?? this.emoji,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoryReactionsCompanion(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('userId: $userId, ')
          ..write('emoji: $emoji, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$MeropeDatabase extends GeneratedDatabase {
  _$MeropeDatabase(QueryExecutor e) : super(e);
  $MeropeDatabaseManager get managers => $MeropeDatabaseManager(this);
  late final $OperationLogsTable operationLogs = $OperationLogsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $SubCommunitiesTable subCommunities = $SubCommunitiesTable(this);
  late final $CommunityMembersTable communityMembers =
      $CommunityMembersTable(this);
  late final $CommunityEventsTable communityEvents =
      $CommunityEventsTable(this);
  late final $CollectivesTable collectives = $CollectivesTable(this);
  late final $CollectiveThreadsTable collectiveThreads =
      $CollectiveThreadsTable(this);
  late final $ThreadRepliesTable threadReplies = $ThreadRepliesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $AudioTracksTable audioTracks = $AudioTracksTable(this);
  late final $PlaylistsTable playlists = $PlaylistsTable(this);
  late final $StoriesTable stories = $StoriesTable(this);
  late final $StorySegmentsTable storySegments = $StorySegmentsTable(this);
  late final $StoryViewsTable storyViews = $StoryViewsTable(this);
  late final $StoryReactionsTable storyReactions = $StoryReactionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        operationLogs,
        users,
        messages,
        subCommunities,
        communityMembers,
        communityEvents,
        collectives,
        collectiveThreads,
        threadReplies,
        transactions,
        audioTracks,
        playlists,
        stories,
        storySegments,
        storyViews,
        storyReactions
      ];
}

typedef $$OperationLogsTableCreateCompanionBuilder = OperationLogsCompanion
    Function({
  required String id,
  required String entityType,
  required String entityId,
  required String operation,
  required String performedBy,
  required DateTime performedAt,
  Value<String?> metadata,
  Value<int?> clientSequence,
  Value<bool> isSynced,
  Value<int> rowid,
});
typedef $$OperationLogsTableUpdateCompanionBuilder = OperationLogsCompanion
    Function({
  Value<String> id,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> operation,
  Value<String> performedBy,
  Value<DateTime> performedAt,
  Value<String?> metadata,
  Value<int?> clientSequence,
  Value<bool> isSynced,
  Value<int> rowid,
});

class $$OperationLogsTableFilterComposer
    extends Composer<_$MeropeDatabase, $OperationLogsTable> {
  $$OperationLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get performedBy => $composableBuilder(
      column: $table.performedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get performedAt => $composableBuilder(
      column: $table.performedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get clientSequence => $composableBuilder(
      column: $table.clientSequence,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));
}

class $$OperationLogsTableOrderingComposer
    extends Composer<_$MeropeDatabase, $OperationLogsTable> {
  $$OperationLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get performedBy => $composableBuilder(
      column: $table.performedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get performedAt => $composableBuilder(
      column: $table.performedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get clientSequence => $composableBuilder(
      column: $table.clientSequence,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));
}

class $$OperationLogsTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $OperationLogsTable> {
  $$OperationLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get performedBy => $composableBuilder(
      column: $table.performedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get performedAt => $composableBuilder(
      column: $table.performedAt, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<int> get clientSequence => $composableBuilder(
      column: $table.clientSequence, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$OperationLogsTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $OperationLogsTable,
    OperationLog,
    $$OperationLogsTableFilterComposer,
    $$OperationLogsTableOrderingComposer,
    $$OperationLogsTableAnnotationComposer,
    $$OperationLogsTableCreateCompanionBuilder,
    $$OperationLogsTableUpdateCompanionBuilder,
    (
      OperationLog,
      BaseReferences<_$MeropeDatabase, $OperationLogsTable, OperationLog>
    ),
    OperationLog,
    PrefetchHooks Function()> {
  $$OperationLogsTableTableManager(
      _$MeropeDatabase db, $OperationLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OperationLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OperationLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OperationLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> performedBy = const Value.absent(),
            Value<DateTime> performedAt = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<int?> clientSequence = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OperationLogsCompanion(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            performedBy: performedBy,
            performedAt: performedAt,
            metadata: metadata,
            clientSequence: clientSequence,
            isSynced: isSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entityType,
            required String entityId,
            required String operation,
            required String performedBy,
            required DateTime performedAt,
            Value<String?> metadata = const Value.absent(),
            Value<int?> clientSequence = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OperationLogsCompanion.insert(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            performedBy: performedBy,
            performedAt: performedAt,
            metadata: metadata,
            clientSequence: clientSequence,
            isSynced: isSynced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OperationLogsTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $OperationLogsTable,
    OperationLog,
    $$OperationLogsTableFilterComposer,
    $$OperationLogsTableOrderingComposer,
    $$OperationLogsTableAnnotationComposer,
    $$OperationLogsTableCreateCompanionBuilder,
    $$OperationLogsTableUpdateCompanionBuilder,
    (
      OperationLog,
      BaseReferences<_$MeropeDatabase, $OperationLogsTable, OperationLog>
    ),
    OperationLog,
    PrefetchHooks Function()>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String username,
  required String email,
  required String passwordHash,
  Value<String?> avatarUrl,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> username,
  Value<String> email,
  Value<String> passwordHash,
  Value<String?> avatarUrl,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$UsersTableFilterComposer
    extends Composer<_$MeropeDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$MeropeDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$MeropeDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$MeropeDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> passwordHash = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            username: username,
            email: email,
            passwordHash: passwordHash,
            avatarUrl: avatarUrl,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String username,
            required String email,
            required String passwordHash,
            Value<String?> avatarUrl = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            username: username,
            email: email,
            passwordHash: passwordHash,
            avatarUrl: avatarUrl,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$MeropeDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$MessagesTableCreateCompanionBuilder = MessagesCompanion Function({
  required String id,
  required String channelId,
  required String authorId,
  Value<String?> authorName,
  Value<String?> authorAvatar,
  required String content,
  required DateTime createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isEncrypted,
  Value<String?> reactions,
  Value<String?> threadId,
  Value<int> version,
  Value<int> rowid,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<String> id,
  Value<String> channelId,
  Value<String> authorId,
  Value<String?> authorName,
  Value<String?> authorAvatar,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isEncrypted,
  Value<String?> reactions,
  Value<String?> threadId,
  Value<int> version,
  Value<int> rowid,
});

class $$MessagesTableFilterComposer
    extends Composer<_$MeropeDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get channelId => $composableBuilder(
      column: $table.channelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorId => $composableBuilder(
      column: $table.authorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorName => $composableBuilder(
      column: $table.authorName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorAvatar => $composableBuilder(
      column: $table.authorAvatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reactions => $composableBuilder(
      column: $table.reactions, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get threadId => $composableBuilder(
      column: $table.threadId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$MessagesTableOrderingComposer
    extends Composer<_$MeropeDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get channelId => $composableBuilder(
      column: $table.channelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorId => $composableBuilder(
      column: $table.authorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorName => $composableBuilder(
      column: $table.authorName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorAvatar => $composableBuilder(
      column: $table.authorAvatar,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reactions => $composableBuilder(
      column: $table.reactions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get threadId => $composableBuilder(
      column: $table.threadId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get channelId =>
      $composableBuilder(column: $table.channelId, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get authorName => $composableBuilder(
      column: $table.authorName, builder: (column) => column);

  GeneratedColumn<String> get authorAvatar => $composableBuilder(
      column: $table.authorAvatar, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => column);

  GeneratedColumn<String> get reactions =>
      $composableBuilder(column: $table.reactions, builder: (column) => column);

  GeneratedColumn<String> get threadId =>
      $composableBuilder(column: $table.threadId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$MessagesTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (Message, BaseReferences<_$MeropeDatabase, $MessagesTable, Message>),
    Message,
    PrefetchHooks Function()> {
  $$MessagesTableTableManager(_$MeropeDatabase db, $MessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> channelId = const Value.absent(),
            Value<String> authorId = const Value.absent(),
            Value<String?> authorName = const Value.absent(),
            Value<String?> authorAvatar = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isEncrypted = const Value.absent(),
            Value<String?> reactions = const Value.absent(),
            Value<String?> threadId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion(
            id: id,
            channelId: channelId,
            authorId: authorId,
            authorName: authorName,
            authorAvatar: authorAvatar,
            content: content,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isEncrypted: isEncrypted,
            reactions: reactions,
            threadId: threadId,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String channelId,
            required String authorId,
            Value<String?> authorName = const Value.absent(),
            Value<String?> authorAvatar = const Value.absent(),
            required String content,
            required DateTime createdAt,
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isEncrypted = const Value.absent(),
            Value<String?> reactions = const Value.absent(),
            Value<String?> threadId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion.insert(
            id: id,
            channelId: channelId,
            authorId: authorId,
            authorName: authorName,
            authorAvatar: authorAvatar,
            content: content,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isEncrypted: isEncrypted,
            reactions: reactions,
            threadId: threadId,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MessagesTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (Message, BaseReferences<_$MeropeDatabase, $MessagesTable, Message>),
    Message,
    PrefetchHooks Function()>;
typedef $$SubCommunitiesTableCreateCompanionBuilder = SubCommunitiesCompanion
    Function({
  required String id,
  required String ownerId,
  required String name,
  required String slug,
  required String description,
  Value<String?> avatarUrl,
  Value<String?> bannerUrl,
  Value<bool> isPrivate,
  Value<bool> isVerified,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SubCommunitiesTableUpdateCompanionBuilder = SubCommunitiesCompanion
    Function({
  Value<String> id,
  Value<String> ownerId,
  Value<String> name,
  Value<String> slug,
  Value<String> description,
  Value<String?> avatarUrl,
  Value<String?> bannerUrl,
  Value<bool> isPrivate,
  Value<bool> isVerified,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SubCommunitiesTableFilterComposer
    extends Composer<_$MeropeDatabase, $SubCommunitiesTable> {
  $$SubCommunitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bannerUrl => $composableBuilder(
      column: $table.bannerUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPrivate => $composableBuilder(
      column: $table.isPrivate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isVerified => $composableBuilder(
      column: $table.isVerified, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SubCommunitiesTableOrderingComposer
    extends Composer<_$MeropeDatabase, $SubCommunitiesTable> {
  $$SubCommunitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bannerUrl => $composableBuilder(
      column: $table.bannerUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPrivate => $composableBuilder(
      column: $table.isPrivate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isVerified => $composableBuilder(
      column: $table.isVerified, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SubCommunitiesTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $SubCommunitiesTable> {
  $$SubCommunitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get bannerUrl =>
      $composableBuilder(column: $table.bannerUrl, builder: (column) => column);

  GeneratedColumn<bool> get isPrivate =>
      $composableBuilder(column: $table.isPrivate, builder: (column) => column);

  GeneratedColumn<bool> get isVerified => $composableBuilder(
      column: $table.isVerified, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SubCommunitiesTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $SubCommunitiesTable,
    SubCommunity,
    $$SubCommunitiesTableFilterComposer,
    $$SubCommunitiesTableOrderingComposer,
    $$SubCommunitiesTableAnnotationComposer,
    $$SubCommunitiesTableCreateCompanionBuilder,
    $$SubCommunitiesTableUpdateCompanionBuilder,
    (
      SubCommunity,
      BaseReferences<_$MeropeDatabase, $SubCommunitiesTable, SubCommunity>
    ),
    SubCommunity,
    PrefetchHooks Function()> {
  $$SubCommunitiesTableTableManager(
      _$MeropeDatabase db, $SubCommunitiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubCommunitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubCommunitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubCommunitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<String?> bannerUrl = const Value.absent(),
            Value<bool> isPrivate = const Value.absent(),
            Value<bool> isVerified = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubCommunitiesCompanion(
            id: id,
            ownerId: ownerId,
            name: name,
            slug: slug,
            description: description,
            avatarUrl: avatarUrl,
            bannerUrl: bannerUrl,
            isPrivate: isPrivate,
            isVerified: isVerified,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required String name,
            required String slug,
            required String description,
            Value<String?> avatarUrl = const Value.absent(),
            Value<String?> bannerUrl = const Value.absent(),
            Value<bool> isPrivate = const Value.absent(),
            Value<bool> isVerified = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SubCommunitiesCompanion.insert(
            id: id,
            ownerId: ownerId,
            name: name,
            slug: slug,
            description: description,
            avatarUrl: avatarUrl,
            bannerUrl: bannerUrl,
            isPrivate: isPrivate,
            isVerified: isVerified,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubCommunitiesTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $SubCommunitiesTable,
    SubCommunity,
    $$SubCommunitiesTableFilterComposer,
    $$SubCommunitiesTableOrderingComposer,
    $$SubCommunitiesTableAnnotationComposer,
    $$SubCommunitiesTableCreateCompanionBuilder,
    $$SubCommunitiesTableUpdateCompanionBuilder,
    (
      SubCommunity,
      BaseReferences<_$MeropeDatabase, $SubCommunitiesTable, SubCommunity>
    ),
    SubCommunity,
    PrefetchHooks Function()>;
typedef $$CommunityMembersTableCreateCompanionBuilder
    = CommunityMembersCompanion Function({
  required String id,
  required String communityId,
  required String userId,
  required String role,
  required DateTime joinedAt,
  Value<int> rowid,
});
typedef $$CommunityMembersTableUpdateCompanionBuilder
    = CommunityMembersCompanion Function({
  Value<String> id,
  Value<String> communityId,
  Value<String> userId,
  Value<String> role,
  Value<DateTime> joinedAt,
  Value<int> rowid,
});

class $$CommunityMembersTableFilterComposer
    extends Composer<_$MeropeDatabase, $CommunityMembersTable> {
  $$CommunityMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get communityId => $composableBuilder(
      column: $table.communityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
      column: $table.joinedAt, builder: (column) => ColumnFilters(column));
}

class $$CommunityMembersTableOrderingComposer
    extends Composer<_$MeropeDatabase, $CommunityMembersTable> {
  $$CommunityMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get communityId => $composableBuilder(
      column: $table.communityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
      column: $table.joinedAt, builder: (column) => ColumnOrderings(column));
}

class $$CommunityMembersTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $CommunityMembersTable> {
  $$CommunityMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get communityId => $composableBuilder(
      column: $table.communityId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);
}

class $$CommunityMembersTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $CommunityMembersTable,
    CommunityMember,
    $$CommunityMembersTableFilterComposer,
    $$CommunityMembersTableOrderingComposer,
    $$CommunityMembersTableAnnotationComposer,
    $$CommunityMembersTableCreateCompanionBuilder,
    $$CommunityMembersTableUpdateCompanionBuilder,
    (
      CommunityMember,
      BaseReferences<_$MeropeDatabase, $CommunityMembersTable, CommunityMember>
    ),
    CommunityMember,
    PrefetchHooks Function()> {
  $$CommunityMembersTableTableManager(
      _$MeropeDatabase db, $CommunityMembersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CommunityMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CommunityMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CommunityMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> communityId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<DateTime> joinedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CommunityMembersCompanion(
            id: id,
            communityId: communityId,
            userId: userId,
            role: role,
            joinedAt: joinedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String communityId,
            required String userId,
            required String role,
            required DateTime joinedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CommunityMembersCompanion.insert(
            id: id,
            communityId: communityId,
            userId: userId,
            role: role,
            joinedAt: joinedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CommunityMembersTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $CommunityMembersTable,
    CommunityMember,
    $$CommunityMembersTableFilterComposer,
    $$CommunityMembersTableOrderingComposer,
    $$CommunityMembersTableAnnotationComposer,
    $$CommunityMembersTableCreateCompanionBuilder,
    $$CommunityMembersTableUpdateCompanionBuilder,
    (
      CommunityMember,
      BaseReferences<_$MeropeDatabase, $CommunityMembersTable, CommunityMember>
    ),
    CommunityMember,
    PrefetchHooks Function()>;
typedef $$CommunityEventsTableCreateCompanionBuilder = CommunityEventsCompanion
    Function({
  required String id,
  required String creatorId,
  Value<String?> communityId,
  required String title,
  required String description,
  required DateTime startTime,
  required DateTime endTime,
  Value<String?> locationName,
  Value<double?> latitude,
  Value<double?> longitude,
  required String status,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$CommunityEventsTableUpdateCompanionBuilder = CommunityEventsCompanion
    Function({
  Value<String> id,
  Value<String> creatorId,
  Value<String?> communityId,
  Value<String> title,
  Value<String> description,
  Value<DateTime> startTime,
  Value<DateTime> endTime,
  Value<String?> locationName,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$CommunityEventsTableFilterComposer
    extends Composer<_$MeropeDatabase, $CommunityEventsTable> {
  $$CommunityEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get creatorId => $composableBuilder(
      column: $table.creatorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get communityId => $composableBuilder(
      column: $table.communityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationName => $composableBuilder(
      column: $table.locationName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$CommunityEventsTableOrderingComposer
    extends Composer<_$MeropeDatabase, $CommunityEventsTable> {
  $$CommunityEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get creatorId => $composableBuilder(
      column: $table.creatorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get communityId => $composableBuilder(
      column: $table.communityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationName => $composableBuilder(
      column: $table.locationName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CommunityEventsTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $CommunityEventsTable> {
  $$CommunityEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get creatorId =>
      $composableBuilder(column: $table.creatorId, builder: (column) => column);

  GeneratedColumn<String> get communityId => $composableBuilder(
      column: $table.communityId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get locationName => $composableBuilder(
      column: $table.locationName, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CommunityEventsTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $CommunityEventsTable,
    CommunityEvent,
    $$CommunityEventsTableFilterComposer,
    $$CommunityEventsTableOrderingComposer,
    $$CommunityEventsTableAnnotationComposer,
    $$CommunityEventsTableCreateCompanionBuilder,
    $$CommunityEventsTableUpdateCompanionBuilder,
    (
      CommunityEvent,
      BaseReferences<_$MeropeDatabase, $CommunityEventsTable, CommunityEvent>
    ),
    CommunityEvent,
    PrefetchHooks Function()> {
  $$CommunityEventsTableTableManager(
      _$MeropeDatabase db, $CommunityEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CommunityEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CommunityEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CommunityEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> creatorId = const Value.absent(),
            Value<String?> communityId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime> endTime = const Value.absent(),
            Value<String?> locationName = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CommunityEventsCompanion(
            id: id,
            creatorId: creatorId,
            communityId: communityId,
            title: title,
            description: description,
            startTime: startTime,
            endTime: endTime,
            locationName: locationName,
            latitude: latitude,
            longitude: longitude,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String creatorId,
            Value<String?> communityId = const Value.absent(),
            required String title,
            required String description,
            required DateTime startTime,
            required DateTime endTime,
            Value<String?> locationName = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            required String status,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CommunityEventsCompanion.insert(
            id: id,
            creatorId: creatorId,
            communityId: communityId,
            title: title,
            description: description,
            startTime: startTime,
            endTime: endTime,
            locationName: locationName,
            latitude: latitude,
            longitude: longitude,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CommunityEventsTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $CommunityEventsTable,
    CommunityEvent,
    $$CommunityEventsTableFilterComposer,
    $$CommunityEventsTableOrderingComposer,
    $$CommunityEventsTableAnnotationComposer,
    $$CommunityEventsTableCreateCompanionBuilder,
    $$CommunityEventsTableUpdateCompanionBuilder,
    (
      CommunityEvent,
      BaseReferences<_$MeropeDatabase, $CommunityEventsTable, CommunityEvent>
    ),
    CommunityEvent,
    PrefetchHooks Function()>;
typedef $$CollectivesTableCreateCompanionBuilder = CollectivesCompanion
    Function({
  required String id,
  required String name,
  required String slug,
  required String description,
  Value<String?> icon,
  required String category,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$CollectivesTableUpdateCompanionBuilder = CollectivesCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> slug,
  Value<String> description,
  Value<String?> icon,
  Value<String> category,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$CollectivesTableFilterComposer
    extends Composer<_$MeropeDatabase, $CollectivesTable> {
  $$CollectivesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$CollectivesTableOrderingComposer
    extends Composer<_$MeropeDatabase, $CollectivesTable> {
  $$CollectivesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CollectivesTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $CollectivesTable> {
  $$CollectivesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CollectivesTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $CollectivesTable,
    Collective,
    $$CollectivesTableFilterComposer,
    $$CollectivesTableOrderingComposer,
    $$CollectivesTableAnnotationComposer,
    $$CollectivesTableCreateCompanionBuilder,
    $$CollectivesTableUpdateCompanionBuilder,
    (
      Collective,
      BaseReferences<_$MeropeDatabase, $CollectivesTable, Collective>
    ),
    Collective,
    PrefetchHooks Function()> {
  $$CollectivesTableTableManager(_$MeropeDatabase db, $CollectivesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectivesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectivesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectivesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CollectivesCompanion(
            id: id,
            name: name,
            slug: slug,
            description: description,
            icon: icon,
            category: category,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String slug,
            required String description,
            Value<String?> icon = const Value.absent(),
            required String category,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CollectivesCompanion.insert(
            id: id,
            name: name,
            slug: slug,
            description: description,
            icon: icon,
            category: category,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CollectivesTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $CollectivesTable,
    Collective,
    $$CollectivesTableFilterComposer,
    $$CollectivesTableOrderingComposer,
    $$CollectivesTableAnnotationComposer,
    $$CollectivesTableCreateCompanionBuilder,
    $$CollectivesTableUpdateCompanionBuilder,
    (
      Collective,
      BaseReferences<_$MeropeDatabase, $CollectivesTable, Collective>
    ),
    Collective,
    PrefetchHooks Function()>;
typedef $$CollectiveThreadsTableCreateCompanionBuilder
    = CollectiveThreadsCompanion Function({
  required String id,
  required String collectiveId,
  required String authorId,
  required String authorName,
  Value<String?> authorAvatar,
  required String title,
  required String content,
  Value<int> resonance,
  Value<bool> isPinned,
  Value<bool> isLocked,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$CollectiveThreadsTableUpdateCompanionBuilder
    = CollectiveThreadsCompanion Function({
  Value<String> id,
  Value<String> collectiveId,
  Value<String> authorId,
  Value<String> authorName,
  Value<String?> authorAvatar,
  Value<String> title,
  Value<String> content,
  Value<int> resonance,
  Value<bool> isPinned,
  Value<bool> isLocked,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$CollectiveThreadsTableFilterComposer
    extends Composer<_$MeropeDatabase, $CollectiveThreadsTable> {
  $$CollectiveThreadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get collectiveId => $composableBuilder(
      column: $table.collectiveId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorId => $composableBuilder(
      column: $table.authorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorName => $composableBuilder(
      column: $table.authorName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorAvatar => $composableBuilder(
      column: $table.authorAvatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get resonance => $composableBuilder(
      column: $table.resonance, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isLocked => $composableBuilder(
      column: $table.isLocked, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$CollectiveThreadsTableOrderingComposer
    extends Composer<_$MeropeDatabase, $CollectiveThreadsTable> {
  $$CollectiveThreadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get collectiveId => $composableBuilder(
      column: $table.collectiveId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorId => $composableBuilder(
      column: $table.authorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorName => $composableBuilder(
      column: $table.authorName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorAvatar => $composableBuilder(
      column: $table.authorAvatar,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get resonance => $composableBuilder(
      column: $table.resonance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isLocked => $composableBuilder(
      column: $table.isLocked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CollectiveThreadsTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $CollectiveThreadsTable> {
  $$CollectiveThreadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get collectiveId => $composableBuilder(
      column: $table.collectiveId, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get authorName => $composableBuilder(
      column: $table.authorName, builder: (column) => column);

  GeneratedColumn<String> get authorAvatar => $composableBuilder(
      column: $table.authorAvatar, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get resonance =>
      $composableBuilder(column: $table.resonance, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<bool> get isLocked =>
      $composableBuilder(column: $table.isLocked, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CollectiveThreadsTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $CollectiveThreadsTable,
    CollectiveThread,
    $$CollectiveThreadsTableFilterComposer,
    $$CollectiveThreadsTableOrderingComposer,
    $$CollectiveThreadsTableAnnotationComposer,
    $$CollectiveThreadsTableCreateCompanionBuilder,
    $$CollectiveThreadsTableUpdateCompanionBuilder,
    (
      CollectiveThread,
      BaseReferences<_$MeropeDatabase, $CollectiveThreadsTable,
          CollectiveThread>
    ),
    CollectiveThread,
    PrefetchHooks Function()> {
  $$CollectiveThreadsTableTableManager(
      _$MeropeDatabase db, $CollectiveThreadsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectiveThreadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectiveThreadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectiveThreadsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> collectiveId = const Value.absent(),
            Value<String> authorId = const Value.absent(),
            Value<String> authorName = const Value.absent(),
            Value<String?> authorAvatar = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> resonance = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<bool> isLocked = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CollectiveThreadsCompanion(
            id: id,
            collectiveId: collectiveId,
            authorId: authorId,
            authorName: authorName,
            authorAvatar: authorAvatar,
            title: title,
            content: content,
            resonance: resonance,
            isPinned: isPinned,
            isLocked: isLocked,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String collectiveId,
            required String authorId,
            required String authorName,
            Value<String?> authorAvatar = const Value.absent(),
            required String title,
            required String content,
            Value<int> resonance = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<bool> isLocked = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CollectiveThreadsCompanion.insert(
            id: id,
            collectiveId: collectiveId,
            authorId: authorId,
            authorName: authorName,
            authorAvatar: authorAvatar,
            title: title,
            content: content,
            resonance: resonance,
            isPinned: isPinned,
            isLocked: isLocked,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CollectiveThreadsTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $CollectiveThreadsTable,
    CollectiveThread,
    $$CollectiveThreadsTableFilterComposer,
    $$CollectiveThreadsTableOrderingComposer,
    $$CollectiveThreadsTableAnnotationComposer,
    $$CollectiveThreadsTableCreateCompanionBuilder,
    $$CollectiveThreadsTableUpdateCompanionBuilder,
    (
      CollectiveThread,
      BaseReferences<_$MeropeDatabase, $CollectiveThreadsTable,
          CollectiveThread>
    ),
    CollectiveThread,
    PrefetchHooks Function()>;
typedef $$ThreadRepliesTableCreateCompanionBuilder = ThreadRepliesCompanion
    Function({
  required String id,
  required String threadId,
  required String authorId,
  required String authorName,
  Value<String?> authorAvatar,
  required String content,
  Value<int> resonance,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ThreadRepliesTableUpdateCompanionBuilder = ThreadRepliesCompanion
    Function({
  Value<String> id,
  Value<String> threadId,
  Value<String> authorId,
  Value<String> authorName,
  Value<String?> authorAvatar,
  Value<String> content,
  Value<int> resonance,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ThreadRepliesTableFilterComposer
    extends Composer<_$MeropeDatabase, $ThreadRepliesTable> {
  $$ThreadRepliesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get threadId => $composableBuilder(
      column: $table.threadId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorId => $composableBuilder(
      column: $table.authorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorName => $composableBuilder(
      column: $table.authorName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorAvatar => $composableBuilder(
      column: $table.authorAvatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get resonance => $composableBuilder(
      column: $table.resonance, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ThreadRepliesTableOrderingComposer
    extends Composer<_$MeropeDatabase, $ThreadRepliesTable> {
  $$ThreadRepliesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get threadId => $composableBuilder(
      column: $table.threadId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorId => $composableBuilder(
      column: $table.authorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorName => $composableBuilder(
      column: $table.authorName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorAvatar => $composableBuilder(
      column: $table.authorAvatar,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get resonance => $composableBuilder(
      column: $table.resonance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ThreadRepliesTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $ThreadRepliesTable> {
  $$ThreadRepliesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get threadId =>
      $composableBuilder(column: $table.threadId, builder: (column) => column);

  GeneratedColumn<String> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<String> get authorName => $composableBuilder(
      column: $table.authorName, builder: (column) => column);

  GeneratedColumn<String> get authorAvatar => $composableBuilder(
      column: $table.authorAvatar, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get resonance =>
      $composableBuilder(column: $table.resonance, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ThreadRepliesTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $ThreadRepliesTable,
    ThreadReply,
    $$ThreadRepliesTableFilterComposer,
    $$ThreadRepliesTableOrderingComposer,
    $$ThreadRepliesTableAnnotationComposer,
    $$ThreadRepliesTableCreateCompanionBuilder,
    $$ThreadRepliesTableUpdateCompanionBuilder,
    (
      ThreadReply,
      BaseReferences<_$MeropeDatabase, $ThreadRepliesTable, ThreadReply>
    ),
    ThreadReply,
    PrefetchHooks Function()> {
  $$ThreadRepliesTableTableManager(
      _$MeropeDatabase db, $ThreadRepliesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThreadRepliesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThreadRepliesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ThreadRepliesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> threadId = const Value.absent(),
            Value<String> authorId = const Value.absent(),
            Value<String> authorName = const Value.absent(),
            Value<String?> authorAvatar = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> resonance = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ThreadRepliesCompanion(
            id: id,
            threadId: threadId,
            authorId: authorId,
            authorName: authorName,
            authorAvatar: authorAvatar,
            content: content,
            resonance: resonance,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String threadId,
            required String authorId,
            required String authorName,
            Value<String?> authorAvatar = const Value.absent(),
            required String content,
            Value<int> resonance = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ThreadRepliesCompanion.insert(
            id: id,
            threadId: threadId,
            authorId: authorId,
            authorName: authorName,
            authorAvatar: authorAvatar,
            content: content,
            resonance: resonance,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ThreadRepliesTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $ThreadRepliesTable,
    ThreadReply,
    $$ThreadRepliesTableFilterComposer,
    $$ThreadRepliesTableOrderingComposer,
    $$ThreadRepliesTableAnnotationComposer,
    $$ThreadRepliesTableCreateCompanionBuilder,
    $$ThreadRepliesTableUpdateCompanionBuilder,
    (
      ThreadReply,
      BaseReferences<_$MeropeDatabase, $ThreadRepliesTable, ThreadReply>
    ),
    ThreadReply,
    PrefetchHooks Function()>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  required String id,
  required String fromAccountId,
  required String toAccountId,
  required double amount,
  required String currency,
  required String status,
  required DateTime createdAt,
  Value<double?> fee,
  Value<String?> category,
  Value<String?> receiptUrl,
  Value<double?> fraudScore,
  Value<String?> metadata,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  Value<String> fromAccountId,
  Value<String> toAccountId,
  Value<double> amount,
  Value<String> currency,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<double?> fee,
  Value<String?> category,
  Value<String?> receiptUrl,
  Value<double?> fraudScore,
  Value<String?> metadata,
  Value<int> rowid,
});

class $$TransactionsTableFilterComposer
    extends Composer<_$MeropeDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromAccountId => $composableBuilder(
      column: $table.fromAccountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toAccountId => $composableBuilder(
      column: $table.toAccountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fee => $composableBuilder(
      column: $table.fee, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receiptUrl => $composableBuilder(
      column: $table.receiptUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fraudScore => $composableBuilder(
      column: $table.fraudScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$MeropeDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromAccountId => $composableBuilder(
      column: $table.fromAccountId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toAccountId => $composableBuilder(
      column: $table.toAccountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fee => $composableBuilder(
      column: $table.fee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receiptUrl => $composableBuilder(
      column: $table.receiptUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fraudScore => $composableBuilder(
      column: $table.fraudScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromAccountId => $composableBuilder(
      column: $table.fromAccountId, builder: (column) => column);

  GeneratedColumn<String> get toAccountId => $composableBuilder(
      column: $table.toAccountId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get fee =>
      $composableBuilder(column: $table.fee, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get receiptUrl => $composableBuilder(
      column: $table.receiptUrl, builder: (column) => column);

  GeneratedColumn<double> get fraudScore => $composableBuilder(
      column: $table.fraudScore, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$MeropeDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()> {
  $$TransactionsTableTableManager(_$MeropeDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fromAccountId = const Value.absent(),
            Value<String> toAccountId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<double?> fee = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String?> receiptUrl = const Value.absent(),
            Value<double?> fraudScore = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            fromAccountId: fromAccountId,
            toAccountId: toAccountId,
            amount: amount,
            currency: currency,
            status: status,
            createdAt: createdAt,
            fee: fee,
            category: category,
            receiptUrl: receiptUrl,
            fraudScore: fraudScore,
            metadata: metadata,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String fromAccountId,
            required String toAccountId,
            required double amount,
            required String currency,
            required String status,
            required DateTime createdAt,
            Value<double?> fee = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String?> receiptUrl = const Value.absent(),
            Value<double?> fraudScore = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            fromAccountId: fromAccountId,
            toAccountId: toAccountId,
            amount: amount,
            currency: currency,
            status: status,
            createdAt: createdAt,
            fee: fee,
            category: category,
            receiptUrl: receiptUrl,
            fraudScore: fraudScore,
            metadata: metadata,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$MeropeDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()>;
typedef $$AudioTracksTableCreateCompanionBuilder = AudioTracksCompanion
    Function({
  required String id,
  required String title,
  required String artist,
  required String audioUrl,
  required int durationSeconds,
  Value<int> rowid,
});
typedef $$AudioTracksTableUpdateCompanionBuilder = AudioTracksCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<String> artist,
  Value<String> audioUrl,
  Value<int> durationSeconds,
  Value<int> rowid,
});

class $$AudioTracksTableFilterComposer
    extends Composer<_$MeropeDatabase, $AudioTracksTable> {
  $$AudioTracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));
}

class $$AudioTracksTableOrderingComposer
    extends Composer<_$MeropeDatabase, $AudioTracksTable> {
  $$AudioTracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));
}

class $$AudioTracksTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $AudioTracksTable> {
  $$AudioTracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);
}

class $$AudioTracksTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $AudioTracksTable,
    AudioTrack,
    $$AudioTracksTableFilterComposer,
    $$AudioTracksTableOrderingComposer,
    $$AudioTracksTableAnnotationComposer,
    $$AudioTracksTableCreateCompanionBuilder,
    $$AudioTracksTableUpdateCompanionBuilder,
    (
      AudioTrack,
      BaseReferences<_$MeropeDatabase, $AudioTracksTable, AudioTrack>
    ),
    AudioTrack,
    PrefetchHooks Function()> {
  $$AudioTracksTableTableManager(_$MeropeDatabase db, $AudioTracksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AudioTracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AudioTracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AudioTracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> artist = const Value.absent(),
            Value<String> audioUrl = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AudioTracksCompanion(
            id: id,
            title: title,
            artist: artist,
            audioUrl: audioUrl,
            durationSeconds: durationSeconds,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String artist,
            required String audioUrl,
            required int durationSeconds,
            Value<int> rowid = const Value.absent(),
          }) =>
              AudioTracksCompanion.insert(
            id: id,
            title: title,
            artist: artist,
            audioUrl: audioUrl,
            durationSeconds: durationSeconds,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AudioTracksTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $AudioTracksTable,
    AudioTrack,
    $$AudioTracksTableFilterComposer,
    $$AudioTracksTableOrderingComposer,
    $$AudioTracksTableAnnotationComposer,
    $$AudioTracksTableCreateCompanionBuilder,
    $$AudioTracksTableUpdateCompanionBuilder,
    (
      AudioTrack,
      BaseReferences<_$MeropeDatabase, $AudioTracksTable, AudioTrack>
    ),
    AudioTrack,
    PrefetchHooks Function()>;
typedef $$PlaylistsTableCreateCompanionBuilder = PlaylistsCompanion Function({
  required String id,
  required String ownerId,
  required String title,
  required String trackIds,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$PlaylistsTableUpdateCompanionBuilder = PlaylistsCompanion Function({
  Value<String> id,
  Value<String> ownerId,
  Value<String> title,
  Value<String> trackIds,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$PlaylistsTableFilterComposer
    extends Composer<_$MeropeDatabase, $PlaylistsTable> {
  $$PlaylistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get trackIds => $composableBuilder(
      column: $table.trackIds, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$PlaylistsTableOrderingComposer
    extends Composer<_$MeropeDatabase, $PlaylistsTable> {
  $$PlaylistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get trackIds => $composableBuilder(
      column: $table.trackIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PlaylistsTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $PlaylistsTable> {
  $$PlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get trackIds =>
      $composableBuilder(column: $table.trackIds, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PlaylistsTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $PlaylistsTable,
    Playlist,
    $$PlaylistsTableFilterComposer,
    $$PlaylistsTableOrderingComposer,
    $$PlaylistsTableAnnotationComposer,
    $$PlaylistsTableCreateCompanionBuilder,
    $$PlaylistsTableUpdateCompanionBuilder,
    (Playlist, BaseReferences<_$MeropeDatabase, $PlaylistsTable, Playlist>),
    Playlist,
    PrefetchHooks Function()> {
  $$PlaylistsTableTableManager(_$MeropeDatabase db, $PlaylistsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> trackIds = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlaylistsCompanion(
            id: id,
            ownerId: ownerId,
            title: title,
            trackIds: trackIds,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            required String title,
            required String trackIds,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PlaylistsCompanion.insert(
            id: id,
            ownerId: ownerId,
            title: title,
            trackIds: trackIds,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlaylistsTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $PlaylistsTable,
    Playlist,
    $$PlaylistsTableFilterComposer,
    $$PlaylistsTableOrderingComposer,
    $$PlaylistsTableAnnotationComposer,
    $$PlaylistsTableCreateCompanionBuilder,
    $$PlaylistsTableUpdateCompanionBuilder,
    (Playlist, BaseReferences<_$MeropeDatabase, $PlaylistsTable, Playlist>),
    Playlist,
    PrefetchHooks Function()>;
typedef $$StoriesTableCreateCompanionBuilder = StoriesCompanion Function({
  required String id,
  required String userId,
  required DateTime createdAt,
  required DateTime expiresAt,
  Value<int> viewCount,
  Value<int> reactionCount,
  Value<bool> isViewed,
  Value<bool> isArchived,
  Value<int> rowid,
});
typedef $$StoriesTableUpdateCompanionBuilder = StoriesCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<DateTime> createdAt,
  Value<DateTime> expiresAt,
  Value<int> viewCount,
  Value<int> reactionCount,
  Value<bool> isViewed,
  Value<bool> isArchived,
  Value<int> rowid,
});

class $$StoriesTableFilterComposer
    extends Composer<_$MeropeDatabase, $StoriesTable> {
  $$StoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get viewCount => $composableBuilder(
      column: $table.viewCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reactionCount => $composableBuilder(
      column: $table.reactionCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isViewed => $composableBuilder(
      column: $table.isViewed, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));
}

class $$StoriesTableOrderingComposer
    extends Composer<_$MeropeDatabase, $StoriesTable> {
  $$StoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get viewCount => $composableBuilder(
      column: $table.viewCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reactionCount => $composableBuilder(
      column: $table.reactionCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isViewed => $composableBuilder(
      column: $table.isViewed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));
}

class $$StoriesTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $StoriesTable> {
  $$StoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<int> get viewCount =>
      $composableBuilder(column: $table.viewCount, builder: (column) => column);

  GeneratedColumn<int> get reactionCount => $composableBuilder(
      column: $table.reactionCount, builder: (column) => column);

  GeneratedColumn<bool> get isViewed =>
      $composableBuilder(column: $table.isViewed, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);
}

class $$StoriesTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $StoriesTable,
    Story,
    $$StoriesTableFilterComposer,
    $$StoriesTableOrderingComposer,
    $$StoriesTableAnnotationComposer,
    $$StoriesTableCreateCompanionBuilder,
    $$StoriesTableUpdateCompanionBuilder,
    (Story, BaseReferences<_$MeropeDatabase, $StoriesTable, Story>),
    Story,
    PrefetchHooks Function()> {
  $$StoriesTableTableManager(_$MeropeDatabase db, $StoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> expiresAt = const Value.absent(),
            Value<int> viewCount = const Value.absent(),
            Value<int> reactionCount = const Value.absent(),
            Value<bool> isViewed = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StoriesCompanion(
            id: id,
            userId: userId,
            createdAt: createdAt,
            expiresAt: expiresAt,
            viewCount: viewCount,
            reactionCount: reactionCount,
            isViewed: isViewed,
            isArchived: isArchived,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required DateTime createdAt,
            required DateTime expiresAt,
            Value<int> viewCount = const Value.absent(),
            Value<int> reactionCount = const Value.absent(),
            Value<bool> isViewed = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StoriesCompanion.insert(
            id: id,
            userId: userId,
            createdAt: createdAt,
            expiresAt: expiresAt,
            viewCount: viewCount,
            reactionCount: reactionCount,
            isViewed: isViewed,
            isArchived: isArchived,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StoriesTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $StoriesTable,
    Story,
    $$StoriesTableFilterComposer,
    $$StoriesTableOrderingComposer,
    $$StoriesTableAnnotationComposer,
    $$StoriesTableCreateCompanionBuilder,
    $$StoriesTableUpdateCompanionBuilder,
    (Story, BaseReferences<_$MeropeDatabase, $StoriesTable, Story>),
    Story,
    PrefetchHooks Function()>;
typedef $$StorySegmentsTableCreateCompanionBuilder = StorySegmentsCompanion
    Function({
  required String id,
  required String storyId,
  required String mediaType,
  required String mediaUrl,
  Value<String?> thumbnailUrl,
  Value<int> duration,
  Value<String?> textContent,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$StorySegmentsTableUpdateCompanionBuilder = StorySegmentsCompanion
    Function({
  Value<String> id,
  Value<String> storyId,
  Value<String> mediaType,
  Value<String> mediaUrl,
  Value<String?> thumbnailUrl,
  Value<int> duration,
  Value<String?> textContent,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$StorySegmentsTableFilterComposer
    extends Composer<_$MeropeDatabase, $StorySegmentsTable> {
  $$StorySegmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storyId => $composableBuilder(
      column: $table.storyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mediaType => $composableBuilder(
      column: $table.mediaType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mediaUrl => $composableBuilder(
      column: $table.mediaUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$StorySegmentsTableOrderingComposer
    extends Composer<_$MeropeDatabase, $StorySegmentsTable> {
  $$StorySegmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storyId => $composableBuilder(
      column: $table.storyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mediaType => $composableBuilder(
      column: $table.mediaType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mediaUrl => $composableBuilder(
      column: $table.mediaUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$StorySegmentsTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $StorySegmentsTable> {
  $$StorySegmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storyId =>
      $composableBuilder(column: $table.storyId, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get mediaUrl =>
      $composableBuilder(column: $table.mediaUrl, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$StorySegmentsTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $StorySegmentsTable,
    StorySegment,
    $$StorySegmentsTableFilterComposer,
    $$StorySegmentsTableOrderingComposer,
    $$StorySegmentsTableAnnotationComposer,
    $$StorySegmentsTableCreateCompanionBuilder,
    $$StorySegmentsTableUpdateCompanionBuilder,
    (
      StorySegment,
      BaseReferences<_$MeropeDatabase, $StorySegmentsTable, StorySegment>
    ),
    StorySegment,
    PrefetchHooks Function()> {
  $$StorySegmentsTableTableManager(
      _$MeropeDatabase db, $StorySegmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StorySegmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StorySegmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StorySegmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> storyId = const Value.absent(),
            Value<String> mediaType = const Value.absent(),
            Value<String> mediaUrl = const Value.absent(),
            Value<String?> thumbnailUrl = const Value.absent(),
            Value<int> duration = const Value.absent(),
            Value<String?> textContent = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StorySegmentsCompanion(
            id: id,
            storyId: storyId,
            mediaType: mediaType,
            mediaUrl: mediaUrl,
            thumbnailUrl: thumbnailUrl,
            duration: duration,
            textContent: textContent,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String storyId,
            required String mediaType,
            required String mediaUrl,
            Value<String?> thumbnailUrl = const Value.absent(),
            Value<int> duration = const Value.absent(),
            Value<String?> textContent = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              StorySegmentsCompanion.insert(
            id: id,
            storyId: storyId,
            mediaType: mediaType,
            mediaUrl: mediaUrl,
            thumbnailUrl: thumbnailUrl,
            duration: duration,
            textContent: textContent,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StorySegmentsTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $StorySegmentsTable,
    StorySegment,
    $$StorySegmentsTableFilterComposer,
    $$StorySegmentsTableOrderingComposer,
    $$StorySegmentsTableAnnotationComposer,
    $$StorySegmentsTableCreateCompanionBuilder,
    $$StorySegmentsTableUpdateCompanionBuilder,
    (
      StorySegment,
      BaseReferences<_$MeropeDatabase, $StorySegmentsTable, StorySegment>
    ),
    StorySegment,
    PrefetchHooks Function()>;
typedef $$StoryViewsTableCreateCompanionBuilder = StoryViewsCompanion Function({
  required String storyId,
  required String userId,
  required DateTime viewedAt,
  Value<int> rowid,
});
typedef $$StoryViewsTableUpdateCompanionBuilder = StoryViewsCompanion Function({
  Value<String> storyId,
  Value<String> userId,
  Value<DateTime> viewedAt,
  Value<int> rowid,
});

class $$StoryViewsTableFilterComposer
    extends Composer<_$MeropeDatabase, $StoryViewsTable> {
  $$StoryViewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get storyId => $composableBuilder(
      column: $table.storyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get viewedAt => $composableBuilder(
      column: $table.viewedAt, builder: (column) => ColumnFilters(column));
}

class $$StoryViewsTableOrderingComposer
    extends Composer<_$MeropeDatabase, $StoryViewsTable> {
  $$StoryViewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get storyId => $composableBuilder(
      column: $table.storyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get viewedAt => $composableBuilder(
      column: $table.viewedAt, builder: (column) => ColumnOrderings(column));
}

class $$StoryViewsTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $StoryViewsTable> {
  $$StoryViewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get storyId =>
      $composableBuilder(column: $table.storyId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get viewedAt =>
      $composableBuilder(column: $table.viewedAt, builder: (column) => column);
}

class $$StoryViewsTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $StoryViewsTable,
    StoryView,
    $$StoryViewsTableFilterComposer,
    $$StoryViewsTableOrderingComposer,
    $$StoryViewsTableAnnotationComposer,
    $$StoryViewsTableCreateCompanionBuilder,
    $$StoryViewsTableUpdateCompanionBuilder,
    (StoryView, BaseReferences<_$MeropeDatabase, $StoryViewsTable, StoryView>),
    StoryView,
    PrefetchHooks Function()> {
  $$StoryViewsTableTableManager(_$MeropeDatabase db, $StoryViewsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoryViewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoryViewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoryViewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> storyId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<DateTime> viewedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StoryViewsCompanion(
            storyId: storyId,
            userId: userId,
            viewedAt: viewedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String storyId,
            required String userId,
            required DateTime viewedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              StoryViewsCompanion.insert(
            storyId: storyId,
            userId: userId,
            viewedAt: viewedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StoryViewsTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $StoryViewsTable,
    StoryView,
    $$StoryViewsTableFilterComposer,
    $$StoryViewsTableOrderingComposer,
    $$StoryViewsTableAnnotationComposer,
    $$StoryViewsTableCreateCompanionBuilder,
    $$StoryViewsTableUpdateCompanionBuilder,
    (StoryView, BaseReferences<_$MeropeDatabase, $StoryViewsTable, StoryView>),
    StoryView,
    PrefetchHooks Function()>;
typedef $$StoryReactionsTableCreateCompanionBuilder = StoryReactionsCompanion
    Function({
  required String id,
  required String storyId,
  required String userId,
  required String emoji,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$StoryReactionsTableUpdateCompanionBuilder = StoryReactionsCompanion
    Function({
  Value<String> id,
  Value<String> storyId,
  Value<String> userId,
  Value<String> emoji,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$StoryReactionsTableFilterComposer
    extends Composer<_$MeropeDatabase, $StoryReactionsTable> {
  $$StoryReactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storyId => $composableBuilder(
      column: $table.storyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$StoryReactionsTableOrderingComposer
    extends Composer<_$MeropeDatabase, $StoryReactionsTable> {
  $$StoryReactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storyId => $composableBuilder(
      column: $table.storyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$StoryReactionsTableAnnotationComposer
    extends Composer<_$MeropeDatabase, $StoryReactionsTable> {
  $$StoryReactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storyId =>
      $composableBuilder(column: $table.storyId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$StoryReactionsTableTableManager extends RootTableManager<
    _$MeropeDatabase,
    $StoryReactionsTable,
    StoryReaction,
    $$StoryReactionsTableFilterComposer,
    $$StoryReactionsTableOrderingComposer,
    $$StoryReactionsTableAnnotationComposer,
    $$StoryReactionsTableCreateCompanionBuilder,
    $$StoryReactionsTableUpdateCompanionBuilder,
    (
      StoryReaction,
      BaseReferences<_$MeropeDatabase, $StoryReactionsTable, StoryReaction>
    ),
    StoryReaction,
    PrefetchHooks Function()> {
  $$StoryReactionsTableTableManager(
      _$MeropeDatabase db, $StoryReactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoryReactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoryReactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoryReactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> storyId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StoryReactionsCompanion(
            id: id,
            storyId: storyId,
            userId: userId,
            emoji: emoji,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String storyId,
            required String userId,
            required String emoji,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              StoryReactionsCompanion.insert(
            id: id,
            storyId: storyId,
            userId: userId,
            emoji: emoji,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StoryReactionsTableProcessedTableManager = ProcessedTableManager<
    _$MeropeDatabase,
    $StoryReactionsTable,
    StoryReaction,
    $$StoryReactionsTableFilterComposer,
    $$StoryReactionsTableOrderingComposer,
    $$StoryReactionsTableAnnotationComposer,
    $$StoryReactionsTableCreateCompanionBuilder,
    $$StoryReactionsTableUpdateCompanionBuilder,
    (
      StoryReaction,
      BaseReferences<_$MeropeDatabase, $StoryReactionsTable, StoryReaction>
    ),
    StoryReaction,
    PrefetchHooks Function()>;

class $MeropeDatabaseManager {
  final _$MeropeDatabase _db;
  $MeropeDatabaseManager(this._db);
  $$OperationLogsTableTableManager get operationLogs =>
      $$OperationLogsTableTableManager(_db, _db.operationLogs);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$SubCommunitiesTableTableManager get subCommunities =>
      $$SubCommunitiesTableTableManager(_db, _db.subCommunities);
  $$CommunityMembersTableTableManager get communityMembers =>
      $$CommunityMembersTableTableManager(_db, _db.communityMembers);
  $$CommunityEventsTableTableManager get communityEvents =>
      $$CommunityEventsTableTableManager(_db, _db.communityEvents);
  $$CollectivesTableTableManager get collectives =>
      $$CollectivesTableTableManager(_db, _db.collectives);
  $$CollectiveThreadsTableTableManager get collectiveThreads =>
      $$CollectiveThreadsTableTableManager(_db, _db.collectiveThreads);
  $$ThreadRepliesTableTableManager get threadReplies =>
      $$ThreadRepliesTableTableManager(_db, _db.threadReplies);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$AudioTracksTableTableManager get audioTracks =>
      $$AudioTracksTableTableManager(_db, _db.audioTracks);
  $$PlaylistsTableTableManager get playlists =>
      $$PlaylistsTableTableManager(_db, _db.playlists);
  $$StoriesTableTableManager get stories =>
      $$StoriesTableTableManager(_db, _db.stories);
  $$StorySegmentsTableTableManager get storySegments =>
      $$StorySegmentsTableTableManager(_db, _db.storySegments);
  $$StoryViewsTableTableManager get storyViews =>
      $$StoryViewsTableTableManager(_db, _db.storyViews);
  $$StoryReactionsTableTableManager get storyReactions =>
      $$StoryReactionsTableTableManager(_db, _db.storyReactions);
}
