import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pagebridge/core/errors/failure.dart';

abstract class RecentPagesRepo {
  Future<Either<Failure, Map<String, dynamic>>> getRecentPages({
    String? startCursor,
    String? query,
    CancelToken? cancelToken,
  });
}
