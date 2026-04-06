import 'package:dartz/dartz.dart';

import 'package:pagebridge/core/errors/failure.dart';

import '../entities/auth_token_entity.dart';
import '../repo/auth_repository.dart';

class SignInWithNotionUseCase {
  final AuthRepository repository;

  const SignInWithNotionUseCase({required this.repository});

  Future<Either<Failure, AuthTokenEntity>> call() =>
      repository.signInWithNotion();
}
