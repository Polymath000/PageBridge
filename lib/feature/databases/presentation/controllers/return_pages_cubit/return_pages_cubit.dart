import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pagebridge/feature/databases/domain/entities/page_entity.dart';
import 'package:pagebridge/feature/databases/domain/repo/return_pages_repo.dart';

part 'return_pages_state.dart';

class ReturnPagesCubit extends Cubit<ReturnPagesState> {
  ReturnPagesCubit({required this.repo}) : super(ReturnPagesInitial());
  CancelToken? _cancelToken;
  final ReturnPagesRepo repo;
  Future<void> returnPages({
    String query = "",
    required String databaseId,
  }) async {
    _cancelToken?.cancel("New search initiated");
    _cancelToken = CancelToken();
    emit(ReturnPagesLoading());
    // final tokenfromDB = await SecureStorage.readData(key: tokenKey);

    final result = await repo.returnPages(
      // token ?? tokenfromDB!,
      query,
      null,
      databaseId,
      _cancelToken,
    );

    return result.fold(
      (failure) {
        if (failure.message.toLowerCase().contains('cancel')) {
          return;
        }
        emit(ReturnPagesFailure(message: failure.message));
      },
      (data) {
        emit(
          ReturnPagesSuccess(
            pages: data['pages'],
            hasMore: data['has_more'],
            nextCursor: data['next_cursor'],
            query: query,
            databaseId: databaseId,
          ),
        );
      },
    );
  }

  Future<void> fetchMore() async {
    final currentState = state;
    if (currentState is! ReturnPagesSuccess ||
        !currentState.hasMore ||
        currentState.isPaginating) {
      return;
    }
    emit(currentState.copyWith(isPaginating: true));
    final result = await repo.returnPages(
      currentState.query,
      currentState.nextCursor,
      currentState.databaseId,
      _cancelToken,
    );

    result.fold(
      (failure) {
        if (failure.message.toLowerCase().contains('cancel')) return;
        emit(ReturnPagesFailure(message: failure.message));
      },
      (data) {
        final List<PageEntity> pages = List.from(currentState.pages)
          ..addAll(data["pages"]);
        emit(
          currentState.copyWith(
            databaseId: currentState.databaseId,
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
