import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nubank_shorten_links/core/errors/error_handler.dart';
import 'package:nubank_shorten_links/core/errors/failure.dart';

void main() {
  group('ErrorHandler.handle', () {
    test('should returns NetworkFailure for connectionTimeout', () {
      final error = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: ''),
      );
      final result = ErrorHandler.handle(error);
      expect(result, isA<NetworkFailure>());
      expect(result.message, contains('Connection timed out'));
    });

    test('should returns NetworkFailure for sendTimeout', () {
      final error = DioException(
        type: DioExceptionType.sendTimeout,
        requestOptions: RequestOptions(path: ''),
      );
      final result = ErrorHandler.handle(error);
      expect(result, isA<NetworkFailure>());
      expect(result.message, contains('Connection timed out'));
    });

    test('should returns NetworkFailure for receiveTimeout', () {
      final error = DioException(
        type: DioExceptionType.receiveTimeout,
        requestOptions: RequestOptions(path: ''),
      );
      final result = ErrorHandler.handle(error);
      expect(result, isA<NetworkFailure>());
      expect(result.message, contains('Connection timed out'));
    });

    test('should returns ServerFailure for badResponse with status code', () {
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
      );
      final error = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: ''),
        response: response,
      );
      final result = ErrorHandler.handle(error);
      expect(result, isA<ServerFailure>());
      expect(result.message, contains('Server error: 500'));
    });

    test(
      'should returns ServerFailure for badResponse with unknown status code',
      () {
        final error = DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
        );
        final result = ErrorHandler.handle(error);
        expect(result, isA<ServerFailure>());
        expect(result.message, contains('Server error: Unknown'));
      },
    );

    test('should returns UnknownFailure for cancel', () {
      final error = DioException(
        type: DioExceptionType.cancel,
        requestOptions: RequestOptions(path: ''),
      );
      final result = ErrorHandler.handle(error);
      expect(result, isA<UnknownFailure>());
      expect(result.message, contains('Request was cancelled'));
    });

    test('should returns NetworkFailure for connectionError', () {
      final error = DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: ''),
      );
      final result = ErrorHandler.handle(error);
      expect(result, isA<NetworkFailure>());
      expect(result.message, contains('No internet connection'));
    });

    test('should returns ServerFailure for badCertificate', () {
      final error = DioException(
        type: DioExceptionType.badCertificate,
        requestOptions: RequestOptions(path: ''),
      );
      final result = ErrorHandler.handle(error);
      expect(result, isA<ServerFailure>());
      expect(result.message, contains('Bad certificate'));
    });

    test('should returns UnknownFailure for unknown DioException', () {
      final error = DioException(
        type: DioExceptionType.unknown,
        requestOptions: RequestOptions(path: ''),
      );
      final result = ErrorHandler.handle(error);
      expect(result, isA<UnknownFailure>());
      expect(result.message, contains('An unknown error occurred'));
    });

    test('should returns UnknownFailure for non-DioException error', () {
      final error = Exception('Some error');
      final result = ErrorHandler.handle(error);
      expect(result, isA<UnknownFailure>());
      expect(result.message, contains('An unexpected error occurred'));
      expect(result.message, contains('Some error'));
    });
  });
}
