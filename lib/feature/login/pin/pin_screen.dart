import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:secpasscrypt/feature/data/list/list_screen.dart';
import 'package:secpasscrypt/feature/navigation/navigation.dart';

class PinScreen extends StatelessWidget {
  static const route = "/pin";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildRationale(context),
        _buildPin(context),
      ],
    );
  }

  Widget _buildRationale(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(
        "Please provide pin code that should be used for protection", // TODO probably should confirm it
        textAlign: TextAlign.center,
      )),
    );
  }

  Widget _buildPin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: PinCodeTextField(
        length: 6,
        obsecureText: true,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        textInputType: TextInputType.numberWithOptions(),
        onChanged: (String newPin) { },
        onCompleted: (String pin) {
          popToRoot(context);
          pushReplacementNamed(context, ListScreen.route);
        },
      ),
    );
  }
}
