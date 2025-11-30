part of 'add_token_cubit.dart';

@immutable
sealed class AddTokenState {}

final class AddTokenInitial extends AddTokenState {}

final class AddTokenLoading extends AddTokenState {}

final class AddTokenSuccess extends AddTokenState {
  final List<DatabaseEntity> databases;
  AddTokenSuccess({required this.databases});
}

final class AddTokenFailure extends AddTokenState {
  final String message;
  AddTokenFailure({required this.message});
}
