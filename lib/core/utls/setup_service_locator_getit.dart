import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quicknotion/core/database/api/dio_consumer.dart';
import 'package:quicknotion/core/network/network_info.dart';
import 'package:quicknotion/feature/database_view/data/data_source/database_remote_data_source.dart';
import 'package:quicknotion/feature/database_view/data/repos/database_repo_impl.dart';

final getit = GetIt.instance;

setUpServiceLocator() {
  getit.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(DataConnectionChecker()),
  );
  getit.registerLazySingleton<DatabaseRemoteDataSource>(
    () => DatabaseRemoteDataSourceImpl(DioConsumer(dio: Dio())),
  );
  getit.registerLazySingleton<DatabaseRepoImpl>(
    () => DatabaseRepoImpl(
      remoteDataSource: getit.get<DatabaseRemoteDataSource>(),
      networkInfo: getit.get<NetworkInfo>(),
    ),
  );
}
