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

part 'pin_event.dart';
part 'pin_state.dart';

class PinBloc extends Bloc<PinEvent, PinState> {

  final _keyRepository = GetIt.I.get<KeyRepository>();
  final _passwordRepository = GetIt.I.get<PasswordRepository>();

  PinBloc() : super(PinInitial());

  @override
  Stream<PinState> mapEventToState(
    PinEvent event,
  ) async* {
    if (event is PinProvided) {
      yield IndicateProgress();

      final pin = event.pin;
      switch (event.purpose) {
        case ScreenPurpose.SETUP:
          yield* setupPinLogin(pin);
          break;
        case ScreenPurpose.LOGIN:
          yield* login(pin);
          break;
      }
    }
  }

  Stream<PinState> setupPinLogin(String pin) async* {
    try {
      final keyPair = await _keyRepository.generateKeys();
      await _keyRepository.storePasswordEncryptedKeys(pin, keyPair);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(loginTypePrefsKey, LoginType.PIN.toString());

      if (_passwordRepository is RsaPasswordRepository) {
        (_passwordRepository as RsaPasswordRepository).setKeys(keyPair);
      }

      yield CorrectPin();
    } catch (e) {
      yield IncorrectPin();
    }
  }

  Stream<PinState> login(String pin) async* {
    try {
      final keyPair = await _keyRepository.retrievePasswordEncryptedKeys(pin);

      if (_passwordRepository is RsaPasswordRepository) {
        (_passwordRepository as RsaPasswordRepository).setKeys(keyPair);
      }

      yield CorrectPin();
    } catch (e) {
      yield IncorrectPin();
    }
  }
}
