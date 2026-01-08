import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quicknotion/core/errors/failure.dart';
import 'package:quicknotion/core/network/network_info.dart';
import 'package:quicknotion/feature/databases/data/data_source/create_new_page_data_source.dart';
import 'package:quicknotion/feature/databases/data/model/property_model.dart';

import 'package:quicknotion/feature/databases/domain/repo/create_new_page_repo.dart';

class CreateNewPageRepoImpl extends CreateNewPageRepo {
  final CreateNewPageDataSource createNewPageDataSource;
  final NetworkInfo networkInfo;
  CreateNewPageRepoImpl({
    required this.createNewPageDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, void>> createNewPage({
    required String databaseId,
    required List<PropertyModel> properties,
  }) async {
    try {
      if (await networkInfo.isConnected!) {
        await createNewPageDataSource.createNewPage(
          databaseId: databaseId,
          properties: properties,
        );
        return right(null);
      } else {
        return left(NetworkFailure.error());
      }
    } on Exception catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(message: e.toString()));
      }
    }
  }
}
