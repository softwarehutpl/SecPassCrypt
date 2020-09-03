import 'package:flutter/material.dart';
import 'package:secpasscrypt/feature/login/biometric/biometric_screen.dart';
import 'package:secpasscrypt/feature/login/password/password_bloc.dart';
import 'package:secpasscrypt/feature/login/password/password_screen.dart';
import 'package:secpasscrypt/feature/login/pattern/pattern_screen.dart';
import 'package:secpasscrypt/feature/login/pin/pin_screen.dart';
import 'package:secpasscrypt/feature/login/screen_purpose.dart';
import 'package:secpasscrypt/feature/navigation/navigation.dart';

class SetupScreen extends StatelessWidget {
  static const route = "/setup";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildRationale(context),
        _buildBiometricButton(context),
        _buildPasswordButton(context),
        _buildPatternButton(context),
        _buildPinButton(context),
      ],
    );
  }

  Widget _buildRationale(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(
        "Pick how you would like to secure your encryption key?",
        textAlign: TextAlign.center,
      )),
    );
  }

  Widget _buildBiometricButton(BuildContext context) {
    return _buildButton(
      context,
      text: "BIOMETRIC",
      onPressed: () {
        pushNamed(context, BiometricScreen.route);
      }
    );
  }

  Widget _buildButton(BuildContext context, { String text, VoidCallback onPressed }) {
    return Center(
      child: RaisedButton(
          onPressed: onPressed,
          child: Container(
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          )
      ),
    );
  }

  Widget _buildPasswordButton(BuildContext context) {
    return _buildButton(
        context,
        text: "PASSWORD",
        onPressed: () {
          pushNamed(context, PasswordScreen.route, arguments: PasswordScreenArguments(ScreenPurpose.SETUP));
        }
    );
  }

  Widget _buildPatternButton(BuildContext context) {
    return _buildButton(
        context,
        text: "PATTERN",
        onPressed: () {
          pushNamed(context, PatternScreen.route, arguments: PatternScreenArguments(ScreenPurpose.SETUP));
        }
    );
  }

  Widget _buildPinButton(BuildContext context) {
    return _buildButton(
        context,
        text: "PIN",
        onPressed: () {
          pushNamed(context, PinScreen.route, arguments: PinScreenArguments(ScreenPurpose.SETUP));
        }
    );
  }
}
