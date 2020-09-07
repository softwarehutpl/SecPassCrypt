part of 'biometric_bloc.dart';

@immutable
abstract class BiometricState {}

class BiometricInitial extends BiometricState {}

class IndicateProgress extends BiometricInitial {}

class IncorrectBiometric extends BiometricInitial {}

class CorrectBiometric extends BiometricInitial {}
