part of 'password_bloc.dart';

@immutable
abstract class PasswordState {}

class PasswordInitial extends PasswordState {}

class IndicateProgress extends PasswordState {}

class IncorrectPassword extends PasswordState {}

class CorrectPassword extends PasswordState {}