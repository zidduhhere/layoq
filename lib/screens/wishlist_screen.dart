import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/content/app_copy.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/button_style.dart';
import '../models/billboard_listing.dart';
import '../providers/providers.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/explore/available_spaces.dart';
import 'listing_detail_screen.dart';

/// Wishlist tab: listings saved via [wishlistProvider], or the
/// first-time empty state when nothing is saved.
class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(wishlistProvider);
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
          if (saved.isNotEmpty)
            AvailableSpacesRow(
              listings: saved,
              onTap: (BillboardListing l) => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ListingDetailScreen(listing: l),
                ),
              ),
            )
          else
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
                        ref
                            .read(currentTabProvider.notifier)
                            .select(AppTab.explore);
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
