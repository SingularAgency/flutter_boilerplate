import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Auth state class to hold authentication information
class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? refreshToken;
  final String? userId;
  final String? email;
  final String? name;
  final String? role;

  const AuthState({
    this.isAuthenticated = false,
    this.token,
    this.refreshToken,
    this.userId,
    this.email,
    this.name,
    this.role,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
    String? refreshToken,
    String? userId,
    String? email,
    String? name,
    String? role,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }
}

/// Provider for managing authentication state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Notifier class for managing authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  final _storage = const FlutterSecureStorage();
  final _dio = Dio();
  Timer? _refreshTimer;

  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  /// Initialize auth state from secure storage
  Future<void> _init() async {
    try {
      final token = await _storage.read(key: 'token');
      final refreshToken = await _storage.read(key: 'refresh_token');
      final userId = await _storage.read(key: 'user_id');
      final email = await _storage.read(key: 'email');
      final name = await _storage.read(key: 'name');
      final role = await _storage.read(key: 'role');

      if (token != null && refreshToken != null) {
        state = AuthState(
          isAuthenticated: true,
          token: token,
          refreshToken: refreshToken,
          userId: userId,
          email: email,
          name: name,
          role: role,
        );
        _setupTokenRefresh();
      }
    } catch (e) {
      state = const AuthState();
    }
  }

  /// Setup automatic token refresh
  void _setupTokenRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 55), // Refresh 5 minutes before expiry
      (_) => _refreshToken(),
    );
  }

  /// Save auth data to secure storage
  Future<void> _saveAuthData({
    required String token,
    required String refreshToken,
    String? userId,
    String? email,
    String? name,
    String? role,
  }) async {
    await Future.wait([
      _storage.write(key: 'token', value: token),
      _storage.write(key: 'refresh_token', value: refreshToken),
      if (userId != null) _storage.write(key: 'user_id', value: userId),
      if (email != null) _storage.write(key: 'email', value: email),
      if (name != null) _storage.write(key: 'name', value: name),
      if (role != null) _storage.write(key: 'role', value: role),
    ]);
  }

  /// Clear auth data from secure storage
  Future<void> _clearAuthData() async {
    await Future.wait([
      _storage.delete(key: 'token'),
      _storage.delete(key: 'refresh_token'),
      _storage.delete(key: 'user_id'),
      _storage.delete(key: 'email'),
      _storage.delete(key: 'name'),
      _storage.delete(key: 'role'),
    ]);
  }

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;
      await _saveAuthData(
        token: data['token'] as String,
        refreshToken: data['refreshToken'] as String,
        userId: data['userId'] as String?,
        email: data['email'] as String?,
        name: data['name'] as String?,
        role: data['role'] as String?,
      );

      state = AuthState(
        isAuthenticated: true,
        token: data['token'] as String,
        refreshToken: data['refreshToken'] as String,
        userId: data['userId'] as String?,
        email: data['email'] as String?,
        name: data['name'] as String?,
        role: data['role'] as String?,
      );

      _setupTokenRefresh();
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  /// Register a new user
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );

      final data = response.data as Map<String, dynamic>;
      await _saveAuthData(
        token: data['token'] as String,
        refreshToken: data['refreshToken'] as String,
        userId: data['userId'] as String?,
        email: data['email'] as String?,
        name: data['name'] as String?,
        role: data['role'] as String?,
      );

      state = AuthState(
        isAuthenticated: true,
        token: data['token'] as String,
        refreshToken: data['refreshToken'] as String,
        userId: data['userId'] as String?,
        email: data['email'] as String?,
        name: data['name'] as String?,
        role: data['role'] as String?,
      );

      _setupTokenRefresh();
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    try {
      if (state.token != null) {
        await _dio.post(
          '/auth/logout',
          options: Options(
            headers: {'Authorization': 'Bearer ${state.token}'},
          ),
        );
      }
    } catch (e) {
      // Ignore logout errors
    } finally {
      _refreshTimer?.cancel();
      await _clearAuthData();
      state = const AuthState();
    }
  }

  /// Refresh the access token
  Future<void> _refreshToken() async {
    try {
      if (state.refreshToken == null) return;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': state.refreshToken},
      );

      final data = response.data as Map<String, dynamic>;
      await _saveAuthData(
        token: data['token'] as String,
        refreshToken: data['refreshToken'] as String,
        userId: state.userId,
        email: state.email,
        name: state.name,
        role: state.role,
      );

      state = state.copyWith(
        token: data['token'] as String,
        refreshToken: data['refreshToken'] as String,
      );
    } catch (e) {
      await logout();
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? email,
  }) async {
    try {
      final response = await _dio.put(
        '/users/profile',
        data: {
          if (name != null) 'name': name,
          if (email != null) 'email': email,
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${state.token}'},
        ),
      );

      final data = response.data as Map<String, dynamic>;
      await _saveAuthData(
        token: state.token!,
        refreshToken: state.refreshToken!,
        userId: state.userId,
        email: data['email'] as String? ?? state.email,
        name: data['name'] as String? ?? state.name,
        role: state.role,
      );

      state = state.copyWith(
        email: data['email'] as String? ?? state.email,
        name: data['name'] as String? ?? state.name,
      );
    } catch (e) {
      throw Exception('Profile update failed: ${e.toString()}');
    }
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.put(
        '/users/password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${state.token}'},
        ),
      );
    } catch (e) {
      throw Exception('Password change failed: ${e.toString()}');
    }
  }

  /// Request password reset
  Future<void> requestPasswordReset(String email) async {
    try {
      await _dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
    } catch (e) {
      throw Exception('Password reset request failed: ${e.toString()}');
    }
  }

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
} 