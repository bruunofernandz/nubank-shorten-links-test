import 'package:dio/dio.dart';
import 'package:nubank_shorten_links/core/errors/failure.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkFailure('Connection timed out. Please try again.');
        case DioExceptionType.badResponse:
          return ServerFailure(
            'Server error: ${error.response?.statusCode ?? 'Unknown'}',
          );
        case DioExceptionType.cancel:
          return UnknownFailure('Request was cancelled.');
        case DioExceptionType.connectionError:
          return NetworkFailure(
            'No internet connection. Please check your network.',
          );
        case DioExceptionType.badCertificate:
          return ServerFailure('Bad certificate. Please contact support.');
        case DioExceptionType.unknown:
          return UnknownFailure('An unknown error occurred.');
      }
    } else {
      return UnknownFailure(
        'An unexpected error occurred: ${error.toString()}.',
      );
    }
  }
}
