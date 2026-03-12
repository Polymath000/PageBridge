import 'package:dartz/dartz.dart';

import 'package:quicknotion/core/errors/failure.dart';

import '../entities/auth_token_entity.dart';

/// Contract for Notion OAuth operations.
abstract class AuthRepository {
  Future<Either<Failure, AuthTokenEntity>> signInWithNotion();
}
