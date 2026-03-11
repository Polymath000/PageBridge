// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quicknotion/core/errors/failure.dart';
import 'package:quicknotion/core/network/network_info.dart';
import 'package:quicknotion/feature/databases/data/data_source/return_pages_remote_data_souce.dart';
import 'package:quicknotion/feature/databases/domain/repo/return_pages_repo.dart';

class ReturnPagesRepoImpl extends ReturnPagesRepo {
  ReturnPagesRemoteDataSource returnPagesRemoteDataSource;
  NetworkInfo networkInfo;

  ReturnPagesRepoImpl({
    required this.returnPagesRemoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, Map<String, dynamic>>> raturnPages(
    String query,
    String? startCursor,
    String databaseId,
    CancelToken? cancelToken,
  ) async {
    try {
      if (await networkInfo.isConnected!) {
        final pagesData = await returnPagesRemoteDataSource.raturnPages(
          query,
          startCursor,
          databaseId,
        );
        return right(pagesData);
      } else {
        return left(NetworkFailure.error());
      }
    } on Exception catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(message: e.toString()));
      }
    }
  }
}
