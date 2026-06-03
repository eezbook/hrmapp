import 'package:dio/dio.dart';
import 'failures.dart';

class ErrorHandler {
  static Failure handle(Object error) {
    if (error is DioException && error.error is Failure) {
      return error.error as Failure;
    }
    if (error is Failure) return error;
    return UnexpectedFailure(message: error.toString());
  }
}
