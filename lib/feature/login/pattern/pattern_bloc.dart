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

part 'pattern_event.dart';
part 'pattern_state.dart';

class PatternBloc extends Bloc<PatternEvent, PatternState> {

  final _keyRepository = GetIt.I.get<KeyRepository>();
  final _passwordRepository = GetIt.I.get<PasswordRepository>();

  PatternBloc() : super(PatternInitial());

  @override
  Stream<PatternState> mapEventToState(
    PatternEvent event,
  ) async* {
    if (event is PatternProvided) {
      yield IndicateProgress();

      final points = event.points;
      switch (event.purpose) {
        case ScreenPurpose.SETUP:
          yield* setupPatternLogin(points);
          break;
        case ScreenPurpose.LOGIN:
          yield* login(points);
          break;
      }
    }
  }

  Stream<PatternState> setupPatternLogin(List<int> points) async* {
    try {
      final password = _calculatePasswordFromPoints(points);
      final keyPair = await _keyRepository.generateKeys();
      await _keyRepository.storePasswordEncryptedKeys(password, keyPair);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(loginTypePrefsKey, LoginType.PATTERN.toString());

      if (_passwordRepository is RsaPasswordRepository) {
        (_passwordRepository as RsaPasswordRepository).setKeys(keyPair);
      }

      yield CorrectPattern();
    } catch (e) {
      yield IncorrectPattern();
    }
  }

  String _calculatePasswordFromPoints(List<int> points) {
    return points.join();
  }

  Stream<PatternState> login(List<int> points) async* {
    try {
      final password = _calculatePasswordFromPoints(points);
      final keyPair = await _keyRepository.retrievePasswordEncryptedKeys(password);

      if (_passwordRepository is RsaPasswordRepository) {
        (_passwordRepository as RsaPasswordRepository).setKeys(keyPair);
      }

      yield CorrectPattern();
    } catch (e) {
      yield IncorrectPattern();
    }
  }
}
