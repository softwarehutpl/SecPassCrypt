import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'db.g.dart';

class Passwords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get encryptedText => text()();
}

@UseMoor(tables: [Passwords])
class Database extends _$Database {

  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Password>> get allPasswords => select(passwords).get();

  Stream<List<Password>> get watchAllPasswords => select(passwords).watch();

  Future<int> addPassword(PasswordsCompanion passwordCompanion) {
    return into(passwords).insert(passwordCompanion);
  }

  Future removePassword(int passwordId) {
    return (delete(passwords)..where((p) => p.id.equals(passwordId))).go();
  }

  Future updatePassword(PasswordsCompanion passwordCompanion) {
    return (update(passwords)..where((p) => p.id.equals(passwordCompanion.id.value))).write(passwordCompanion);
  }

  Future clearPasswords() {
    return delete(passwords).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}