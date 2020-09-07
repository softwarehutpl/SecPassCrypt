part of 'edit_bloc.dart';

@immutable
abstract class EditEvent {}

class UpdateEntry extends EditEvent {
  final Password entry;

  UpdateEntry({@required this.entry});
}
