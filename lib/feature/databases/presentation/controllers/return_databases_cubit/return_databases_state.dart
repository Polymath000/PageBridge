part of 'return_databases_cubit.dart';

sealed class DatabasesState {}

final class DatabasesInitial extends DatabasesState {}

final class DatabasesLoading extends DatabasesState {
  final String query;

  DatabasesLoading({required this.query});
}

class DatabasesSuccess extends DatabasesState {
  final List<DatabaseEntity> databases;
  final bool hasMore;
  final String? nextCursor;
  final String query;

  DatabasesSuccess({
    required this.databases,
    required this.hasMore,
    required this.nextCursor,
    required this.query,
  });
}

class DatabasesSearchSuccess extends DatabasesState {
  final List<DatabaseEntity> databases;
  final bool hasMore;
  final String? nextCursor;
  final String query;

  DatabasesSearchSuccess({
    required this.databases,
    required this.hasMore,
    required this.nextCursor,
    required this.query,
  });
}

final class DatabasesFailure extends DatabasesState {
  final String message;
  final String query;

  DatabasesFailure({required this.message, required this.query});
}
