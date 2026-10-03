import 'package:flutter/material.dart';

import '../core/content/app_copy.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/button_style.dart';
import '../core/theme/icon_style.dart';
import '../models/billboard_listing.dart';
import '../widgets/map/stylized_map.dart';

/// Product page for a single billboard listing: photos, location, size,
/// illumination, price, and availability, with actions to save it or
/// submit a booking request.
///
/// Save / Request to book are stubbed with TODOs — both require OTP
/// sign-in and a booking data layer that don't exist yet.
class ListingDetailScreen extends StatelessWidget {
  const ListingDetailScreen({super.key, required this.listing});

  final BillboardListing listing;

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

  void _handleSave(BuildContext context) {
    // TODO: gate behind OTP sign-in, then add to wishlist.
  }

  void _handleRequestBooking(BuildContext context) {
    // TODO: gate behind OTP sign-in, then submit a booking request.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PhotoHeader(onBack: () => Navigator.of(context).pop()),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(listing.area, style: AppTextStyles.h2),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.place_rounded,
                                size: AppIconSize.sm,
                                color: AppIconColor.muted,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  listing.landmark,
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              _FactChip(
                                icon: Icons.straighten_rounded,
                                label: listing.sizeLabel,
                              ),
                              const SizedBox(width: 10),
                              _FactChip(
                                icon: listing.illuminated
                                    ? Icons.bolt_rounded
                                    : Icons.flash_off_rounded,
                                label: listing.illuminated
                                    ? AppCopy.illuminatedLabel
                                    : AppCopy.nonIlluminatedLabel,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(color: AppColors.hairline, height: 1),
                          const SizedBox(height: 32),
                          const Text('Key Details', style: AppTextStyles.h3),
                          const SizedBox(height: 16),
                          _DetailRow(
                              icon: Icons.visibility_rounded,
                              label: 'Estimated Traffic',
                              value: listing.dailyTraffic),
                          const SizedBox(height: 12),
                          _DetailRow(
                              icon: Icons.explore_outlined,
                              label: 'Orientation',
                              value: listing.orientation),
                          const SizedBox(height: 12),
                          _DetailRow(
                              icon: Icons.layers_outlined,
                              label: 'Material',
                              value: listing.materialType),
                          const SizedBox(height: 12),
                          _DetailRow(
                              icon: Icons.calendar_month_rounded,
                              label: 'Min. Booking',
                              value: listing.minBookingDuration),
                          const SizedBox(height: 12),
                          _DetailRow(
                              icon: Icons.gpp_maybe_outlined,
                              label: 'Restrictions',
                              value: listing.restrictions),
                          const SizedBox(height: 24),
                          const Divider(color: AppColors.hairline, height: 1),
                          const SizedBox(height: 24),
                          const Text(
                            AppCopy.aboutSpaceTitle,
                            style: AppTextStyles.h3,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppCopy.aboutSpaceBody(
                              landmark: listing.landmark,
                              sizeLabel: listing.sizeLabel,
                              illuminated: listing.illuminated,
                            ),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primaryDark,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Divider(color: AppColors.hairline, height: 1),
                          const SizedBox(height: 24),
                          const Text('Location', style: AppTextStyles.h3),
                          const SizedBox(height: 16),
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                const Positioned.fill(
                                  child: MiniMap(),
                                ),
                                Center(
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 3),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primary.withValues(alpha: 0.4),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on_rounded, size: 20, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  listing.landmark,
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _BottomActionBar(
              priceLabel: _formattedPrice,
              onSave: () => _handleSave(context),
              onRequestBooking: () => _handleRequestBooking(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tinted motif header standing in for listing photography until real
/// photo upload exists in the Admin Panel. Now implemented as a 
/// rounded carousel per the design request.
class _PhotoHeader extends StatefulWidget {
  const _PhotoHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  State<_PhotoHeader> createState() => _PhotoHeaderState();
}

class _PhotoHeaderState extends State<_PhotoHeader> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Stack(
        children: [
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.hairline),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _currentIndex = index),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      color: AppColors.primary.withValues(alpha: 0.04),
                      child: Center(
                        child: Opacity(
                          opacity: 0.4,
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
                            child: Transform.rotate(
                              angle: -0.08,
                              child: const Icon(
                                Icons.aspect_ratio_rounded,
                                size: AppIconSize.xxl,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? AppColors.primary
                              : AppColors.hairline,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child:
                AppIconButton(icon: Icons.arrow_back_ios_rounded, onTap: widget.onBack),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textMuted),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}



class _FactChip extends StatelessWidget {
  const _FactChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppIconSize.sm, color: AppIconColor.dark),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.priceLabel,
    required this.onSave,
    required this.onRequestBooking,
  });

  final String priceLabel;
  final VoidCallback onSave;
  final VoidCallback onRequestBooking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.hairline)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: priceLabel,
                    style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                  ),
                  const TextSpan(
                    text: AppCopy.perMonthSuffix,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          AppIconButton(icon: Icons.favorite_border_rounded, onTap: onSave),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: onRequestBooking,
            style: AppButtonStyle.primary(shape: AppButtonShape.rounded),
            child: const Text(AppCopy.requestToBookButton),
          ),
        ],
      ),
    );
  }
}
