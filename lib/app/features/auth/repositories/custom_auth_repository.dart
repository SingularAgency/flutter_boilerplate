import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_repository.dart';
import '../models/auth_state.dart';
import '../models/auth_user.dart';

class CustomAuthRepository implements AuthRepository {
  final Dio _dio;
  final _authStateController = StreamController<AuthState>.broadcast();
  final _storage = const FlutterSecureStorage();
  AuthState? _currentState;

  CustomAuthRepository(this._dio) {
    _init();
  }

  void _init() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
        final response = await _dio.get('/auth/me');
        final user = AuthUser.fromJson(response.data as Map<String, dynamic>);
        _currentState = AuthState(user: user);
        _authStateController.add(_currentState!);
      } else {
        _currentState = const AuthState();
        _authStateController.add(_currentState!);
      }
    } catch (e) {
      _currentState = const AuthState();
      _authStateController.add(_currentState!);
    }
  }

  @override
  Stream<AuthState> get authState => _authStateController.stream;

  @override
  AuthUser? get currentUser => _currentState?.user;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _authStateController.add(const AuthState(isLoading: true));
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String;
      await _storage.write(key: 'token', value: token);
      _dio.options.headers['Authorization'] = 'Bearer $token';

      final user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
      _currentState = AuthState(user: user);
      _authStateController.add(_currentState!);
    } catch (e) {
      _currentState = AuthState(error: e.toString());
      _authStateController.add(_currentState!);
      rethrow;
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      _authStateController.add(const AuthState(isLoading: true));
      final response = await _dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String;
      await _storage.write(key: 'token', value: token);
      _dio.options.headers['Authorization'] = 'Bearer $token';

      final user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
      _currentState = AuthState(user: user);
      _authStateController.add(_currentState!);
    } catch (e) {
      _currentState = AuthState(error: e.toString());
      _authStateController.add(_currentState!);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      _authStateController.add(const AuthState(isLoading: true));
      await _dio.post('/auth/logout');
      await _storage.delete(key: 'token');
      _dio.options.headers.remove('Authorization');
      _currentState = const AuthState();
      _authStateController.add(_currentState!);
    } catch (e) {
      _currentState = AuthState(error: e.toString());
      _authStateController.add(_currentState!);
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      _authStateController.add(const AuthState(isLoading: true));
      await _dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
    } catch (e) {
      _currentState = AuthState(error: e.toString());
      _authStateController.add(_currentState!);
      rethrow;
    }
  }

  @override
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    try {
      _authStateController.add(const AuthState(isLoading: true));
      final response = await _dio.put(
        '/users/profile',
        data: {
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          if (email != null) 'email': email,
        },
      );

      final user = AuthUser.fromJson(response.data as Map<String, dynamic>);
      _currentState = AuthState(user: user);
      _authStateController.add(_currentState!);
    } catch (e) {
      _currentState = AuthState(error: e.toString());
      _authStateController.add(_currentState!);
      rethrow;
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _authStateController.add(const AuthState(isLoading: true));
      await _dio.put(
        '/users/password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );
    } catch (e) {
      _currentState = AuthState(error: e.toString());
      _authStateController.add(_currentState!);
      rethrow;
    }
  }

  void dispose() {
    _authStateController.close();
  }
} 