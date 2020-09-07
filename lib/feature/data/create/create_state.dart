part of 'create_bloc.dart';

@immutable
abstract class CreateState {}

class CreateInitial extends CreateState {}

class StoringEntry extends CreateState {}

class EntryStored extends CreateState {}
