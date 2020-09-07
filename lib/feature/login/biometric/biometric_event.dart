part of 'biometric_bloc.dart';

@immutable
abstract class BiometricEvent {}

class StartListening extends BiometricEvent {
  final ScreenPurpose purpose;

  StartListening(this.purpose);
}
