part of 'add_token_cubit.dart';

sealed class AddTokenState {}

final class AddTokenInitial extends AddTokenState {}

final class AddTokenLoading extends AddTokenState {}

class AddTokenSuccess extends AddTokenState {
  final List<DatabaseEntity> databases;
  final bool hasMore;
  final String? nextCursor;

  AddTokenSuccess(
      {required this.databases,
      required this.hasMore,
      required this.nextCursor});
}

class AddTokenSearchSuccess extends AddTokenState {
  final List<DatabaseEntity> databases;
  final bool hasMore;
  final String? nextCursor;

  AddTokenSearchSuccess(
      {required this.databases,
      required this.hasMore,
      required this.nextCursor});
}

final class AddTokenFailure extends AddTokenState {
  final String message;
  AddTokenFailure({required this.message});
}
