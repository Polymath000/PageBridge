import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quicknotion/core/database/api/dio_consumer.dart';
import 'package:quicknotion/core/network/network_info.dart';
import 'package:quicknotion/feature/databases/data/data_source/create_new_page_data_source.dart';
import 'package:quicknotion/feature/databases/data/data_source/database_remote_data_source.dart';
import 'package:quicknotion/feature/databases/data/data_source/return_pages_remote_data_souce.dart';
import 'package:quicknotion/feature/databases/data/repos/create_new_page_repo_impl.dart';
import 'package:quicknotion/feature/databases/data/repos/database_repo_impl.dart';
import 'package:quicknotion/feature/databases/data/repos/return_pages_repo_impl.dart';

final getit = GetIt.instance;

setUpServiceLocator() {
  getit.registerLazySingleton<CreateNewPageRepoImpl>(
    () => CreateNewPageRepoImpl(
      createNewPageDataSource: getit.get<CreateNewPageDataSourceImpl>(),
      networkInfo: getit.get<NetworkInfo>(),
    ),
  );

  getit.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(DataConnectionChecker()),
  );
  getit.registerLazySingleton<CreateNewPageDataSourceImpl>(
    () => CreateNewPageDataSourceImpl(DioConsumer(dio: Dio())),
  );

  getit.registerLazySingleton<DatabaseRepoImpl>(
    () => DatabaseRepoImpl(
      remoteDataSource: getit.get<DatabaseRemoteDataSource>(),
      networkInfo: getit.get<NetworkInfo>(),
    ),
  );

  getit.registerLazySingleton<DatabaseRemoteDataSource>(
    () => DatabaseRemoteDataSourceImpl(DioConsumer(dio: Dio())),
  );



  //? getit for return pages
  getit.registerLazySingleton<ReturnPagesRepoImpl>(
    () => ReturnPagesRepoImpl(
      returnPagesRemoteDataSource: getit.get<ReturnPagesRemoteDataSourceImpl>(),
      networkInfo: getit.get<NetworkInfo>(),
    ),
  );

  getit.registerLazySingleton<ReturnPagesRemoteDataSourceImpl>(
    () => ReturnPagesRemoteDataSourceImpl(DioConsumer(dio: Dio())),
  );
}
