import 'package:checklist_app/core/constants/constants.dart';
import 'package:checklist_app/core/services/connection_service.dart';
import 'package:checklist_app/core/services/hive_service.dart';
import 'package:checklist_app/core/services/network_service.dart';
import 'package:checklist_app/core/services/snackbar_service.dart';
import 'package:checklist_app/core/util/themes.dart';
import 'package:checklist_app/data/auth_repository.dart';
import 'package:checklist_app/data/checklist_repository.dart';
import 'package:checklist_app/interface/auth_repository.dart';
import 'package:checklist_app/interface/checklist_repository.dart';
import 'package:checklist_app/provider/auth_provider.dart';
import 'package:checklist_app/provider/checklist_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Hive.initFlutter();
  final appDataBox = await Hive.openBox(kHiveBoxes.appData.name);
  final checklistBox = await Hive.openBox(kHiveBoxes.checklist.name);
  final syncBox = await Hive.openBox(kHiveBoxes.sync.name);

  final currentTheme = appDataBox.get('theme', defaultValue: '');
  ThemeOptions themeOption = ThemeOptions.values.firstWhere(
    (theme) => theme.name == currentTheme,
    orElse: () => ThemeOptions.system,
  );

  // Feature: Authentication
  // Provider
  sl.registerFactory(() =>
      AuthProvider(authRepository: sl(), snackBarService: sl())
        ..currentTheme = themeOption);
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(networkService: sl(), hiveService: sl()),
  );

  // Feature: Checklist
  // Provider
  sl.registerFactory(
    () => ChecklistProvider(checklistRepository: sl(), snackBarService: sl()),
  );
  // Repository
  sl.registerLazySingleton<ChecklistRepository>(
    () => ChecklistRepositoryImpl(networkService: sl(), hiveService: sl()),
  );

  // Externals
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Services
  sl.registerLazySingleton<HiveService>(() => HiveService(
        appDataBox: appDataBox,
        checklistBox: checklistBox,
        syncBox: syncBox,
      ));
  sl.registerLazySingleton<SnackBarService>(() => SnackBarService());
  sl.registerLazySingleton<NetworkService>(() => NetworkService(
        dio: sl(),
        hiveService: sl(),
        connectivity: sl(),
      ));
  sl.registerLazySingleton<ConnectionService>(() => ConnectionService(
        checklistRepository: sl(),
        connectivity: sl(),
      ));
}
