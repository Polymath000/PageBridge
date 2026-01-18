import 'package:dartz/dartz.dart';
import 'package:quicknotion/core/errors/failure.dart';

abstract class ReturnPagesRepo {
  Future<Either<Failure, Map<String, dynamic>>> raturnPages(
    String token,
    String query,
    String? startCursor,
    String databaseId,
  );
}
