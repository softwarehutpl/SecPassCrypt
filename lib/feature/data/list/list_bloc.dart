import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:secpasscrypt/repository/KeyRepository.dart';
import 'package:secpasscrypt/repository/PasswordRepository.dart';
import 'package:async/async.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {

  final _keyRepository = GetIt.I.get<KeyRepository>();
  final _passwordRepository = GetIt.I.get<PasswordRepository>();

  List<EntryWrapper> get entries => state.entries ?? [];
  Map<int, CancelableOperation> _autoHideTimers = HashMap();

  ListBloc() : super(ListInitial());

  @override
  Stream<ListState> mapEventToState(ListEvent event,) async* {
    if (event is LoadEntries) {

      yield LoadingList.from(state: state);
      final dbEntries = await _passwordRepository.retrievePasswords();
      yield ListLoaded(entries: dbEntries.map((e) {
        final oldEntryWrapperOrNull = entries.firstWhere((element) => element.entry.id == e.id, orElse: () => null);
        final isPlainText = oldEntryWrapperOrNull?.isPlainText ?? false;
        return EntryWrapper(entry: e, isPlainText: isPlainText);
      }).toList());

    } else if (event is ToggleEntryVisibility) {

      yield ListLoaded(entries: entries.map((e) {
        if (e.entry.id == event.entry.id) {
          _handleAutoHideTimers(e);
          return e.copy(isPlainText: !e.isPlainText);
        } else {
          return e;
        }
      }).toList());

    } else if (event is RemoveEntry) {

      yield LoadingList.from(state: state);
      await _passwordRepository.removePassword(event.entry);
      add(LoadEntries());
    } else if (event is SignOutEvent) {
      yield ConfirmSignOutState.from(state: state);
    } else if (event is AbandonSignOutEvent) {
      yield ListLoaded.from(state: state);
    } else if (event is ConfirmSignOutEvent) {
      yield LoadingList.from(state: state);
      await _passwordRepository.clearPasswords();
      await _keyRepository.clearKeys();
      yield SignOutState.from(state: state);
    }
  }

  _handleAutoHideTimers(EntryWrapper e) {
    final timer = _autoHideTimers[e.entry.id];
    if (!e.isPlainText) {
      timer?.cancel();
      _autoHideTimers[e.entry.id] = CancelableOperation.fromFuture(
          Future.delayed(Duration(seconds: 16))
      )..asStream().listen((event) {
        add(ToggleEntryVisibility(entry: e.entry));
      });
    } else {
      timer?.cancel();
      _autoHideTimers[e.entry.id] = null;
    }
  }
}
