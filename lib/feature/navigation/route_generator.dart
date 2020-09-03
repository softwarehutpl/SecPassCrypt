
import 'package:flutter/material.dart';
import 'package:secpasscrypt/feature/data/create/create_screen.dart';
import 'package:secpasscrypt/feature/data/edit/edit_screen.dart';
import 'package:secpasscrypt/feature/data/list/list_screen.dart';
import 'package:secpasscrypt/feature/login/biometric/biometric_screen.dart';
import 'package:secpasscrypt/feature/login/password/password_screen.dart';
import 'package:secpasscrypt/feature/login/pattern/pattern_screen.dart';
import 'package:secpasscrypt/feature/login/pin/pin_screen.dart';
import 'package:secpasscrypt/feature/login/setup/setup_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SetupScreen.route:
        return MaterialPageRoute(builder: (_) => Scaffold(body: SetupScreen()));
      case BiometricScreen.route:
        return MaterialPageRoute(builder: (_) => Scaffold(body: BiometricScreen()));
      case PasswordScreen.route:
        return MaterialPageRoute(builder: (_) => Scaffold(
            body: PasswordScreen(
                (settings.arguments as PasswordScreenArguments)?.purpose
            )));
      case PatternScreen.route:
        return MaterialPageRoute(builder: (_) => Scaffold(
            body: PatternScreen(
                (settings.arguments as PatternScreenArguments)?.purpose
            )));
      case PinScreen.route:
        return MaterialPageRoute(builder: (_) => Scaffold(
            body: PinScreen(
                (settings.arguments as PinScreenArguments)?.purpose
            )));
      case ListScreen.route:
        return MaterialPageRoute(builder: (_) => ListScreen());
      case CreateScreen.route:
        return MaterialPageRoute(builder: (_) => Scaffold(body: CreateScreen()));
      case EditScreen.route:
        return MaterialPageRoute(builder: (_) => Scaffold(body: EditScreen()));
      default:
        throw "Unsupported route parameter of value ${settings.name}. "
            "Please make sure RouteGenerator.generateRoute can handle your route.";
    }
  }
}