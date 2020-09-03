import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:secpasscrypt/feature/data/list/list_screen.dart';
import 'package:secpasscrypt/feature/login/screen_purpose.dart';
import 'package:secpasscrypt/feature/navigation/navigation.dart';
import 'package:secpasscrypt/feature/login/password/password_bloc.dart';

class PasswordScreenArguments {
  final ScreenPurpose purpose;

  PasswordScreenArguments(this.purpose);
}

class PasswordScreen extends StatefulWidget {
  static const route = "/password";
  final ScreenPurpose purpose;

  PasswordScreen(this.purpose);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _bloc = PasswordBloc();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _bloc,
      listener: (context, state) {
        if (state is CorrectPassword) {
          popToRoot(context);
          pushReplacementNamed(context, ListScreen.route);
        }
        if (state is IncorrectPassword) {
          showIncorrectPasswordDialog(context);
        }
      },
      child: BlocBuilder(
        cubit: _bloc,
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state is IndicateProgress,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildRationale(context),
                _buildPasswordInput(context),
                _buildReEnterPasswordInput(context),
                _buildSubmit(context),
              ],
            ),
          );
        },
      ),
    );
  }

  void showIncorrectPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("SecPassCrypt"),
          content: Text("There is some problem with password you provided. Try typing it again or try doing it later."),
          actions: <Widget>[
            new FlatButton(
              child: Text("Okey"),
              onPressed: () {
                popScreen(context);
              },
            )
          ],
        );
      },
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
      child: _buildPasswordFormField(context, "Password", _passwordController),
    );
  }

  Widget _buildPasswordFormField(BuildContext context, String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildReEnterPasswordInput(BuildContext context) {
    if (widget.purpose == ScreenPurpose.SETUP) {
      final errorText = null;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
        child: _buildPasswordFormField(context, "Re-enter password", _confirmPasswordController),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildSubmit(BuildContext context) {
    return Center(
      child: RaisedButton(
          onPressed: () {
            _bloc.add(PasswordProvided(
                _passwordController.text,
                _confirmPasswordController.text,
                widget.purpose
            ));
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

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
