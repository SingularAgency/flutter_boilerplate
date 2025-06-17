import 'package:freezed_annotation/freezed_annotation.dart';
import 'auth_user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    AuthUser? user,
    @Default(false) bool isLoading,
    String? error,
  }) = _AuthState;
}