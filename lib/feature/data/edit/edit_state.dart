part of 'edit_bloc.dart';

@immutable
abstract class EditState {}

class EditInitial extends EditState {}

class UpdatingEntry extends EditState {}

class EntryUpdated extends EditState {}
