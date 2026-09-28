import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pagebridge/core/errors/failure.dart';
import 'package:pagebridge/core/network/network_info.dart';

import '../../domain/entities/auth_token_entity.dart';
import '../../domain/repo/auth_repository.dart';
import '../data_source/auth_local_data_source.dart';
import '../data_source/auth_remote_data_source.dart';

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
  Future<Either<Failure, UserEntity>> signInWithNotion() async {
    try {
      if (await networkInfo.isConnected) {
        final userModel = await remoteDataSource.signInWithNotion();
        await localDataSource.saveToken(userModel);

        return right(
          UserEntity(
            accessToken: userModel.accessToken,
            workspaceId: userModel.workspaceId,
            workspaceName: userModel.workspaceName,
            workspaceIcon: userModel.workspaceIcon,
            botId: userModel.botId,
            ownerName: userModel.ownerName,
            ownerAvatarUrl: userModel.ownerAvatarUrl,
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
