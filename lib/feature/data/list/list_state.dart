part of 'list_bloc.dart';

@immutable
abstract class ListState {}

class ListInitial extends ListState {}

class LoadingList extends ListState {}

class ListLoaded extends ListState {
  final List<EntryWrapper> entries;

  ListLoaded({this.entries});
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