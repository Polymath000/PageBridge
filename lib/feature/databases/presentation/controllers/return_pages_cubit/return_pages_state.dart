part of 'return_pages_cubit.dart';

@immutable
sealed class ReturnPagesState {}

final class ReturnPagesInitial extends ReturnPagesState {}

final class ReturnPagesLoading extends ReturnPagesState {}

class ReturnPagesSuccess extends ReturnPagesState {
  final List<PageEntity> pages;
  final bool hasMore;
  final String? nextCursor;

  ReturnPagesSuccess({
    required this.pages,
    required this.hasMore,
    required this.nextCursor,
  });
}

class ReturnPagesSearchSuccess extends ReturnPagesState {
  final List<PageEntity> pages;
  final bool hasMore;
  final String? nextCursor;

  ReturnPagesSearchSuccess({
    required this.pages,
    required this.hasMore,
    required this.nextCursor,
  });
}

final class ReturnPagesFailure extends ReturnPagesState {
  final String message;
  ReturnPagesFailure({required this.message});
}
