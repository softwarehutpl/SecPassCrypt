part of 'password_bloc.dart';

@immutable
abstract class PasswordEvent {}

class PasswordProvided extends PasswordEvent {
  final String password;
  final String confirmedPassword;
  final ScreenPurpose purpose;

  PasswordProvided(this.password, this.confirmedPassword, this.purpose);
}