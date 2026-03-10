import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quicknotion/core/errors/failure.dart';

abstract class DatabaseRepo {
  Future<Either<Failure, Map<String, dynamic>>> returnTheDatabases(
    String token,
    String query,
    String? startCursor,
    CancelToken? cancelToken,
  );
}
