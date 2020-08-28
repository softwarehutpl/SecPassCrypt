import 'package:flutter/material.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:secpasscrypt/feature/data/list/list_screen.dart';
import 'package:secpasscrypt/feature/login/setup/setup_screen.dart';
import 'package:secpasscrypt/feature/navigation/navigation.dart';

class PatternScreen extends StatelessWidget {
  static const route = "/pattern";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildRationale(context),
        _buildPattern(context),
      ],
    );
  }

  Widget _buildRationale(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(
        "Please draw pattern that should be used for protection", // TODO probably should confirm it
        textAlign: TextAlign.center,
      )),
    );
  }

  Widget _buildPattern(BuildContext context) {
    return Container(
      height: 314,
      child: PatternLock(
        onInputComplete: (List<int> points) {
          popToRoot(context);
          pushReplacementNamed(context, ListScreen.route);
        },
        fillPoints: true,
      ),
    );
  }
}
