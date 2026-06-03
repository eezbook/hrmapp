import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hrmapp/core/error/failures.dart';
import 'package:hrmapp/core/services/biometric_service.dart';
import 'package:hrmapp/core/services/notification_service.dart';
import 'package:hrmapp/core/storage/secure_storage.dart';
import 'package:hrmapp/features/auth/domain/entities/employee.dart';
import 'package:hrmapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:hrmapp/features/auth/domain/usecases/get_me_usecase.dart';
import 'package:hrmapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:hrmapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hrmapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:hrmapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockGetMeUseCase extends Mock implements GetMeUseCase {}
class MockAuthRepository extends Mock implements AuthRepository {}
class MockSecureStorage extends Mock implements SecureStorage {}
class MockBiometricService extends Mock implements BiometricService {}
class MockNotificationService extends Mock implements NotificationService {}
class MockDeviceInfoPlugin extends Mock implements DeviceInfoPlugin {}

void main() {
  late AuthBloc bloc;
  late MockLoginUseCase loginUseCase;
  late MockGetMeUseCase getMeUseCase;
  late MockAuthRepository authRepository;
  late MockSecureStorage secureStorage;
  late MockBiometricService biometricService;
  late MockNotificationService notificationService;
  late MockDeviceInfoPlugin deviceInfo;

  const testEmployee = Employee(
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
  );

  setUp(() {
    loginUseCase = MockLoginUseCase();
    getMeUseCase = MockGetMeUseCase();
    authRepository = MockAuthRepository();
    secureStorage = MockSecureStorage();
    biometricService = MockBiometricService();
    notificationService = MockNotificationService();
    deviceInfo = MockDeviceInfoPlugin();

    when(() => notificationService.fcmToken).thenReturn(null);
    when(() => secureStorage.read(any())).thenAnswer((_) async => null);

    bloc = AuthBloc(
      loginUseCase: loginUseCase,
      getMeUseCase: getMeUseCase,
      authRepository: authRepository,
      secureStorage: secureStorage,
      biometricService: biometricService,
      notificationService: notificationService,
      deviceInfo: deviceInfo,
    );
  });

  tearDown(() => bloc.close());

  group('AppStarted', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when no token',
      build: () {
        when(() => secureStorage.read(SecureKeys.authToken))
            .thenAnswer((_) async => null);
        return bloc;
      },
      act: (b) => b.add(AppStarted()),
      expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when token valid',
      build: () {
        when(() => secureStorage.read(SecureKeys.authToken))
            .thenAnswer((_) async => 'valid_token');
        when(() => getMeUseCase())
            .thenAnswer((_) async => const Right(testEmployee));
        return bloc;
      },
      act: (b) => b.add(AppStarted()),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] on 401 from getMe',
      build: () {
        when(() => secureStorage.read(SecureKeys.authToken))
            .thenAnswer((_) async => 'expired_token');
        when(() => getMeUseCase()).thenAnswer(
            (_) async => const Left(AuthFailure()));
        return bloc;
      },
      act: (b) => b.add(AppStarted()),
      expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
    );
  });

  group('LoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on login success',
      build: () {
        when(() => loginUseCase(any()))
            .thenAnswer((_) async => const Right(testEmployee));
        return bloc;
      },
      act: (b) => b.add(
        const LoginRequested(email: 'test@test.com', password: 'pass'),
      ),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on login failure',
      build: () {
        when(() => loginUseCase(any())).thenAnswer(
          (_) async => const Left(AuthFailure(
            hrmErrorCode: 'HRM_AUTH_001',
            message: 'Not authorised',
          )),
        );
        return bloc;
      },
      act: (b) => b.add(
        const LoginRequested(email: 'test@test.com', password: 'bad'),
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>().having(
          (s) => s.hrmCode,
          'hrmCode',
          'HRM_AUTH_001',
        ),
      ],
    );
  });

  group('LogoutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthUnauthenticated] on logout',
      build: () {
        when(() => authRepository.logout())
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (b) => b.add(LogoutRequested()),
      expect: () => [isA<AuthUnauthenticated>()],
    );
  });
}
