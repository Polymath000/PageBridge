import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pagebridge/core/errors/failure.dart';
import 'package:pagebridge/core/network/network_info.dart';

import '../../domain/entities/auth_token_entity.dart';
import '../../domain/repo/auth_repository.dart';
import '../data_source/auth_local_data_source.dart';
import '../data_source/auth_remote_data_source.dart';

/// Coordinates Notion OAuth via remote and local data sources.
class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthTokenEntity>> signInWithNotion() async {
    try {
      if (await networkInfo.isConnected!) {
        final token = await remoteDataSource.signInWithNotion();
        await localDataSource.saveToken(token.accessToken);

        return right(
          AuthTokenEntity(
            accessToken: token.accessToken,
            workspaceId: token.workspaceId,
            workspaceName: token.workspaceName,
            botId: token.botId,
          ),
        );
      } else {
        return left(NetworkFailure.error());
      }
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } on Exception {
      return left(Failure(message: "Notion authentication failed."));
    }
  }
}
