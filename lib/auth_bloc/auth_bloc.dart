import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LocalAuthentication auth = LocalAuthentication();
  final storage = FlutterSecureStorage();
  int fingerAttempts = 0;
  int faceAttempts = 0;
  int pinAttempts = 0;

  AuthBloc() : super(AuthInitial()) {
    on<StartAuthentication>(_startAuthentication);
    on<FingerprintFailed>(_handleFingerprintFailure);
    on<FaceLockFailed>(_handleFaceLockFailure);
    on<PinLockFailed>(_handlePinLockFailure);
    on<CheckPin>(_checkPin);
    on<ValidatePassword>(_validatePassword);
  }

  Future<void> _startAuthentication(
      StartAuthentication event, Emitter<AuthState> emit) async {
    bool didAuthenticate = await _authenticateWithFingerprint();
    if (didAuthenticate) {
      emit(AuthSuccess("You are authorized"));
    } else {
      emit(AuthFaceLock());
    }
  }

  Future<bool> _authenticateWithFingerprint() async {
    try {
      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate with your fingerprint',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
      return isAuthenticated;
    } catch (_) {
      return false;
    }
  }

  Future<void> _handleFingerprintFailure(
      FingerprintFailed event, Emitter<AuthState> emit) async {
    fingerAttempts += 1;
    if (fingerAttempts >= 2) {
      emit(AuthFaceLock());
    } else {
      emit(AuthFingerprint());
    }
  }

  Future<void> _handleFaceLockFailure(
      FaceLockFailed event, Emitter<AuthState> emit) async {
    faceAttempts += 1;
    if (faceAttempts >= 2) {
      emit(AuthPinLock());
    } else {
      emit(AuthFaceLock());
    }
  }

  Future<void> _handlePinLockFailure(
      PinLockFailed event, Emitter<AuthState> emit) async {
    pinAttempts += 1;
    if (pinAttempts >= 2) {
      emit(AuthLoginScreen());
    } else {
      emit(AuthPinLock());
    }
  }

  Future<void> _checkPin(CheckPin event, Emitter<AuthState> emit) async {
    String? savedPin = await storage.read(key: 'user_pin');
    if (savedPin == event.pin) {
      emit(AuthSuccess("You are authorized"));
    } else {
      add(PinLockFailed());
    }
  }

  Future<void> _validatePassword(
      ValidatePassword event, Emitter<AuthState> emit) async {
    var url = Uri.parse(
        'http://brownonions-002-site1.ftempurl.com/api/ChefRegister/ValidateChefPassword?ChefId=3&CurrentPassword=123&APIKey=mobileapi19042024');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      emit(AuthSuccess("You are authorized"));
    } else {
      // Handle failure if needed
    }
  }
}