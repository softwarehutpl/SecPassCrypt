import 'package:flutter/material.dart';

class BiometricScreen extends StatelessWidget {
  static const route = "/biometric";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildRationale(context),
        _buildFingerprintIcon(context),
      ],
    );
  }

  Widget _buildRationale(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(
        "Please, use your biometric sensor to setup protection",
        textAlign: TextAlign.center,
      )),
    );
  }

  Widget _buildFingerprintIcon(BuildContext context) {
    return Icon(
      Icons.fingerprint,
      color: Theme.of(context).disabledColor, // TODO change to accentColor once provided
      size: 128,
    );
  }
}
