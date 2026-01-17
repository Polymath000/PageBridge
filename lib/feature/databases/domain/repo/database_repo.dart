import 'package:dartz/dartz.dart';
import 'package:quicknotion/core/errors/failure.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';

abstract class DatabaseRepo {
  Future<Either<Failure, List<DatabaseEntity>>> returnTheDatabases(
    String token,
    String query
  );
}
