import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'create_event.dart';
part 'create_state.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  CreateBloc() : super(CreateInitial());

  @override
  Stream<CreateState> mapEventToState(
    CreateEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
