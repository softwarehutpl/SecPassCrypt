import 'package:encrypt/encrypt.dart';
import 'package:moor/moor.dart';
import 'package:pointycastle/api.dart';
import 'package:secpasscrypt/database/db.dart' as db;

class Password {
  final int id;
  final String encryptedText;
  final String plainText;

  Password({this.id, this.encryptedText, this.plainText});

  Password.fromDataClass(db.Password dbPassword):
        id = dbPassword.id,
        encryptedText = dbPassword.encryptedText,
        plainText = null;

  Password copy({
    int id,
    String encryptedText,
    String plainText,
  }) => Password(
    id: id ?? this.id,
    encryptedText: encryptedText ?? this.encryptedText,
    plainText: plainText ?? this.plainText,
  );
}

abstract class PasswordRepository {
  Future<List<Password>> retrievePasswords();

  Stream<List<Password>> watchPasswords();

  Future<Password> addEntry(Password password);

  Future<void> removePassword(Password password);

  Future<Password> updatePassword(Password password);

  Future<void> clearPasswords();
}

class RsaPasswordRepository extends PasswordRepository {
  static final db.Database _db = db.Database();

  AsymmetricKeyPair get keyPair => _keyPair;
  AsymmetricKeyPair _keyPair;
  Encrypter _encrypter;

  void setKeys(AsymmetricKeyPair keyPair) {
    _keyPair = keyPair;
    _encrypter = Encrypter(
        RSA(
            privateKey: _keyPair.privateKey,
            publicKey: _keyPair.publicKey,
            encoding: RSAEncoding.PKCS1
        )
    );
  }

  @override
  Future<List<Password>> retrievePasswords() async {
    return (await _db.allPasswords).map((e) {
      return Password.fromDataClass(e).copy(plainText: _encrypter.decrypt64(e.encryptedText));
    }).toList();
  }

  @override
  Stream<List<Password>> watchPasswords() =>
      _db.watchAllPasswords.map((dbPasswords) =>
          dbPasswords.map((dbP) =>
              Password.fromDataClass(dbP).copy(plainText: _encrypter.decrypt64(dbP.encryptedText))
          ).toList()
      );

  @override
  Future<Password> addEntry(Password password) async {
    final encrypted = _encrypter.encrypt(password.plainText);
    final encryptedPassword = password.copy(encryptedText: encrypted.base64);
    final id = await _db.addPassword(db.PasswordsCompanion(
      encryptedText: Value(encryptedPassword.encryptedText),
    ));
    return encryptedPassword.copy(id: id);
  }

  @override
  Future<void> removePassword(Password password) => _db.removePassword(password.id);

  @override
  Future<Password> updatePassword(Password password) async {
    final encrypted = _encrypter.encrypt(password.plainText);
    final encryptedPassword = password.copy(encryptedText: encrypted.base64);
    await _db.updatePassword(db.PasswordsCompanion(
      id: Value(encryptedPassword.id),
      encryptedText: Value(encryptedPassword.encryptedText),
    ));
    return encryptedPassword;
  }

  @override
  Future<void> clearPasswords() async => _db.clearPasswords();
}