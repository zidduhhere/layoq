import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/content/app_copy.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/icon_style.dart';
import '../../models/billboard_listing.dart';
import 'billboard_motif.dart';

class AvailableSpacesRow extends StatelessWidget {
  const AvailableSpacesRow({required this.listings, required this.onTap, super.key});

  final List<BillboardListing> listings;
  final ValueChanged<BillboardListing> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290,
      child: ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        itemCount: listings.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) => _ListingCard(
          listing: listings[index],
          tintIndex: index,
          onTap: () => onTap(listings[index]),
        ),
      ),
    );
  }
}

/// Low-opacity brand tints cycled across cards so the row has a little
/// visual rhythm instead of identical grey placeholders.
const List<Color> _cardTints = [
  AppColors.primary,
  AppColors.blue,
  AppColors.yellow,
];

class _ListingCard extends StatelessWidget {
  const _ListingCard({
    required this.listing,
    required this.tintIndex,
    required this.onTap,
  });

  final BillboardListing listing;
  final int tintIndex;
  final VoidCallback onTap;

  String get _formattedPrice {
    final digits = listing.pricePerMonth.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final fromEnd = digits.length - i;
      if (i != 0 && fromEnd % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return '₹$buffer';
  }

  @override
  Widget build(BuildContext context) {
    final tint = _cardTints[tintIndex % _cardTints.length];

    return Container(
      width: 172,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 116,
                  width: double.infinity,
                  color: tint.withValues(alpha: 0.10),
                  child: Center(
                    child: Opacity(
                      opacity: 0.6,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
                        child: const BillboardMotif(size: 56),
                      ),
                    ),
                  ),
                ),
                if (listing.illuminated)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            size: AppIconSize.xs,
                            color: AppIconColor.accent,
                          ),
                          SizedBox(width: 4),
                          Text(
                            AppCopy.illuminatedBadge,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.area,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            listing.landmark,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.fieldFill,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        listing.sizeLabel,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: _formattedPrice,
                            style: AppTextStyles.h3.copyWith(
                              fontSize: 17,
                              color: AppColors.primary,
                            ),
                          ),
                          const TextSpan(
                            text: AppCopy.perMonthSuffix,
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
