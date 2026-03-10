// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'return_databases_cubit.dart';


sealed class DatabasesState {}

final class DatabasesInitial extends DatabasesState {}

final class DatabasesLoading extends DatabasesState {}

final class DatabasesSuccess extends DatabasesState {
  final List<DatabaseEntity> databases;
  final bool hasMore;
  final String? nextCursor;
  final bool isPaginating; // To show a loader at the bottom
  final String query;

  DatabasesSuccess({
    required this.databases,
    this.hasMore = false,
    this.nextCursor,
    this.isPaginating = false,
    this.query = "",
  });

  // copyWith is essential for updating pagination state without flickering
  DatabasesSuccess copyWith({
    List<DatabaseEntity>? databases,
    bool? hasMore,
    String? nextCursor,
    bool? isPaginating,
    String? query,
  }) {
    return DatabasesSuccess(
      databases: databases ?? this.databases,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
      isPaginating: isPaginating ?? this.isPaginating,
      query: query ?? this.query,
    );
  }
}

final class DatabasesFailure extends DatabasesState {
  final String message;
  DatabasesFailure({required this.message});
}
