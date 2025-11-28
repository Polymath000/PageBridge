import 'package:dartz/dartz.dart';
import 'package:quicknotion/core/errors/failure.dart';
import 'package:quicknotion/feature/auth/domain/entities/database_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, List<DatabaseEntity>>> signInWithToken(String token);
}
