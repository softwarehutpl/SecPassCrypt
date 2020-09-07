part of 'list_bloc.dart';

@immutable
abstract class ListEvent {}

class LoadEntries extends ListEvent { }

class ToggleEntryVisibility extends ListEvent {
  final Password entry;

  ToggleEntryVisibility({@required this.entry});
}

class EditEntry extends ListEvent {
  final Password entry;

  EditEntry({@required this.entry});
}
