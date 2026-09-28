import 'package:dartz/dartz.dart';

import 'package:pagebridge/core/errors/failure.dart';

import '../entities/auth_token_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthTokenEntity>> signInWithNotion();
}
