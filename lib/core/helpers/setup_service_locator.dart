

import 'package:data_connection_checker_tv/data_connection_checker.dart' show DataConnectionChecker;
import 'package:dio/dio.dart';
import 'package:quicknotion/core/network/network_info.dart';

import '../database/api/dio_consumer.dart';
import 'package:get_it/get_it.dart' show GetIt;

final getIt = GetIt.instance;

// void setupServiceLocator() {
//   getIt.registerSingleton<DioConsumer>(DioConsumer(dio: Dio()));
//   getIt.registerSingleton<AuthApiSource>(
//     AuthApiSource(apiConsumer: getIt.get<DioConsumer>()),
//   );
//   getIt.registerSingleton<NetworkInfoImpl>(
//     NetworkInfoImpl(DataConnectionChecker()),
//   );
//   getIt.registerSingleton<UserCacheDataSource>(
//     UserCacheDataSource(cacheHelper: CacheHelper()),
//   );
//   getIt.registerSingleton<AuthRepoImpl>(
//     AuthRepoImpl(
//       authApiSource: getIt.get<AuthApiSource>(),
//       networkInfo: getIt.get<NetworkInfoImpl>(),
//       userCacheDataSource: getIt<UserCacheDataSource>(),
//     ),
//   );
// }
