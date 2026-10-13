import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../core/content/app_copy.dart';

/// Where the sign-in link sends the user back to. Must match the URL
/// scheme in Info.plist / AndroidManifest and be listed under
/// Supabase > Authentication > URL Configuration > Redirect URLs.
const String authRedirectUrl = 'com.layoq.app://login-callback';

enum AuthStep { email, linkSent }

/// The slice of Supabase auth the app uses, so tests can fake it.
abstract class AuthGateway {
  bool get hasSession;
  String? get email;

  /// Emits whenever a session starts or ends (link tapped, sign-out,
  /// token expiry).
  Stream<({bool signedIn, String? email})> get changes;

  Future<void> sendMagicLink(String email);
  Future<void> signOut();
}

class SupabaseAuthGateway implements AuthGateway {
  sb.GoTrueClient get _auth => sb.Supabase.instance.client.auth;

  @override
  bool get hasSession => _auth.currentSession != null;

  @override
  String? get email => _auth.currentUser?.email;

  @override
  Stream<({bool signedIn, String? email})> get changes => _auth
      .onAuthStateChange
      .map((e) => (signedIn: e.session != null, email: e.session?.user.email));

  @override
  Future<void> sendMagicLink(String email) => _auth.signInWithOtp(
    email: email,
    emailRedirectTo: authRedirectUrl,
    shouldCreateUser: true,
  );

  @override
  Future<void> signOut() => _auth.signOut();
}

final authGatewayProvider = Provider<AuthGateway>(
  (ref) => SupabaseAuthGateway(),
);

/// Everything the auth screen and the app's sign-in gate need to know.
/// Email sign-in is a Supabase magic link: the user taps the emailed
/// link, the app reopens, and the session stream flips [signedIn].
class AuthState {
  const AuthState({
    this.signedIn = false,
    this.step = AuthStep.email,
    this.email = '',
    this.error,
    this.sending = false,
    this.secondsLeft = 0,
  });

  final bool signedIn;
  final AuthStep step;
  final String email;
  final String? error;
  final bool sending;
  final int secondsLeft;

  AuthState copyWith({
    bool? signedIn,
    AuthStep? step,
    String? email,
    String? error,
    bool clearError = false,
    bool? sending,
    int? secondsLeft,
  }) {
    return AuthState(
      signedIn: signedIn ?? this.signedIn,
      step: step ?? this.step,
      email: email ?? this.email,
      error: clearError ? null : (error ?? this.error),
      sending: sending ?? this.sending,
      secondsLeft: secondsLeft ?? this.secondsLeft,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  static const int resendSeconds = 30;

  Timer? _timer;

  @override
  AuthState build() {
    final gateway = ref.read(authGatewayProvider);
    final sub = gateway.changes.listen(_onSessionChange);
    ref.onDispose(() {
      sub.cancel();
      _timer?.cancel();
    });
    return AuthState(signedIn: gateway.hasSession, email: gateway.email ?? '');
  }

  void _onSessionChange(({bool signedIn, String? email}) e) {
    if (e.signedIn) {
      _timer?.cancel();
      state = AuthState(signedIn: true, email: e.email ?? state.email);
    } else if (state.signedIn) {
      state = const AuthState();
    }
  }

  static bool isValidEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());

  void clearError() {
    if (state.error != null) state = state.copyWith(clearError: true);
  }

  /// Emails a sign-in link. Returns true when it was sent.
  Future<bool> sendLink(String email) async {
    if (state.sending) return false;
    if (!isValidEmail(email)) {
      state = state.copyWith(error: AppCopy.authEmailInvalid);
      return false;
    }
    final address = email.trim();
    state = state.copyWith(sending: true, clearError: true);
    try {
      await ref.read(authGatewayProvider).sendMagicLink(address);
    } on sb.AuthException catch (e) {
      state = state.copyWith(sending: false, error: _friendly(e));
      return false;
    } catch (_) {
      state = state.copyWith(sending: false, error: AppCopy.authSendFailed);
      return false;
    }
    state = state.copyWith(
      sending: false,
      email: address,
      step: AuthStep.linkSent,
    );
    _startCountdown();
    return true;
  }

  Future<void> resendLink() async {
    if (state.secondsLeft > 0) return;
    await sendLink(state.email);
  }

  /// Placeholder: Google sign-in is not wired to Supabase yet.
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

  Future<void> signOut() async {
    _timer?.cancel();
    try {
      await ref.read(authGatewayProvider).signOut();
    } catch (_) {
      // Local state is cleared either way.
    }
    state = const AuthState();
  }

  String _friendly(sb.AuthException e) {
    final code = e.code ?? '';
    if (code.contains('rate_limit') || e.statusCode == '429') {
      return AppCopy.authRateLimited;
    }
    return AppCopy.authSendFailed;
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
