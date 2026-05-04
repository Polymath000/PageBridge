import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pagebridge/feature/databases/domain/entities/page_entity.dart';
import 'package:pagebridge/feature/databases/domain/repo/recent_pages_repo.dart';

part 'recent_pages_state.dart';

class RecentPagesCubit extends Cubit<RecentPagesState> {
  final RecentPagesRepo repo;
  CancelToken? _cancelToken;

  RecentPagesCubit({required this.repo}) : super(RecentPagesInitial());

  Future<void> fetchRecentPages() async {
    _cancelToken?.cancel("New fetch initiated");
    _cancelToken = CancelToken();
    emit(RecentPagesLoading());

    final result = await repo.getRecentPages(cancelToken: _cancelToken);

    result.fold(
      (failure) {
        if (failure.message.toLowerCase().contains('cancel')) return;
        emit(RecentPagesFailure(message: failure.message));
      },
      (data) {
        emit(
          RecentPagesSuccess(
            pages: data['pages'],
            hasMore: data['has_more'],
            nextCursor: data['next_cursor'],
          ),
        );
      },
    );
  }

  Future<void> fetchMore() async {
    final currentState = state;
    if (currentState is! RecentPagesSuccess ||
        !currentState.hasMore ||
        currentState.isPaginating) {
      return;
    }
    emit(currentState.copyWith(isPaginating: true));

    final result = await repo.getRecentPages(
      startCursor: currentState.nextCursor,
      cancelToken: _cancelToken,
    );

    result.fold(
      (failure) {
        if (failure.message.toLowerCase().contains('cancel')) return;
        emit(RecentPagesFailure(message: failure.message));
      },
      (data) {
        final List<PageEntity> pages = List.from(currentState.pages)
          ..addAll(data["pages"]);
        emit(
          currentState.copyWith(
            hasMore: data['has_more'],
            nextCursor: data['next_cursor'],
            isPaginating: false,
            pages: pages,
          ),
        );
      },
    );
  }
}
