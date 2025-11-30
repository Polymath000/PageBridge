import 'package:dartz/dartz.dart';
import 'package:quicknotion/core/errors/failure.dart';
import 'package:quicknotion/feature/database_view/domain/entities/database_entity.dart';

abstract class DatabaseRepo {
  Future<Either<Failure, List<DatabaseEntity>>> checkTokenAndReturnTheDatabases(String token);
}
