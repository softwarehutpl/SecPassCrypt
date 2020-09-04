import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:secpasscrypt/feature/data/list/list_screen.dart';
import 'package:secpasscrypt/feature/login/biometric/biometric_bloc.dart';
import 'package:secpasscrypt/feature/login/screen_purpose.dart';
import 'package:secpasscrypt/feature/navigation/navigation.dart';

class BiometricScreenArguments {
  final ScreenPurpose purpose;

  BiometricScreenArguments(this.purpose);
}

class BiometricScreen extends StatefulWidget {
  static const route = "/biometric";
  final ScreenPurpose purpose;

  BiometricScreen(this.purpose);

  @override
  _BiometricScreenState createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  final _bloc = BiometricBloc();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _bloc,
      listener: (context, state) {
        if (state is IncorrectBiometric) {
          if (widget.purpose == ScreenPurpose.SETUP) {
            popScreen(context);
          } else {
            _bloc..add(StartListening(widget.purpose));
          }
        }
        if (state is CorrectBiometric) {
          popToRoot(context);
          pushReplacementNamed(context, ListScreen.route);
        }
      },
      child: BlocBuilder(
        cubit: _bloc..add(StartListening(widget.purpose)),
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state is IndicateProgress,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildRationale(context),
                _buildFingerprintIcon(context),
              ],
            ),
          );
        },
      ),
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

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
