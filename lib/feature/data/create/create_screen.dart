import 'package:flutter/material.dart';
import 'package:secpasscrypt/feature/navigation/navigation.dart';

class CreateScreen extends StatelessWidget {
  static const route = "/data/list/create";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildPasswordInput(context),
        _buildSubmit(context),
      ],
    );
  }

  Widget _buildPasswordInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: TextFormField(
        minLines: 8,
        maxLines: 16,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: "Enter text you want to store securely",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSubmit(BuildContext context) {
    return Center(
      child: RaisedButton(
          onPressed: () {
            popScreen(context);
          },
          child: Container(
            child: Text(
              "ADD",
              textAlign: TextAlign.center,
            ),
          )
      ),
    );
  }
}
