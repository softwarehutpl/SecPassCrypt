// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Password extends DataClass implements Insertable<Password> {
  final int id;
  final String encryptedText;
  Password({@required this.id, @required this.encryptedText});
  factory Password.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Password(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      encryptedText: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}encrypted_text']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || encryptedText != null) {
      map['encrypted_text'] = Variable<String>(encryptedText);
    }
    return map;
  }

  PasswordsCompanion toCompanion(bool nullToAbsent) {
    return PasswordsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      encryptedText: encryptedText == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedText),
    );
  }

  factory Password.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Password(
      id: serializer.fromJson<int>(json['id']),
      encryptedText: serializer.fromJson<String>(json['encryptedText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'encryptedText': serializer.toJson<String>(encryptedText),
    };
  }

  Password copyWith({int id, String encryptedText}) => Password(
        id: id ?? this.id,
        encryptedText: encryptedText ?? this.encryptedText,
      );
  @override
  String toString() {
    return (StringBuffer('Password(')
          ..write('id: $id, ')
          ..write('encryptedText: $encryptedText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, encryptedText.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Password &&
          other.id == this.id &&
          other.encryptedText == this.encryptedText);
}

class PasswordsCompanion extends UpdateCompanion<Password> {
  final Value<int> id;
  final Value<String> encryptedText;
  const PasswordsCompanion({
    this.id = const Value.absent(),
    this.encryptedText = const Value.absent(),
  });
  PasswordsCompanion.insert({
    this.id = const Value.absent(),
    @required String encryptedText,
  }) : encryptedText = Value(encryptedText);
  static Insertable<Password> custom({
    Expression<int> id,
    Expression<String> encryptedText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (encryptedText != null) 'encrypted_text': encryptedText,
    });
  }

  PasswordsCompanion copyWith({Value<int> id, Value<String> encryptedText}) {
    return PasswordsCompanion(
      id: id ?? this.id,
      encryptedText: encryptedText ?? this.encryptedText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (encryptedText.present) {
      map['encrypted_text'] = Variable<String>(encryptedText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PasswordsCompanion(')
          ..write('id: $id, ')
          ..write('encryptedText: $encryptedText')
          ..write(')'))
        .toString();
  }
}

class $PasswordsTable extends Passwords
    with TableInfo<$PasswordsTable, Password> {
  final GeneratedDatabase _db;
  final String _alias;
  $PasswordsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _encryptedTextMeta =
      const VerificationMeta('encryptedText');
  GeneratedTextColumn _encryptedText;
  @override
  GeneratedTextColumn get encryptedText =>
      _encryptedText ??= _constructEncryptedText();
  GeneratedTextColumn _constructEncryptedText() {
    return GeneratedTextColumn(
      'encrypted_text',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, encryptedText];
  @override
  $PasswordsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'passwords';
  @override
  final String actualTableName = 'passwords';
  @override
  VerificationContext validateIntegrity(Insertable<Password> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('encrypted_text')) {
      context.handle(
          _encryptedTextMeta,
          encryptedText.isAcceptableOrUnknown(
              data['encrypted_text'], _encryptedTextMeta));
    } else if (isInserting) {
      context.missing(_encryptedTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Password map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Password.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PasswordsTable createAlias(String alias) {
    return $PasswordsTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $PasswordsTable _passwords;
  $PasswordsTable get passwords => _passwords ??= $PasswordsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [passwords];
}
