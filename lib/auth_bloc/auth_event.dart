abstract class AuthEvent {}

class StartAuthentication extends AuthEvent {}

class FingerprintFailed extends AuthEvent {}

class FaceLockFailed extends AuthEvent {}

class PinLockFailed extends AuthEvent {}

class CheckPin extends AuthEvent {
  final String pin;
  CheckPin(this.pin);
}

class ValidatePassword extends AuthEvent {}