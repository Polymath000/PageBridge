part of 'recent_pages_cubit.dart';

abstract class RecentPagesState {}

class RecentPagesInitial extends RecentPagesState {}

class RecentPagesLoading extends RecentPagesState {}

class RecentPagesSuccess extends RecentPagesState {
  final List<PageEntity> pages;
  final bool hasMore;
  final String? nextCursor;
  final bool isPaginating;

  RecentPagesSuccess({
    required this.pages,
    required this.hasMore,
    this.nextCursor,
    this.isPaginating = false,
  });

  RecentPagesSuccess copyWith({
    List<PageEntity>? pages,
    bool? hasMore,
    String? nextCursor,
    bool? isPaginating,
  }) {
    return RecentPagesSuccess(
      pages: pages ?? this.pages,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
      isPaginating: isPaginating ?? this.isPaginating,
    );
  }
}

class RecentPagesFailure extends RecentPagesState {
  final String message;
  RecentPagesFailure({required this.message});
}
