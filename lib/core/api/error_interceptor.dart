import 'package:dio/dio.dart';
import '../error/failures.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapToFailure(err);
    handler.next(
      err.copyWith(
        error: failure,
        message: failure.message,
      ),
    );
  }

  Failure _mapToFailure(DioException err) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionTimeout) {
      return const NetworkFailure();
    }

    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    switch (statusCode) {
      case 400:
        return ValidationFailure(
          errors: _extractErrors(data),
          message: _extractMessage(data) ?? 'Validation error',
        );
      case 401:
        return AuthFailure(
          hrmErrorCode: _extractHrmCode(data),
          message: _extractMessage(data) ?? 'Unauthorised',
        );
      case 403:
        return PermissionFailure(
          hrmErrorCode: _extractHrmCode(data) ?? 'HRM_PERM_001',
          message: _extractMessage(data) ?? 'Permission denied',
        );
      case 404:
        return const NotFoundFailure();
      case 422:
        return ValidationFailure(
          errors: _extractErrors(data),
          message: _extractMessage(data) ?? 'Unprocessable entity',
        );
      case 500:
      default:
        return ServerFailure(
          message: _extractMessage(data) ?? 'Server error',
        );
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String?;
    }
    return null;
  }

  String? _extractHrmCode(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['hrm_error_code'] as String?;
    }
    return null;
  }

  Map<String, List<String>> _extractErrors(dynamic data) {
    if (data is Map<String, dynamic> && data['errors'] is Map) {
      final rawErrors = data['errors'] as Map<String, dynamic>;
      return rawErrors.map(
        (k, v) => MapEntry(k, (v as List).map((e) => e.toString()).toList()),
      );
    }
    return {};
  }
}
