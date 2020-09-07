import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:secpasscrypt/feature/login/biometric/biometric_screen.dart';
import 'package:secpasscrypt/feature/login/login_type.dart';
import 'package:secpasscrypt/feature/login/password/password_screen.dart';
import 'package:secpasscrypt/feature/login/pattern/pattern_screen.dart';
import 'package:secpasscrypt/feature/login/pin/pin_screen.dart';
import 'package:secpasscrypt/feature/login/screen_purpose.dart';
import 'package:secpasscrypt/feature/navigation/navigation.dart';
import 'package:secpasscrypt/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'time_lock_event.dart';
part 'time_lock_state.dart';

class TimeLockBloc extends Bloc<TimeLockEvent, TimeLockState> {
  CancelableOperation _lock;

  TimeLockBloc() : super(TimeLockInitial());

  @override
  Stream<TimeLockState> mapEventToState(TimeLockEvent event,) async* {
    if (event is StartSession) {
      _startFreshTimer();
      yield InSessionState();
    } else if (event is BumpUpSession) {
      if (_lock != null) {
        _startFreshTimer();
        yield InSessionState();
      }
    } else if (event is EndSession) {
      _lock?.cancel();
      _lock = null;
      yield LockedState();
    }
  }

  _startFreshTimer() {
    final _lockFuture = Future.delayed(Duration(seconds:32));
    _lock?.cancel();
    _lock = CancelableOperation.fromFuture(_lockFuture);
    _lock.asStream().listen((event) {
      add(EndSession());
    });
  }
}

pushLoginScreen(BuildContext context) async {
  final stringLoginType = (await SharedPreferences.getInstance()).getString(loginTypePrefsKey);
  final LoginType loginType = LoginType.values.firstWhere((element) => element.toString() == stringLoginType,
      orElse: () => null);
  switch (loginType) {
    case LoginType.BIOMETRIC:
      return pushNamed(context, BiometricScreen.route, arguments: BiometricScreenArguments(ScreenPurpose.LOGIN, startedFromTimeLock: true));
    case LoginType.PASSWORD:
      return pushNamed(context, PasswordScreen.route, arguments: PasswordScreenArguments(ScreenPurpose.LOGIN, startedFromTimeLock: true));
    case LoginType.PATTERN:
      return pushNamed(context, PatternScreen.route, arguments: PatternScreenArguments(ScreenPurpose.LOGIN, startedFromTimeLock: true));
    case LoginType.PIN:
      return pushNamed(context, PinScreen.route, arguments: PinScreenArguments(ScreenPurpose.LOGIN, startedFromTimeLock: true));
  }
}
