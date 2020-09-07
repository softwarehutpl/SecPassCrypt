import 'dart:async';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:secpasscrypt/feature/login/login_type.dart';
import 'package:secpasscrypt/feature/login/screen_purpose.dart';
import 'package:secpasscrypt/main.dart';
import 'package:secpasscrypt/repository/KeyRepository.dart';
import 'package:secpasscrypt/repository/PasswordRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'biometric_event.dart';
part 'biometric_state.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {

  final _keyRepository = GetIt.I.get<KeyRepository>();
  final _passwordRepository = GetIt.I.get<PasswordRepository>();

  BiometricBloc() : super(BiometricInitial());

  @override
  Stream<BiometricState> mapEventToState(
    BiometricEvent event,
  ) async* {
    if (event is StartListening) {
      yield IndicateProgress();

      final purpose = event.purpose;
      switch (purpose) {
        case ScreenPurpose.SETUP:
          yield* setupBiometricLogin();
          break;
        case ScreenPurpose.LOGIN:
          yield* login();
          break;
      }
    }
  }

  Stream<BiometricState> setupBiometricLogin() async* {
    try {
      final keyPair = await _keyRepository.generateKeys();
      await _keyRepository.storeBiometricEncryptedKeys(keyPair);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(loginTypePrefsKey, LoginType.BIOMETRIC.toString());

      if (_passwordRepository is RsaPasswordRepository) {
        (_passwordRepository as RsaPasswordRepository).setKeys(keyPair);
      }

      yield CorrectBiometric();
    } catch (e) {
      print(e);
      yield IncorrectBiometric();
    }
  }

  Stream<BiometricState> login() async* {
    try {
      final keyPair = await _keyRepository.retrieveBiometricEncryptedKeys();

      if (_passwordRepository is RsaPasswordRepository) {
        (_passwordRepository as RsaPasswordRepository).setKeys(keyPair);
      }

      yield CorrectBiometric();
    } catch (e) {
      print(e);
      yield IncorrectBiometric();
    }
  }
}
