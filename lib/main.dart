import 'package:flutter/material.dart';
import 'package:secpasscrypt/feature/login/biometric/biometric_screen.dart';
import 'package:secpasscrypt/feature/login/login_type.dart';
import 'package:secpasscrypt/feature/login/password/password_screen.dart';
import 'package:secpasscrypt/feature/login/pattern/pattern_screen.dart';
import 'package:secpasscrypt/feature/login/pin/pin_screen.dart';
import 'package:secpasscrypt/feature/login/setup/setup_screen.dart';
import 'package:secpasscrypt/feature/navigation/route_generator.dart';

void main() {
  final LoginType loginType = null;
  Widget initialScreen = SetupScreen();
  switch (loginType) {
    case LoginType.BIOMETRIC:
      initialScreen = BiometricScreen();
      break;
    case LoginType.PASSWORD:
      initialScreen = PasswordScreen();
      break;
    case LoginType.PATTERN:
      initialScreen = PatternScreen();
      break;
    case LoginType.PIN:
      initialScreen = PinScreen();
      break;
  }

  runApp(MaterialApp(
    title: "SecPassCrypt",
    theme: ThemeData(
      buttonTheme: ButtonThemeData(
        minWidth: 128,
        textTheme: ButtonTextTheme.primary
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    initialRoute: SetupScreen.route,
    onGenerateRoute: RouteGenerator.generateRoute,
    home: Scaffold(body: initialScreen,),
    debugShowCheckedModeBanner: false,
  ));
}
