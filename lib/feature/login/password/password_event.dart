part of 'password_bloc.dart';

@immutable
abstract class PasswordEvent {}

class PasswordProvided extends PasswordEvent {
  final String password;
  final String confirmedPassword;
  final PasswordPurpose purpose;

  PasswordProvided(this.password, this.confirmedPassword, this.purpose);
}

enum PasswordPurpose {
  LOGIN,
  SETUP,
}