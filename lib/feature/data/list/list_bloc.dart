import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:secpasscrypt/repository/PasswordRepository.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {

  final _passwordRepository = GetIt.I.get<PasswordRepository>();

  ListBloc() : super(ListInitial());

  @override
  Stream<ListState> mapEventToState(ListEvent event,) async* {
    if (event is LoadEntries) {
      yield LoadingList();
      final entries = await _passwordRepository.retrievePasswords();
      yield ListLoaded(entries: entries.map((e) => EntryWrapper(entry: e)).toList());
    } else if (event is ToggleEntryVisibility) {
      final safeState = state;
      final entries = (safeState is ListLoaded) ? safeState.entries : <EntryWrapper>[];
      yield ListLoaded(entries: entries.map((e) {
        if (e.entry.id == event.entry.id) {
          return e.copy(isPlainText: !e.isPlainText);
        } else {
          return e;
        }
      }).toList());
    }
  }
}
