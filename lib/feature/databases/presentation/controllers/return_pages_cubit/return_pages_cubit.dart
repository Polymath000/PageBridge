// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:quicknotion/feature/databases/data/repos/return_pages_repo_impl.dart';
import 'package:quicknotion/feature/databases/domain/entities/page_entity.dart';

part 'return_pages_state.dart';

class ReturnPagesCubit extends Cubit<ReturnPagesState> {
  ReturnPagesCubit({required this.repoImpl}) : super(ReturnPagesInitial());

  final ReturnPagesRepoImpl repoImpl;
  Future<List<PageEntity>> returnPages({
    required String token,
    String query = "",
    String? startCursor,
    required String databaseId,
  }) async {
    emit(ReturnPagesLoading());

    final result = await repoImpl.raturnPages(
      token,
      query,
      startCursor,
      databaseId,
    );

    return result.fold(
      (failure) {
        emit(ReturnPagesFailure(message: failure.message));
        return <PageEntity>[]; 
      },
      (data) {
        final pages = data['pages'] as List<PageEntity>;
        final hasMore = data['has_more'] as bool;
        final nextCursor = data['next_cursor'] as String?;

        if (query.isEmpty) {
          emit(
            ReturnPagesSuccess(
              pages: pages,
              hasMore: hasMore,
              nextCursor: nextCursor,
            ),
          );
        } else {
          emit(
            ReturnPagesSearchSuccess(
              pages: pages,
              hasMore: hasMore,
              nextCursor: nextCursor,
            ),
          );
        }

        return pages;
      },
    );
  }
}
