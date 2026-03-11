import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:quicknotion/feature/databases/data/repos/return_pages_repo_impl.dart';
import 'package:quicknotion/feature/databases/domain/entities/page_entity.dart';

part 'return_pages_state.dart';

class ReturnPagesCubit extends Cubit<ReturnPagesState> {
  ReturnPagesCubit({required this.repoImpl}) : super(ReturnPagesInitial());
  CancelToken? _cancelToken;
  final ReturnPagesRepoImpl repoImpl;
  Future<void> returnPages({
    String query = "",
    required String databaseId,
  }) async {
    _cancelToken?.cancel("New search initiated");
    _cancelToken = CancelToken();
    emit(ReturnPagesLoading());
    // final tokenfromDB = await SecureStorage.readData(key: tokenKey);

    final result = await repoImpl.raturnPages(
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
            DatabaseId: databaseId,
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
    final result = await repoImpl.raturnPages(
      currentState.query,
      currentState.nextCursor,
      currentState.DatabaseId,
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
            DatabaseId: currentState.DatabaseId,
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
