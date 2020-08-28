import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  PasswordBloc() : super(PasswordInitial());

  @override
  Stream<PasswordState> mapEventToState(
    PasswordEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
