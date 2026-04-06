import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pagebridge/core/errors/failure.dart';

abstract class DatabaseRepo {
  Future<Either<Failure, Map<String, dynamic>>> returnTheDatabases(
    String query,
    String? startCursor,
    CancelToken? cancelToken,
  );
}
