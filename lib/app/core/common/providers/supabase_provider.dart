import 'package:flutter_boilerplate/app/config/environment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider for Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return SupabaseClient(
    Environment.apiBaseUrl,
    Environment.apiKey,
  );
});

/// Provider for Supabase auth
final supabaseAuthProvider = Provider<GoTrueClient>((ref) {
  return ref.watch(supabaseClientProvider).auth;
}); 