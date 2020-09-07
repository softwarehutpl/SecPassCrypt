part of 'time_lock_bloc.dart';

@immutable
abstract class TimeLockEvent {}

class StartSession extends TimeLockEvent {}

class BumpUpSession extends TimeLockEvent {}

class EndSession extends TimeLockEvent {}
