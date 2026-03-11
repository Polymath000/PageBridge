part of 'return_pages_cubit.dart';

sealed class ReturnPagesState {}

final class ReturnPagesInitial extends ReturnPagesState {}

final class ReturnPagesLoading extends ReturnPagesState {}

class ReturnPagesSuccess extends ReturnPagesState {
  final List<PageEntity> pages;
  final bool hasMore;
  final String? nextCursor;
  final bool isPaginating;
  final String query;
  final String DatabaseId;
  ReturnPagesSuccess({
    required this.pages,
    this.hasMore = false,
    this.nextCursor,
    this.isPaginating = false,
    this.query = "",
    required this.DatabaseId,
  });

  ReturnPagesSuccess copyWith({
    List<PageEntity>? pages,
    bool? hasMore,
    String? nextCursor,
    bool? isPaginating,
    String? query,
    String? DatabaseId,
  }) {
    return ReturnPagesSuccess(
      pages: pages ?? this.pages,
      hasMore: hasMore ?? this.hasMore,
      isPaginating: isPaginating ?? this.isPaginating,
      nextCursor: nextCursor ?? this.nextCursor,
      query: query ?? this.query,
      DatabaseId: DatabaseId ?? this.DatabaseId,
    );
  }
}

final class ReturnPagesFailure extends ReturnPagesState {
  final String message;
  ReturnPagesFailure({required this.message});
}
