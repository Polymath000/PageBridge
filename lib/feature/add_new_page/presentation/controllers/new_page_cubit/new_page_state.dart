part of 'new_page_cubit.dart';

@immutable
sealed class NewPageState {}

final class NewPageInitial extends NewPageState {}

final class NewPageFailure extends NewPageState {
  final String message;

  NewPageFailure({required this.message});
}

final class NewPageSuccess extends NewPageState {}

final class NewPageLoading extends NewPageState {}
