import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pagebridge/core/errors/failure.dart';
import 'package:pagebridge/core/network/network_info.dart';
import 'package:pagebridge/feature/databases/data/data_source/recent_pages_remote_data_source.dart';
import 'package:pagebridge/feature/databases/domain/repo/recent_pages_repo.dart';

class RecentPagesRepoImpl extends RecentPagesRepo {
  final RecentPagesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RecentPagesRepoImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> getRecentPages({
    String? startCursor,
    String? query,
    CancelToken? cancelToken,
  }) async {
    try {
      if (await networkInfo.isConnected!) {
        final data = await remoteDataSource.getRecentPages(
          startCursor: startCursor,
          query: query,
          cancelToken: cancelToken,
        );
        return right(data);
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
