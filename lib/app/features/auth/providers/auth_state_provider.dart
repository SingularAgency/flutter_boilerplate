import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import 'auth_repository_provider.dart';

/// Provider for the auth state
final authStateProvider = StreamProvider<AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authState;
}); 