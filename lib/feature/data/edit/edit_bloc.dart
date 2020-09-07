import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:secpasscrypt/repository/PasswordRepository.dart';

part 'edit_event.dart';
part 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {

  final _passwordRepository = GetIt.I.get<PasswordRepository>();

  EditBloc() : super(EditInitial());

  @override
  Stream<EditState> mapEventToState(EditEvent event,) async* {
    if (event is UpdateEntry) {
      yield UpdatingEntry();
      await _passwordRepository.updatePassword(event.entry);
      yield EntryUpdated();
    }
  }
}
