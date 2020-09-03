import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pointycastle/api.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:secpasscrypt/feature/login/login_type.dart';
import 'package:secpasscrypt/feature/login/screen_purpose.dart';
import 'package:secpasscrypt/main.dart';
import 'package:secpasscrypt/repository/PasswordRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {

  final _passwordRepository = GetIt.I.get<PasswordRepository>();

  PasswordBloc() : super(PasswordInitial());

  @override
  Stream<PasswordState> mapEventToState(
    PasswordEvent event,
  ) async* {
    if (event is PasswordProvided) {
      yield IndicateProgress();

      final passwordPurpose = event.purpose;
      final password = event.password;
      final confirmedPassword = event.confirmedPassword;
      switch (passwordPurpose) {
        case ScreenPurpose.SETUP:
          yield* setupPasswordLogin(password, confirmedPassword);
          break;
        case ScreenPurpose.LOGIN:
          yield* login(password);
          break;
      }
    }
  }

  Stream<PasswordState> setupPasswordLogin(String password, String confirmedPassword) async* {
    final arePasswordMatching = password == confirmedPassword;
    if (password.isEmpty || !arePasswordMatching) {
      yield IncorrectPassword();
      return;
    }

    try {
      final rsaHelper = RsaKeyHelper();
      final keyPair = await rsaHelper.computeRSAKeyPair(rsaHelper.getSecureRandom());

      if (_passwordRepository is RsaPasswordRepository) {
        (_passwordRepository as RsaPasswordRepository).setKeys(keyPair);
      }

      final cryptor = new PlatformStringCryptor();
      final key = await cryptor.generateKeyFromPassword(password, salt);
      final publicKeyPem = rsaHelper.encodePublicKeyToPemPKCS1(keyPair.publicKey);
      final privateKeyPem = rsaHelper.encodePrivateKeyToPemPKCS1(keyPair.privateKey);
      final encryptedPublicKey = await cryptor.encrypt(publicKeyPem, key);
      final encryptedPrivateKey = await cryptor.encrypt(privateKeyPem, key);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(encryptedPublicKeyPrefsKey, encryptedPublicKey);
      await prefs.setString(encryptedPrivateKeyPrefsKey, encryptedPrivateKey);

      await prefs.setString(loginTypePrefsKey, LoginType.PASSWORD.toString());
      yield CorrectPassword();
    } catch (e) {
      yield IncorrectPassword();
    }
  }

  Stream<PasswordState> login(String password) async* {
    if (password.isEmpty) {
      yield IncorrectPassword();
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final encryptedPublicKey = prefs.getString(encryptedPublicKeyPrefsKey);
      final encryptedPrivateKey = prefs.getString(encryptedPrivateKeyPrefsKey);

      final rsaHelper = RsaKeyHelper();

      final cryptor = new PlatformStringCryptor();
      final key = await cryptor.generateKeyFromPassword(password, salt);
      final publicKeyPem = await cryptor.decrypt(encryptedPublicKey, key);
      final privateKeyPem = await cryptor.decrypt(encryptedPrivateKey, key);
      final publicKey = rsaHelper.parsePublicKeyFromPem(publicKeyPem);
      final privateKey = rsaHelper.parsePrivateKeyFromPem(privateKeyPem);

      final keyPair = AsymmetricKeyPair(publicKey, privateKey);

      if (_passwordRepository is RsaPasswordRepository) {
        (_passwordRepository as RsaPasswordRepository).setKeys(keyPair);
      }

      yield CorrectPassword();
    } catch (e) {
      yield IncorrectPassword();
    }
  }
}
