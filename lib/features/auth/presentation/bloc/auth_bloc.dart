import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/permissions/hrm_permissions.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/storage/hive_storage.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/employee.dart';
import '../../domain/usecases/get_me_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final GetMeUseCase _getMeUseCase;
  final AuthRepository _authRepository;
  final SecureStorage _secureStorage;
  final BiometricService _biometricService;
  final NotificationService _notificationService;
  final DeviceInfoPlugin _deviceInfo;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required GetMeUseCase getMeUseCase,
    required AuthRepository authRepository,
    required SecureStorage secureStorage,
    required BiometricService biometricService,
    required NotificationService notificationService,
    required DeviceInfoPlugin deviceInfo,
  })  : _loginUseCase = loginUseCase,
        _getMeUseCase = getMeUseCase,
        _authRepository = authRepository,
        _secureStorage = secureStorage,
        _biometricService = biometricService,
        _notificationService = notificationService,
        _deviceInfo = deviceInfo,
        super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<BiometricRequested>(_onBiometricRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<TokenCheckRequested>(_onTokenCheck);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    HrmPermissions.loadFromHive();
    final token = await _secureStorage.read(SecureKeys.authToken);
    if (token == null || token == 'demo_token') {
      await _secureStorage.deleteAll();
      HrmPermissions.clear();
      emit(AuthUnauthenticated());
      return;
    }
    final result = await _getMeUseCase();
    result.fold(
      (failure) {
        if (failure is AuthFailure || failure is PermissionFailure) {
          emit(AuthUnauthenticated());
        } else {
          emit(AuthUnauthenticated());
        }
      },
      (employee) => emit(AuthAuthenticated(employee)),
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final deviceData = await _getDeviceData();

    final result = await _loginUseCase(
      LoginParams(
        email: event.email,
        password: event.password,
        deviceId: deviceData['device_id']!,
        deviceName: deviceData['device_name']!,
        deviceType: deviceData['device_type']!,
        fcmToken: _notificationService.fcmToken,
      ),
    );

    result.fold(
      (failure) {
        String hrmCode = '';
        if (failure is PermissionFailure) hrmCode = failure.hrmErrorCode;
        if (failure is AuthFailure) hrmCode = failure.hrmErrorCode ?? '';
        emit(AuthError(failure.message, hrmCode: hrmCode));
      },
      (employee) => emit(AuthAuthenticated(employee)),
    );
  }

  Future<void> _onBiometricRequested(
    BiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    final authenticated = await _biometricService.authenticate(
      'Verify your identity to sign in',
    );
    if (!authenticated) return;

    final storedEmail = await _secureStorage.read(SecureKeys.storedEmail);
    final storedPassword = await _secureStorage.read(SecureKeys.storedPassword);
    if (storedEmail == null || storedPassword == null) return;

    add(LoginRequested(email: storedEmail, password: storedPassword));
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onTokenCheck(
    TokenCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    add(AppStarted());
  }

  Future<Map<String, String>> _getDeviceData() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final info = await _deviceInfo.androidInfo;
        return {
          'device_id': info.id,
          'device_name': '${info.manufacturer} ${info.model}',
          'device_type': 'android',
        };
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final info = await _deviceInfo.iosInfo;
        return {
          'device_id': info.identifierForVendor ?? 'unknown',
          'device_name': info.name,
          'device_type': 'ios',
        };
      }
    } catch (_) {}
    return {
      'device_id': 'unknown',
      'device_name': 'unknown',
      'device_type': 'unknown',
    };
  }
}
