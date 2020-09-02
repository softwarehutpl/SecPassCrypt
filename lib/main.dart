import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:secpasscrypt/feature/login/biometric/biometric_screen.dart';
import 'package:secpasscrypt/feature/login/login_type.dart';
import 'package:secpasscrypt/feature/login/password/password_screen.dart';
import 'package:secpasscrypt/feature/login/pattern/pattern_screen.dart';
import 'package:secpasscrypt/feature/login/pin/pin_screen.dart';
import 'package:secpasscrypt/feature/login/setup/setup_screen.dart';
import 'package:secpasscrypt/feature/navigation/route_generator.dart';
import 'package:secpasscrypt/repository/PasswordRepository.dart';

void main() async {
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

  // TODO should create it without keys, make them optional & populate once logged in
  final rsaHelper = RsaKeyHelper();
  final passwordRepository = RsaPasswordRepository(keyPair: await rsaHelper.computeRSAKeyPair(rsaHelper.getSecureRandom()));

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<PasswordRepository>(create: (context) => passwordRepository,)
    ],
    child: MaterialApp(
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
    ),
  ));
}
