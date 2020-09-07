import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:secpasscrypt/feature/data/list/list_screen.dart';
import 'package:secpasscrypt/feature/login/pattern/pattern_bloc.dart';
import 'package:secpasscrypt/feature/login/screen_purpose.dart';
import 'package:secpasscrypt/feature/navigation/navigation.dart';
import 'package:secpasscrypt/time_lock/time_lock_bloc.dart';

class PatternScreenArguments {
  final ScreenPurpose purpose;
  final bool startedFromTimeLock;

  PatternScreenArguments(this.purpose, {this.startedFromTimeLock = false});
}

class PatternScreen extends StatefulWidget {
  static const route = "/pattern";
  final ScreenPurpose purpose;
  final bool startedFromTimeLock;

  PatternScreen(this.purpose, {this.startedFromTimeLock = false});

  @override
  _PatternScreenState createState() => _PatternScreenState();
}

class _PatternScreenState extends State<PatternScreen> {
  final _bloc = PatternBloc();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _bloc,
      listener: (context, state) {
        if (state is CorrectPattern) {
          if (widget.startedFromTimeLock) {
            popScreen(context);
          } else {
            popToRoot(context);
            pushReplacementNamed(context, ListScreen.route);
          }
          GetIt.I.get<TimeLockBloc>().add(StartSession());
        }
        if (state is IncorrectPattern) {
          showIncorrectPatternDialog(context);
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
                _buildPattern(context),
              ],
            ),
          );
        },
      ),
    );
  }

  void showIncorrectPatternDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("SecPassCrypt"),
          content: Text("There is some problem with pattern you provided. Please draw it again."),
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
        "Please draw pattern that should be used for protection",
        textAlign: TextAlign.center,
      )),
    );
  }

  Widget _buildPattern(BuildContext context) {
    return Container(
      height: 314,
      child: PatternLock(
        onInputComplete: (List<int> points) {
          _bloc.add(PatternProvided(points, widget.purpose,));
        },
        fillPoints: true,
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
