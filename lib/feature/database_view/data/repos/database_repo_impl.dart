import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quicknotion/core/errors/failure.dart';
import 'package:quicknotion/core/network/network_info.dart';
import 'package:quicknotion/feature/database_view/data/data_source/database_remote_data_source.dart';
import 'package:quicknotion/feature/database_view/domain/entities/database_entity.dart';
import 'package:quicknotion/feature/database_view/domain/repo/database_repo.dart';

class DatabaseRepoImpl extends DatabaseRepo {
  DatabaseRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;
  DatabaseRepoImpl({required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, List<DatabaseEntity>>> checkTokenAndReturnTheDatabases(
    String token,
  ) async {
    try {
      if (await networkInfo.isConnected!) {
        List<DatabaseEntity> databases = await remoteDataSource
            .checkTokenAndReturnTheDatabases(token);
        return right(databases);
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
