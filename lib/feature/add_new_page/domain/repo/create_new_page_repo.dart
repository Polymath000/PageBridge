import 'package:dartz/dartz.dart';
import 'package:pagebridge/core/errors/failure.dart';
import 'package:pagebridge/feature/databases/domain/entities/property_entity.dart';

abstract class CreateNewPageRepo {
  Future<Either<Failure, String>> createNewPage({
    required String databaseId,
    required List<PropertyEntity> properties,
    String? content,
  });
}
