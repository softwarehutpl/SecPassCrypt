part of 'list_bloc.dart';

@immutable
abstract class ListState {
  final List<EntryWrapper> entries;

  ListState({this.entries});
}

class ListInitial extends ListState {}

class LoadingList extends ListState {

  LoadingList({entries}): super(entries: entries);

  LoadingList.from({@required ListState state}) : super(entries: state.entries);
}

class ListLoaded extends ListState {

  ListLoaded({entries}): super(entries: entries);

  ListLoaded.from({@required ListState state}) : super(entries: state?.entries);
}

class ConfirmSignOutState extends ListState {

  ConfirmSignOutState({entries}): super(entries: entries);

  ConfirmSignOutState.from({@required ListState state}) : super(entries: state?.entries);
}

class SignOutState extends ListState {

  SignOutState({entries}): super(entries: entries);

  SignOutState.from({@required ListState state}) : super(entries: state?.entries);
}

class EntryWrapper {
  final Password entry;
  final bool isPlainText;

  EntryWrapper({this.entry, this.isPlainText = false});

  EntryWrapper copy({
    Password entry,
    bool isPlainText,
  }) => EntryWrapper(
    entry: entry ?? this.entry,
    isPlainText: isPlainText ?? this.isPlainText,
  );
}