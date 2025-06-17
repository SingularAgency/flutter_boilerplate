import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Provider for Dio instance
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'YOUR_BASE_URL', // Replace with your API base URL
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add interceptors
  dio.interceptors.addAll([
    _LoggingInterceptor(),
    _ErrorInterceptor(),
    _AuthInterceptor(),
  ]);

  return dio;
});

/// Provider for InternetConnectionChecker
final internetConnectionCheckerProvider = Provider<InternetConnectionChecker>((ref) {
  return InternetConnectionChecker();
});

/// Provider for checking internet connectivity
final connectivityProvider = StreamProvider<bool>((ref) {
  final checker = ref.watch(internetConnectionCheckerProvider);
  return checker.onStatusChange.map((status) => status == InternetConnectionStatus.connected);
});

/// Logging interceptor for Dio
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}

/// Error interceptor for Dio
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException(err.requestOptions);
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err.requestOptions, err.response);
          case 401:
            throw UnauthorizedException(err.requestOptions, err.response);
          case 403:
            throw ForbiddenException(err.requestOptions, err.response);
          case 404:
            throw NotFoundException(err.requestOptions, err.response);
          case 500:
            throw ServerException(err.requestOptions, err.response);
          default:
            throw UnknownException(err.requestOptions, err.response);
        }
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        throw UnknownException(err.requestOptions, err.response);
      case DioExceptionType.badCertificate:
        throw BadCertificateException(err.requestOptions, err.response);
      case DioExceptionType.connectionError:
        throw ConnectionException(err.requestOptions, err.response);
    }
    super.onError(err, handler);
  }
}

/// Auth interceptor for Dio
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: Implement token management
    // final token = await getToken();
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    super.onRequest(options, handler);
  }
}

/// Custom exceptions for Dio
class TimeoutException extends DioException {
  TimeoutException(RequestOptions r) : super(requestOptions: r, type: DioExceptionType.connectionTimeout);
}

class BadRequestException extends DioException {
  BadRequestException(RequestOptions r, Response? response)
      : super(requestOptions: r, response: response, type: DioExceptionType.badResponse);
}

class UnauthorizedException extends DioException {
  UnauthorizedException(RequestOptions r, Response? response)
      : super(requestOptions: r, response: response, type: DioExceptionType.badResponse);
}

class ForbiddenException extends DioException {
  ForbiddenException(RequestOptions r, Response? response)
      : super(requestOptions: r, response: response, type: DioExceptionType.badResponse);
}

class NotFoundException extends DioException {
  NotFoundException(RequestOptions r, Response? response)
      : super(requestOptions: r, response: response, type: DioExceptionType.badResponse);
}

class ServerException extends DioException {
  ServerException(RequestOptions r, Response? response)
      : super(requestOptions: r, response: response, type: DioExceptionType.badResponse);
}

class UnknownException extends DioException {
  UnknownException(RequestOptions r, Response? response)
      : super(requestOptions: r, response: response, type: DioExceptionType.unknown);
}

class BadCertificateException extends DioException {
  BadCertificateException(RequestOptions r, Response? response)
      : super(requestOptions: r, response: response, type: DioExceptionType.badCertificate);
}

class ConnectionException extends DioException {
  ConnectionException(RequestOptions r, Response? response)
      : super(requestOptions: r, response: response, type: DioExceptionType.connectionError);
} 