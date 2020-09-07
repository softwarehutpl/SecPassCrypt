part of 'create_bloc.dart';

@immutable
abstract class CreateEvent {}

class AddEntry extends CreateEvent {
  final String text;

  AddEntry({@required this.text});
}
