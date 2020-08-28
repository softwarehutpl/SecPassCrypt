import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'edit_event.dart';
part 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  EditBloc() : super(EditInitial());

  @override
  Stream<EditState> mapEventToState(
    EditEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
