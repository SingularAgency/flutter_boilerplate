import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dio/dio.dart';
import '../repositories/repositories.dart';

/// Provider for the auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // You can switch between Supabase and Custom implementations here
  // For example, based on environment or configuration
  final useSupabase = true; // This should come from your configuration

  if (useSupabase) {
    return SupabaseAuthRepository(Supabase.instance.client);
  } else {
    return CustomAuthRepository(Dio());
  }
}); 