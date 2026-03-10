part of 'return_databases_cubit.dart';

sealed class DatabasesState {}

final class DatabasesInitial extends DatabasesState {}

final class DatabasesLoading extends DatabasesState {}

class DatabasesSuccess extends DatabasesState {
  final List<DatabaseEntity> databases;
  final bool hasMore;
  final String? nextCursor;

  DatabasesSuccess({
    required this.databases,
    required this.hasMore,
    required this.nextCursor,
  });
}

class DatabasesSearchSuccess extends DatabasesState {
  final List<DatabaseEntity> databases;
  final bool hasMore;
  final String? nextCursor;

  DatabasesSearchSuccess({
    required this.databases,
    required this.hasMore,
    required this.nextCursor,
  });
}

final class DatabasesFailure extends DatabasesState {
  final String message;
  DatabasesFailure({required this.message});
}
