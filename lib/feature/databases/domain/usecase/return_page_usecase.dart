import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pagebridge/core/errors/failure.dart';
import 'package:pagebridge/feature/databases/domain/entities/page_entity.dart';
import 'package:pagebridge/feature/databases/domain/repo/return_pages_repo.dart';

class ReturnPageUsecase {
  final ReturnPagesRepo returnPagesRepo;
  ReturnPageUsecase({required this.returnPagesRepo});

  Either<Failure, List<PageEntity>> call(
    String query,
    String? startCursor,
    String databaseId, {
    CancelToken? cancelToken,
  }) {
    dynamic result = returnPagesRepo.raturnPages(
      query,
      startCursor,
      databaseId,
      cancelToken,
    );
    return result.fold(
      (failure) {
        return result;
      },
      (data) {
        List<PageEntity> res = result;
        List<PageEntity> pages = [];
        for (var page in res) {
          if (page.databaseId == databaseId) {
            pages.add(page);
          }
        }
        return pages;
      },
    );
  }
}
