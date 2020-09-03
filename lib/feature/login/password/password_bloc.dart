import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:secpasscrypt/feature/login/login_type.dart';
import 'package:secpasscrypt/feature/login/screen_purpose.dart';
import 'package:secpasscrypt/main.dart';
import 'package:secpasscrypt/repository/KeyRepository.dart';
import 'package:secpasscrypt/repository/PasswordRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {

  final _keyRepository = GetIt.I.get<KeyRepository>();
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
      final keyPair = await _keyRepository.generateKeys();
      await _keyRepository.storePasswordEncryptedKeys(password, keyPair);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(loginTypePrefsKey, LoginType.PASSWORD.toString());

      if (_passwordRepository is RsaPasswordRepository) {
        (_passwordRepository as RsaPasswordRepository).setKeys(keyPair);
      }

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
      final keyPair = await _keyRepository.retrievePasswordEncryptedKeys(password);

      if (_passwordRepository is RsaPasswordRepository) {
        (_passwordRepository as RsaPasswordRepository).setKeys(keyPair);
      }

      yield CorrectPassword();
    } catch (e) {
      yield IncorrectPassword();
    }
  }
}
