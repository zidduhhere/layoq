import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/content/app_copy.dart';

enum AuthStep { email, otp }

/// Everything the auth screen and the app's sign-in gate need to know.
/// Auth is not backed by a server yet: any valid email plus any 6
/// digits signs in, and so does Google.
class AuthState {
  const AuthState({
    this.signedIn = false,
    this.step = AuthStep.email,
    this.email = '',
    this.error,
    this.secondsLeft = 0,
  });

  final bool signedIn;
  final AuthStep step;
  final String email;
  final String? error;
  final int secondsLeft;

  AuthState copyWith({
    bool? signedIn,
    AuthStep? step,
    String? email,
    String? error,
    bool clearError = false,
    int? secondsLeft,
  }) {
    return AuthState(
      signedIn: signedIn ?? this.signedIn,
      step: step ?? this.step,
      email: email ?? this.email,
      error: clearError ? null : (error ?? this.error),
      secondsLeft: secondsLeft ?? this.secondsLeft,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  static const int codeLength = 6;
  static const int resendSeconds = 30;

  Timer? _timer;

  @override
  AuthState build() {
    ref.onDispose(() => _timer?.cancel());
    return const AuthState();
  }

  static bool isValidEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());

  void clearError() {
    if (state.error != null) state = state.copyWith(clearError: true);
  }

  /// Returns true when the code step was reached.
  bool sendCode(String email) {
    if (!isValidEmail(email)) {
      state = state.copyWith(error: AppCopy.authEmailInvalid);
      return false;
    }
    state = state.copyWith(
      email: email.trim(),
      step: AuthStep.otp,
      clearError: true,
    );
    _startCountdown();
    return true;
  }

  void resendCode() {
    if (state.secondsLeft > 0) return;
    _startCountdown();
  }

  /// Returns true when sign-in succeeded.
  bool verify(String code) {
    if (code.length < codeLength) {
      state = state.copyWith(error: AppCopy.authOtpIncomplete);
      return false;
    }
    _timer?.cancel();
    state = state.copyWith(signedIn: true, clearError: true, secondsLeft: 0);
    return true;
  }

  void signInWithGoogle() {
    _timer?.cancel();
    state = state.copyWith(signedIn: true, clearError: true, secondsLeft: 0);
  }

  void backToEmail() {
    _timer?.cancel();
    state = state.copyWith(
      step: AuthStep.email,
      clearError: true,
      secondsLeft: 0,
    );
  }

  void signOut() {
    _timer?.cancel();
    state = const AuthState();
  }

  void _startCountdown() {
    _timer?.cancel();
    state = state.copyWith(secondsLeft: resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final left = state.secondsLeft - 1;
      state = state.copyWith(secondsLeft: left < 0 ? 0 : left);
      if (left <= 0) t.cancel();
    });
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

final isSignedInProvider = Provider<bool>(
  (ref) => ref.watch(authProvider.select((s) => s.signedIn)),
);
