import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:secpasscrypt/repository/PasswordRepository.dart';

part 'create_event.dart';
part 'create_state.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {

  final _passwordRepository = GetIt.I.get<PasswordRepository>();

  CreateBloc() : super(CreateInitial());

  @override
  Stream<CreateState> mapEventToState(
    CreateEvent event,
  ) async* {
    if (event is AddEntry) {
      yield StoringEntry();
      await _passwordRepository.addEntry(Password(plainText: event.text));
      yield EntryStored();
    }
  }
}
