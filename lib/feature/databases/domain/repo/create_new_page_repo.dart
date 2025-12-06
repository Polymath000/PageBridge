import 'package:dartz/dartz.dart';
import 'package:quicknotion/core/errors/failure.dart';
import 'package:quicknotion/feature/databases/data/model/property_model.dart';

abstract class CreateNewPageRepo {
  Future<Either<Failure, void>> createNewPage({
    required List<PropertyModel> properties,
  });
}
