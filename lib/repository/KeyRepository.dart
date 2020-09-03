import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:pointycastle/api.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class KeyRepository {
  Future<AsymmetricKeyPair> generateKeys();

  Future<void> storePasswordEncryptedKeys(String password, AsymmetricKeyPair keyPair);
  Future<AsymmetricKeyPair> retrievePasswordEncryptedKeys(String password);

  /* TODO Issue #4 */
  Future<void> storeBiometricEncryptedKeys(AsymmetricKeyPair keyPair);
  Future<AsymmetricKeyPair> retrieveBiometricEncryptedKeys();

}

class RsaKeysRepository extends KeyRepository {
  static const salt = "LKRzZxj+7No1vDoIgehCza0N3QbQNKPiUvFJtVYd4JNfmA+xQJE2c5xc88YU13hIhzBgUdOV6EEqWm6Aa7bVJOeoPBXMEL"
      "eBP5ILffDTbkrXZ5+zb/5ZVCOo+0/Weo1bJfLQDHa72CY8XV1mAQytHHLDomtPw4p7RIIh8GTgMIA=";
  static const encryptedPublicKeyPrefsKey = "encrypted_public_key";
  static const encryptedPrivateKeyPrefsKey = "encrypted_private_key";

  final _rsaHelper = RsaKeyHelper();
  final _cryptor = new PlatformStringCryptor();

  @override
  Future<AsymmetricKeyPair> generateKeys() {
    return _rsaHelper.computeRSAKeyPair(_rsaHelper.getSecureRandom());
  }

  @override
  Future<void> storePasswordEncryptedKeys(String password, AsymmetricKeyPair keyPair) async {
    final key = await _cryptor.generateKeyFromPassword(password, salt);
    final publicKeyPem = _rsaHelper.encodePublicKeyToPemPKCS1(keyPair.publicKey);
    final privateKeyPem = _rsaHelper.encodePrivateKeyToPemPKCS1(keyPair.privateKey);
    final encryptedPublicKey = await _cryptor.encrypt(publicKeyPem, key);
    final encryptedPrivateKey = await _cryptor.encrypt(privateKeyPem, key);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(encryptedPublicKeyPrefsKey, encryptedPublicKey);
    await prefs.setString(encryptedPrivateKeyPrefsKey, encryptedPrivateKey);
  }

  @override
  Future<AsymmetricKeyPair> retrievePasswordEncryptedKeys(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedPublicKey = prefs.getString(encryptedPublicKeyPrefsKey);
    final encryptedPrivateKey = prefs.getString(encryptedPrivateKeyPrefsKey);

    final key = await _cryptor.generateKeyFromPassword(password, salt);
    final publicKeyPem = await _cryptor.decrypt(encryptedPublicKey, key);
    final privateKeyPem = await _cryptor.decrypt(encryptedPrivateKey, key);
    final publicKey = _rsaHelper.parsePublicKeyFromPem(publicKeyPem);
    final privateKey = _rsaHelper.parsePrivateKeyFromPem(privateKeyPem);

    final keyPair = AsymmetricKeyPair(publicKey, privateKey);

    return keyPair;
  }

  /* TODO Issue #4 */
  @override
  Future<void> storeBiometricEncryptedKeys(AsymmetricKeyPair keyPair) async {
    throw "TODO";
  }

  @override
  Future<AsymmetricKeyPair> retrieveBiometricEncryptedKeys() async {
    throw "TODO";
  }

}