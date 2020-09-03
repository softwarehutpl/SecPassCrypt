part of 'pattern_bloc.dart';

@immutable
abstract class PatternState {}

class PatternInitial extends PatternState {}

class IndicateProgress extends PatternState {}

class IncorrectPattern extends PatternState {}

class CorrectPattern extends PatternState {}
