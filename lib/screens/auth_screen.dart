import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/content/app_copy.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/button_style.dart';
import '../providers/providers.dart';
import '../widgets/explore/billboard_motif.dart';
import 'root_shell.dart';

/// First screen of the app. Email magic link (Supabase), or Google.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  // Signing in happens when the user taps the emailed link and the app
  // reopens: the session stream flips authProvider.signedIn and
  // LayoqApp swaps this screen for the home shell.
  Future<void> _sendLink() async {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RootShell()),
    );
  }

  void _google() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RootShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final step = ref.watch(authProvider.select((s) => s.step));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        // White, not primary: whatever sits behind the keyboard (and its
        // rounded corners) is the scaffold colour. Primary is painted
        // only behind the hero and the sheet's top corners below.
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            const Expanded(
              flex: 4,
              child: ColoredBox(
                color: AppColors.primary,
                child: _BillboardHero(),
              ),
            ),
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 28,
                    child: ColoredBox(color: AppColors.primary),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: step == AuthStep.email
                              ? _buildEmail()
                              : _buildLinkSent(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmail() {
    final error = ref.watch(authProvider.select((s) => s.error));
    final sending = ref.watch(authProvider.select((s) => s.sending));
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
            keyboardAppearance: Brightness.light,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _sendLink(),
            onChanged: (_) => ref.read(authProvider.notifier).clearError(),
            style: AppTextStyles.bodyLarge,
            cursorColor: AppColors.primary,
            decoration: _inputDecoration(AppCopy.authEmailHint),
          ),
        ),
        _errorText(),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: sending ? null : _sendLink,
          style: AppButtonStyle.primary(fullWidth: true),
          child: sending
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : const Text(AppCopy.authSendCode),
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

  Widget _buildLinkSent() {
    final auth = ref.watch(authProvider);
    return Column(
      key: const ValueKey('linkSent'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppCopy.authLinkTitle, style: AppTextStyles.h2),
        const SizedBox(height: 6),
        Text(AppCopy.authLinkBody(auth.email), style: AppTextStyles.bodyMedium),
        _errorText(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: ref.read(authProvider.notifier).backToEmail,
              child: const Text(AppCopy.authChangeEmail),
            ),
            TextButton(
              onPressed: auth.secondsLeft > 0 || auth.sending
                  ? null
                  : ref.read(authProvider.notifier).resendLink,
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
