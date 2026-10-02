import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import '../core/content/app_copy.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/button_style.dart';

/// Wishlist tab: saved listings. Saving a listing requires OTP sign-in,
/// which doesn't exist yet, so this shows the first-time empty state —
/// replace with a saved-listings grid once auth and persistence exist.
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 20, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(AppCopy.wishlistTitle, style: AppTextStyles.h1),
                const SizedBox(height: 6),
                Text(
                  AppCopy.wishlistSubtitle,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppCopy.wishlistEmptyTitle,
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppCopy.wishlistEmptyBody,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      // TODO: Navigate to explore tab
                    },
                    style: AppButtonStyle.primary(
                      shape: AppButtonShape.rounded,
                      fullWidth: true,
                    ),
                    child: const Text('Find your first space'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
