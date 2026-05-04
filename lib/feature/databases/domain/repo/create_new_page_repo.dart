import 'package:dartz/dartz.dart';
import 'package:pagebridge/core/errors/failure.dart';
import 'package:pagebridge/feature/databases/data/model/property_model.dart';

abstract class CreateNewPageRepo {
  Future<Either<Failure, String>> createNewPage({
    required String databaseId,
    required List<PropertyModel> properties,
    String? content,
  });
}
