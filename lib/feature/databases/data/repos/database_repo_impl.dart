import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pagebridge/core/errors/failure.dart';
import 'package:pagebridge/core/network/network_info.dart';
import 'package:pagebridge/feature/databases/data/data_source/database_remote_data_source.dart';
import 'package:pagebridge/feature/databases/domain/repo/database_repo.dart';

class DatabaseRepoImpl extends DatabaseRepo {
  final DatabaseRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DatabaseRepoImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, Map<String, dynamic>>> returnTheDatabases(
    String query,
    String? startCursor,
    CancelToken? cancelToken,
  ) async {
    try {
      if (await networkInfo.isConnected!) {
        final databasesData = await remoteDataSource.returnTheDatabases(
          query,
          startCursor,
          cancelToken: cancelToken,
        );
        return right(databasesData);
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
