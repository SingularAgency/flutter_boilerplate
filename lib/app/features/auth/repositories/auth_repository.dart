import '../models/auth_state.dart';
import '../models/auth_user.dart';

/// Abstract interface for authentication operations
abstract class AuthRepository {
  /// Get the current authentication state
  Stream<AuthState> get authState;

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });

  /// Sign out the current user
  Future<void> signOut();

  /// Reset password
  Future<void> resetPassword(String email);

  /// Update user profile
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
  });

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Get the current user
  AuthUser? get currentUser;
} 