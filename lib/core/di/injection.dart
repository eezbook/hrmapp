import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../api/dio_client.dart';
import '../network/network_info.dart';
import '../router/app_router.dart';
import '../services/biometric_service.dart';
import '../services/notification_service.dart';
import '../storage/secure_storage.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_me_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../features/leave/data/datasources/leave_remote_datasource.dart';
import '../../features/leave/data/repositories/leave_repository_impl.dart';
import '../../features/leave/domain/repositories/leave_repository.dart';
import '../../features/leave/presentation/bloc/leave_bloc.dart';
import '../../features/leave/presentation/cubit/leave_balance_cubit.dart';
import '../../features/leave/presentation/cubit/leave_requests_cubit.dart';
import '../../features/leave/presentation/cubit/leave_approvals_cubit.dart';
import '../../features/attendance/data/datasources/attendance_remote_datasource.dart';
import '../../features/attendance/presentation/cubit/attendance_cubit.dart';
import '../services/location_service.dart';
import '../../features/notifications/data/datasources/notifications_remote_datasource.dart';
import '../../features/overtime/data/datasources/overtime_remote_datasource.dart';
import '../../features/overtime/presentation/cubit/overtime_cubit.dart';
import '../../features/training/data/datasources/training_remote_datasource.dart';
import '../../features/training/presentation/bloc/training_bloc.dart';
import '../../features/travel/data/datasources/travel_remote_datasource.dart';
import '../../features/travel/data/repositories/travel_repository_impl.dart';
import '../../features/travel/presentation/bloc/travel_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  final secureStorage = SecureStorage(
    const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );
  getIt.registerSingleton<SecureStorage>(secureStorage);

  final deviceInfo = DeviceInfoPlugin();
  getIt.registerSingleton<DeviceInfoPlugin>(deviceInfo);

  String deviceId = 'unknown';
  try {
    final android = await deviceInfo.androidInfo;
    deviceId = android.id;
  } catch (_) {
    try {
      final ios = await deviceInfo.iosInfo;
      deviceId = ios.identifierForVendor ?? 'unknown';
    } catch (_) {}
  }

  final dioClient = DioClient(secureStorage, deviceId);
  getIt.registerSingleton<DioClient>(dioClient);

  getIt.registerSingleton<Connectivity>(Connectivity());
  getIt.registerSingleton<NetworkInfo>(
    NetworkInfoImpl(getIt<Connectivity>()),
  );

  getIt.registerSingleton<BiometricService>(BiometricService());
  getIt.registerSingleton<NotificationService>(NotificationService());
  getIt.registerSingleton<LocationService>(LocationService());

  // Remote DataSources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSource(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<LeaveRemoteDataSource>(
    () => LeaveRemoteDataSource(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<TravelRemoteDataSource>(
    () => TravelRemoteDataSource(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<TrainingRemoteDataSource>(
    () => TrainingRemoteDataSource(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<OvertimeRemoteDataSource>(
    () => OvertimeRemoteDataSource(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSource(getIt<DioClient>().dio),
  );
  getIt.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSource(getIt<DioClient>().dio),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<SecureStorage>(),
    ),
  );
  getIt.registerLazySingleton<LeaveRepository>(
    () => LeaveRepositoryImpl(getIt<LeaveRemoteDataSource>()),
  );
  getIt.registerLazySingleton<TravelRepository>(
    () => TravelRepository(getIt<TravelRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<GetMeUseCase>(
    () => GetMeUseCase(getIt<AuthRepository>()),
  );

  // BLoCs / Cubits
  // AuthBloc is a singleton: AppRouter and the widget tree must share the
  // same instance so GoRouterRefreshStream and BlocProvider see the same state.
  final authBloc = AuthBloc(
    loginUseCase: getIt<LoginUseCase>(),
    getMeUseCase: getIt<GetMeUseCase>(),
    authRepository: getIt<AuthRepository>(),
    secureStorage: getIt<SecureStorage>(),
    biometricService: getIt<BiometricService>(),
    deviceInfo: getIt<DeviceInfoPlugin>(),
  );
  getIt.registerSingleton<AuthBloc>(authBloc);

  getIt.registerFactory<DashboardCubit>(
    () => DashboardCubit(getIt<DashboardRemoteDataSource>()),
  );
  getIt.registerFactory<LeaveBloc>(
    () => LeaveBloc(getIt<LeaveRepository>()),
  );
  getIt.registerFactory<LeaveBalanceCubit>(
    () => LeaveBalanceCubit(getIt<LeaveRepository>()),
  );
  getIt.registerFactory<LeaveRequestsCubit>(
    () => LeaveRequestsCubit(getIt<LeaveRepository>()),
  );
  getIt.registerFactory<LeaveApprovalsCubit>(
    () => LeaveApprovalsCubit(getIt<LeaveRepository>()),
  );
  getIt.registerFactory<TravelBloc>(
    () => TravelBloc(getIt<TravelRepository>()),
  );
  getIt.registerFactory<TrainingBloc>(
    () => TrainingBloc(getIt<TrainingRemoteDataSource>()),
  );
  getIt.registerFactory<AttendanceCubit>(
    () => AttendanceCubit(
      getIt<AttendanceRemoteDataSource>(),
      getIt<LocationService>(),
    ),
  );
  getIt.registerFactory<OvertimeCubit>(
    () => OvertimeCubit(getIt<OvertimeRemoteDataSource>()),
  );

  // Router (singleton because it holds navigation state)
  getIt.registerSingleton<AppRouter>(AppRouter(getIt<AuthBloc>()));
}
