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
import 'package:secpasscrypt/repository/PasswordRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

const loginTypePrefsKey = "login_type";

const salt = "LKRzZxj+7No1vDoIgehCza0N3QbQNKPiUvFJtVYd4JNfmA+xQJE2c5xc88YU13hIhzBgUdOV6EEqWm6Aa7bVJOeoPBXMEL"
    "eBP5ILffDTbkrXZ5+zb/5ZVCOo+0/Weo1bJfLQDHa72CY8XV1mAQytHHLDomtPw4p7RIIh8GTgMIA=";
const encryptedPublicKeyPrefsKey = "encrypted_public_key";
const encryptedPrivateKeyPrefsKey = "encrypted_private_key";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final stringLoginType = (await SharedPreferences.getInstance()).getString(loginTypePrefsKey);
  final LoginType loginType = LoginType.values.firstWhere((element) => element.toString() == stringLoginType, orElse: () => null);
  Widget initialScreen = SetupScreen();
  switch (loginType) {
    case LoginType.BIOMETRIC:
      initialScreen = BiometricScreen();
      break;
    case LoginType.PASSWORD:
      initialScreen = PasswordScreen(ScreenPurpose.LOGIN);
      break;
    case LoginType.PATTERN:
      initialScreen = PatternScreen();
      break;
    case LoginType.PIN:
      initialScreen = PinScreen();
      break;
  }

  final passwordRepository = RsaPasswordRepository();
  GetIt.I.registerSingleton<PasswordRepository>(passwordRepository);

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
