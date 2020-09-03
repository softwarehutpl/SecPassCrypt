part of 'pin_bloc.dart';

@immutable
abstract class PinState {}

class PinInitial extends PinState {}

class IndicateProgress extends PinState {}

class IncorrectPin extends PinState {}

class CorrectPin extends PinState {}
