import 'package:flutter/material.dart';
import 'package:secpasscrypt/feature/data/list/list_screen.dart';
import 'package:secpasscrypt/feature/navigation/navigation.dart';

class PasswordScreen extends StatelessWidget {
  static const route = "/password";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildRationale(context),
        _buildPasswordInput(context),
        _buildReEnterPasswordInput(context),
        _buildSubmit(context),
      ],
    );
  }

  Widget _buildRationale(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(
        "Please provide password that should be used for protection",
        textAlign: TextAlign.center,
      )),
    );
  }

  Widget _buildPasswordInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: _buildPasswordFormField(context, "Password"),
    );
  }

  Widget _buildPasswordFormField(BuildContext context, String label) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.remove_red_eye),
      ),
    );
  }

  Widget _buildReEnterPasswordInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: _buildPasswordFormField(context, "Re-enter password"),
    );
  }

  Widget _buildSubmit(BuildContext context) {
    return Center(
      child: RaisedButton(
          onPressed: () {
            popToRoot(context);
            pushReplacementNamed(context, ListScreen.route);
          },
          child: Container(
            child: Text(
              "SUBMIT",
              textAlign: TextAlign.center,
            ),
          )
      ),
    );
  }
}
