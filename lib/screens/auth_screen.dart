import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/content/app_copy.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/button_style.dart';
import '../providers/providers.dart';
import '../widgets/explore/billboard_motif.dart';

/// First screen of the app. Email + 6-digit code, or Google. Auth is
/// not wired to a backend yet: any well-formed email and any 6 digits
/// proceed to the home shell.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  static const int _codeLength = AuthNotifier.codeLength;

  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  final _codeController = TextEditingController();
  final _codeFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    _codeController.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  // Signing in flips authProvider.signedIn, and LayoqApp swaps this
  // screen for the home shell — no manual navigation needed.
  void _sendCode() {
    if (ref.read(authProvider.notifier).sendCode(_emailController.text)) {
      HapticFeedback.selectionClick();
      _codeController.clear();
      _codeFocus.requestFocus();
    }
  }

  void _verify() {
    if (ref.read(authProvider.notifier).verify(_codeController.text)) {
      HapticFeedback.mediumImpact();
    }
  }

  void _google() {
    HapticFeedback.mediumImpact();
    ref.read(authProvider.notifier).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final step = ref.watch(authProvider.select((s) => s.step));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            const Expanded(flex: 4, child: _BillboardHero()),
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: step == AuthStep.email
                          ? _buildEmail()
                          : _buildOtp(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmail() {
    final error = ref.watch(authProvider.select((s) => s.error));
    return Column(
      key: const ValueKey('email'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppCopy.authEmailLabel, style: AppTextStyles.labelLarge),
        const SizedBox(height: 8),
        _fieldShell(
          hasError: error != null,
          child: TextField(
            controller: _emailController,
            focusNode: _emailFocus,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _sendCode(),
            onChanged: (_) => ref.read(authProvider.notifier).clearError(),
            style: AppTextStyles.bodyLarge,
            cursorColor: AppColors.primary,
            decoration: _inputDecoration(AppCopy.authEmailHint),
          ),
        ),
        _errorText(),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _sendCode,
          style: AppButtonStyle.primary(fullWidth: true),
          child: const Text(AppCopy.authSendCode),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.hairline)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(AppCopy.authOr, style: AppTextStyles.bodySmall),
            ),
            const Expanded(child: Divider(color: AppColors.hairline)),
          ],
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: _google,
          style: AppButtonStyle.secondary(fullWidth: true).copyWith(
            side: const WidgetStatePropertyAll(
              BorderSide(color: AppColors.hairline, width: 1.5),
            ),
            foregroundColor: const WidgetStatePropertyAll(
              AppColors.primaryDark,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'G',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                AppCopy.authGoogle,
                style: AppButtonStyle.labelStyle.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            AppCopy.authTerms,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildOtp() {
    final auth = ref.watch(authProvider);
    return Column(
      key: const ValueKey('otp'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppCopy.authOtpTitle, style: AppTextStyles.h2),
        const SizedBox(height: 6),
        Text(AppCopy.authOtpBody(auth.email), style: AppTextStyles.bodyMedium),
        const SizedBox(height: 20),
        _CodeBoxes(
          controller: _codeController,
          focusNode: _codeFocus,
          length: _codeLength,
          hasError: auth.error != null,
          onChanged: () {
            ref.read(authProvider.notifier).clearError();
            if (_codeController.text.length == _codeLength) _verify();
          },
        ),
        _errorText(),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _verify,
          style: AppButtonStyle.primary(fullWidth: true),
          child: const Text(AppCopy.authVerify),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: ref.read(authProvider.notifier).backToEmail,
              child: const Text(AppCopy.authChangeEmail),
            ),
            TextButton(
              onPressed: auth.secondsLeft > 0
                  ? null
                  : ref.read(authProvider.notifier).resendCode,
              child: Text(
                auth.secondsLeft > 0
                    ? AppCopy.authResendIn(auth.secondsLeft)
                    : AppCopy.authResend,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _errorText() {
    final error = ref.watch(authProvider.select((s) => s.error));
    if (error == null) return const SizedBox(height: 0);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        error,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      ),
    );
  }

  /// White field with a hairline border — never a tinted fill.
  Widget _fieldShell({required Widget child, bool hasError = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasError ? AppColors.error : AppColors.hairline,
        ),
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      filled: false,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }
}

/// Top panel: the headline is set like a billboard face, with the
/// billboard motif standing behind it.
class _BillboardHero extends StatelessWidget {
  const _BillboardHero();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          right: -24,
          top: 40,
          child: Opacity(opacity: 0.16, child: BillboardMotif(size: 190)),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Layoq',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  AppCopy.authHeadline,
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontSize: 34,
                    height: 1.08,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Six visual boxes driven by one invisible text field, so paste,
/// autofill and backspace all behave natively.
class _CodeBoxes extends StatelessWidget {
  const _CodeBoxes({
    required this.controller,
    required this.focusNode,
    required this.length,
    required this.onChanged,
    this.hasError = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final int length;
  final VoidCallback onChanged;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: focusNode.requestFocus,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Opacity(
            opacity: 0,
            child: SizedBox(
              height: 56,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                maxLength: length,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => onChanged(),
                enableInteractiveSelection: false,
                decoration: const InputDecoration(counterText: ''),
              ),
            ),
          ),
          IgnorePointer(
            child: ListenableBuilder(
              listenable: Listenable.merge([controller, focusNode]),
              builder: (context, _) {
                final text = controller.text;
                return Row(
                  children: [
                    for (var i = 0; i < length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Expanded(
                        child: _box(
                          i < text.length ? text[i] : '',
                          active:
                              focusNode.hasFocus &&
                              i == text.length.clamp(0, length - 1),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _box(String digit, {required bool active}) {
    final color = hasError
        ? AppColors.error
        : active
        ? AppColors.primary
        : AppColors.hairline;
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: active ? 1.5 : 1),
      ),
      child: Text(digit, style: AppTextStyles.h2),
    );
  }
}
