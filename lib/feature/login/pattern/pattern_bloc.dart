import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'pattern_event.dart';
part 'pattern_state.dart';

class PatternBloc extends Bloc<PatternEvent, PatternState> {
  PatternBloc() : super(PatternInitial());

  @override
  Stream<PatternState> mapEventToState(
    PatternEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
