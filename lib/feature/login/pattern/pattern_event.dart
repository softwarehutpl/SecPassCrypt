part of 'pattern_bloc.dart';

@immutable
abstract class PatternEvent {}

class PatternProvided extends PatternEvent {
  final List<int> points;
  final ScreenPurpose purpose;

  PatternProvided(this.points, this.purpose);
}
