import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:secpasscrypt/feature/data/list/list_screen.dart';
import 'package:secpasscrypt/feature/login/pin/pin_bloc.dart';
import 'package:secpasscrypt/feature/login/screen_purpose.dart';
import 'package:secpasscrypt/feature/navigation/navigation.dart';
import 'package:secpasscrypt/time_lock/time_lock_bloc.dart';

class PinScreenArguments {
  final ScreenPurpose purpose;
  final bool startedFromTimeLock;

  PinScreenArguments(this.purpose, {this.startedFromTimeLock = false});
}

class PinScreen extends StatefulWidget {
  static const route = "/pin";
  final ScreenPurpose purpose;
  final bool startedFromTimeLock;

  PinScreen(this.purpose, {this.startedFromTimeLock = false});

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final _bloc = PinBloc();
  final _pinFocus = FocusNode();
  final _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _bloc,
      listener: (context, state) {
        if (state is CorrectPin) {
          if (widget.startedFromTimeLock) {
            popScreen(context);
          } else {
            popToRoot(context);
            pushReplacementNamed(context, ListScreen.route);
          }
          GetIt.I.get<TimeLockBloc>().add(StartSession());
        }
        if (state is IncorrectPin) {
          _pinController.text = "";
          showIncorrectPinDialog(context);
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
                _buildPin(context),
              ],
            ),
          );
        },
      ),
    );
  }

  void showIncorrectPinDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("SecPassCrypt"),
          content: Text("There is some problem with pin you provided. Please enter it again."),
          actions: <Widget>[
            new FlatButton(
              child: Text("Okey"),
              onPressed: () {
                popScreen(context);
                _pinFocus.requestFocus();
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
        "Please provide pin code that should be used for protection",
        textAlign: TextAlign.center,
      )),
    );
  }

  Widget _buildPin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: PinCodeTextField(
        controller: _pinController,
        focusNode: _pinFocus,
        autoFocus: true,
        length: 6,
        obsecureText: true,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        textInputType: TextInputType.numberWithOptions(),
        onChanged: (String pin) { },
        onCompleted: (String pin) {
          _bloc.add(PinProvided(pin, widget.purpose));
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
