import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:pagebridge/core/database/api/dio_consumer.dart';
import 'package:pagebridge/core/network/network_info.dart';
import 'package:pagebridge/core/services/notion_oauth_config.dart';
import 'package:pagebridge/feature/auth/data/data_source/auth_local_data_source.dart';
import 'package:pagebridge/feature/auth/data/data_source/auth_remote_data_source.dart';
import 'package:pagebridge/feature/auth/data/repos/auth_repo_impl.dart';
import 'package:pagebridge/feature/auth/domain/usecases/sign_in_with_notion_usecase.dart';
import 'package:pagebridge/feature/databases/data/data_source/create_new_page_data_source.dart';
import 'package:pagebridge/feature/databases/data/data_source/database_remote_data_source.dart';
import 'package:pagebridge/feature/databases/data/data_source/recent_pages_remote_data_source.dart';
import 'package:pagebridge/feature/databases/data/data_source/return_pages_remote_data_source.dart';
import 'package:pagebridge/feature/databases/data/repos/create_new_page_repo_impl.dart';
import 'package:pagebridge/feature/databases/data/repos/database_repo_impl.dart';
import 'package:pagebridge/feature/databases/data/repos/recent_pages_repo_impl.dart';
import 'package:pagebridge/feature/databases/data/repos/return_pages_repo_impl.dart';
import 'package:pagebridge/feature/databases/domain/repo/create_new_page_repo.dart';
import 'package:pagebridge/feature/databases/domain/repo/database_repo.dart';
import 'package:pagebridge/feature/databases/domain/repo/recent_pages_repo.dart';
import 'package:pagebridge/feature/databases/domain/repo/return_pages_repo.dart';

final getit = GetIt.instance;

setUpServiceLocator() {
  getit.registerLazySingleton<CreateNewPageRepo>(
    () => CreateNewPageRepoImpl(
      createNewPageDataSource: getit.get<CreateNewPageDataSourceImpl>(),
      networkInfo: getit.get<NetworkInfo>(),
    ),
  );
  getit.registerLazySingleton<RecentPagesRepo>(
    () => RecentPagesRepoImpl(
      remoteDataSource: getit.get<RecentPagesRemoteDataSourceImpl>(),
      networkInfo: getit.get<NetworkInfo>(),
    ),
  );

  /// Data Sources
  getit.registerLazySingleton<Dio>(() => Dio());

  getit.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(),
  );
  getit.registerLazySingleton<DatabaseRemoteDataSourceImpl>(
    () => DatabaseRemoteDataSourceImpl(DioConsumer(dio: getit.get<Dio>())),
  );
  getit.registerLazySingleton<ReturnPagesRemoteDataSourceImpl>(
    () => ReturnPagesRemoteDataSourceImpl(DioConsumer(dio: getit.get<Dio>())),
  );
  getit.registerLazySingleton<CreateNewPageDataSourceImpl>(
    () => CreateNewPageDataSourceImpl(DioConsumer(dio: getit.get<Dio>())),
  );
  getit.registerLazySingleton<RecentPagesRemoteDataSourceImpl>(
    () => RecentPagesRemoteDataSourceImpl(DioConsumer(dio: getit.get<Dio>())),
  );

  getit.registerLazySingleton<DatabaseRepo>(
    () => DatabaseRepoImpl(
      remoteDataSource: getit.get<DatabaseRemoteDataSource>(),
      networkInfo: getit.get<NetworkInfo>(),
    ),
  );

  getit.registerLazySingleton<DatabaseRemoteDataSource>(
    () => DatabaseRemoteDataSourceImpl(DioConsumer(dio: getit.get<Dio>())),
  );

  getit.registerLazySingleton<NotionOAuthConfig>(
    () => NotionOAuthConfig.fromEnvironment(),
  );

  getit.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      dioConsumer: DioConsumer(dio: getit.get<Dio>()),
      config: getit.get<NotionOAuthConfig>(),
    ),
  );

  getit.registerLazySingleton<AuthLocalDataSource>(
    () => const AuthLocalDataSourceImpl(),
  );

  getit.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(
      remoteDataSource: getit.get<AuthRemoteDataSource>(),
      localDataSource: getit.get<AuthLocalDataSource>(),
      networkInfo: getit.get<NetworkInfo>(),
    ),
  );

  getit.registerLazySingleton<SignInWithNotionUseCase>(
    () => SignInWithNotionUseCase(
      repository: getit.get<AuthRepositoryImpl>(),
    ),
  );
  //? getit for return pages
  getit.registerLazySingleton<ReturnPagesRepo>(
    () => ReturnPagesRepoImpl(
      returnPagesRemoteDataSource: getit.get<ReturnPagesRemoteDataSourceImpl>(),
      networkInfo: getit.get<NetworkInfo>(),
    ),
  );

}
