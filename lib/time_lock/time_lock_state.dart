part of 'time_lock_bloc.dart';

@immutable
abstract class TimeLockState {}

class TimeLockInitial extends TimeLockState {}

class InSessionState extends TimeLockState {}

class LockedState extends TimeLockState {}
