import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pagebridge/core/errors/failure.dart';

abstract class ReturnPagesRepo {
  Future<Either<Failure, Map<String, dynamic>>> raturnPages(
    String query,
    String? startCursor,
    String databaseId,
    CancelToken? cancelToken,
  );
}
