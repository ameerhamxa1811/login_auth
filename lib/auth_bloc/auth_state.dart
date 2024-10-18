abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess(this.message);
}

class AuthFingerprint extends AuthState {}

class AuthFaceLock extends AuthState {}

class AuthPinLock extends AuthState {}

class AuthLoginScreen extends AuthState {}