import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState, AuthUser;
import 'auth_repository.dart';
import '../models/auth_state.dart';
import '../models/auth_user.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;
  final _authStateController = StreamController<AuthState>.broadcast();

  SupabaseAuthRepository(this._client) {
    _init();
  }

  void _init() {
    _client.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        _authStateController.add(AuthState(
          user: AuthUser(
            id: session.user.id,
            email: session.user.email!,
            firstName: session.user.userMetadata?['first_name'] as String?,
            lastName: session.user.userMetadata?['last_name'] as String?,
          ),
        ));
      } else {
        _authStateController.add(const AuthState());
      }
    });
  }

  @override
  Stream<AuthState> get authState => _authStateController.stream;

  @override
  AuthUser? get currentUser {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return AuthUser(
      id: user.id,
      email: user.email!,
      firstName: user.userMetadata?['first_name'] as String?,
      lastName: user.userMetadata?['last_name'] as String?,
    );
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _authStateController.add(const AuthState(isLoading: true));
      await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      _authStateController.add(AuthState(error: e.toString()));
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
      await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
        },
      );
    } catch (e) {
      _authStateController.add(AuthState(error: e.toString()));
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      _authStateController.add(const AuthState(isLoading: true));
      await _client.auth.signOut();
    } catch (e) {
      _authStateController.add(AuthState(error: e.toString()));
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      _authStateController.add(const AuthState(isLoading: true));
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      _authStateController.add(AuthState(error: e.toString()));
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
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      final updates = <String, dynamic>{};
      if (firstName != null) updates['first_name'] = firstName;
      if (lastName != null) updates['last_name'] = lastName;
      if (email != null) updates['email'] = email;

      await _client.auth.updateUser(
        UserAttributes(
          data: updates,
          email: email,
        ),
      );
    } catch (e) {
      _authStateController.add(AuthState(error: e.toString()));
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
      await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      _authStateController.add(AuthState(error: e.toString()));
      rethrow;
    }
  }

  void dispose() {
    _authStateController.close();
  }
} 