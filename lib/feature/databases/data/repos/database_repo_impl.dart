import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quicknotion/core/errors/failure.dart';
import 'package:quicknotion/core/network/network_info.dart';
import 'package:quicknotion/feature/databases/data/data_source/database_remote_data_source.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:quicknotion/feature/databases/domain/repo/database_repo.dart';

class DatabaseRepoImpl extends DatabaseRepo {
  DatabaseRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;
  DatabaseRepoImpl({required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, Map<String, dynamic>>> returnTheDatabases(
    String token,
    String query,
    String? startCursor,
  ) async {
    try {
      if (await networkInfo.isConnected!) {
        final databasesData = await remoteDataSource.returnTheDatabases(
            token, query, startCursor);
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
