import 'package:flutter/material.dart';
import 'package:secpasscrypt/feature/navigation/navigation.dart';

class EditScreen extends StatelessWidget {
  static const route = "/data/list/edit";

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
        controller: TextEditingController(
            text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore"
                " magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea "
                "commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat"
                " nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit "
                "anim id est laborum."
        ),
        minLines: 8,
        maxLines: 16,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: "Adjust stored text",
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
              "UPDATE",
              textAlign: TextAlign.center,
            ),
          )
      ),
    );
  }
}
