import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:secpasscrypt/time_lock/time_lock_bloc.dart';

class TimeLockScreen extends StatelessWidget {
  final Widget child;

  TimeLockScreen({@required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: GetIt.I.get<TimeLockBloc>(),
      listener: (context, state) {
        if (state is LockedState) {
          pushLoginScreen(context);
        }
      },
      child: child,
    );
  }
}
