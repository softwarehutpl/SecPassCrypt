part of 'pin_bloc.dart';

@immutable
abstract class PinEvent {}

class PinProvided extends PinEvent {
  final String pin;
  final ScreenPurpose purpose;

  PinProvided(this.pin, this.purpose);
}
