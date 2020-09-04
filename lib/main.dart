import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secpasscrypt/feature/login/biometric/biometric_screen.dart';
import 'package:secpasscrypt/feature/login/login_type.dart';
import 'package:secpasscrypt/feature/login/password/password_bloc.dart';
import 'package:secpasscrypt/feature/login/password/password_screen.dart';
import 'package:secpasscrypt/feature/login/pattern/pattern_screen.dart';
import 'package:secpasscrypt/feature/login/pin/pin_screen.dart';
import 'package:secpasscrypt/feature/login/screen_purpose.dart';
import 'package:secpasscrypt/feature/login/setup/setup_screen.dart';
import 'package:secpasscrypt/feature/navigation/route_generator.dart';
import 'package:secpasscrypt/repository/KeyRepository.dart';
import 'package:secpasscrypt/repository/PasswordRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const loginTypePrefsKey = "login_type";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final stringLoginType = (await SharedPreferences.getInstance()).getString(loginTypePrefsKey);
  final LoginType loginType = LoginType.values.firstWhere((element) => element.toString() == stringLoginType, orElse: () => null);
  Widget initialScreen = SetupScreen();
  switch (loginType) {
    case LoginType.BIOMETRIC:
      initialScreen = BiometricScreen(ScreenPurpose.LOGIN);
      break;
    case LoginType.PASSWORD:
      initialScreen = PasswordScreen(ScreenPurpose.LOGIN);
      break;
    case LoginType.PATTERN:
      initialScreen = PatternScreen(ScreenPurpose.LOGIN);
      break;
    case LoginType.PIN:
      initialScreen = PinScreen(ScreenPurpose.LOGIN);
      break;
  }

  _prepareDI();

  runApp(MaterialApp(
    title: "SecPassCrypt",
    theme: ThemeData(
      buttonTheme: ButtonThemeData(
        minWidth: 128,
        textTheme: ButtonTextTheme.primary
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    onGenerateRoute: RouteGenerator.generateRoute,
    home: Scaffold(body: initialScreen,),
    debugShowCheckedModeBanner: false,
  ));
}

_prepareDI() {
  final getIt = GetIt.I;
  getIt.registerSingleton<PasswordRepository>(RsaPasswordRepository());
  getIt.registerSingleton<KeyRepository>(RsaKeysRepository());
}
