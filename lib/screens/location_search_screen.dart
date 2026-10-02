import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/icon_style.dart';
import '../data/mock_listings.dart';

/// A centered dialog with a flawless Container Transform animation.
/// It identically matches the SearchCard's location row aesthetic at the top,
/// seamlessly expanding into a full search menu.
class LocationSearchDialog extends StatefulWidget {
  const LocationSearchDialog({super.key});

  @override
  State<LocationSearchDialog> createState() => _LocationSearchDialogState();
}

class _LocationSearchDialogState extends State<LocationSearchDialog> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto focus the text field seamlessly after the Hero flight finishes
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Hero(
        tag: 'search_location',
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // Match SearchCard corner radius perfectly
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 460),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Search Field mirroring `_SearchRow` in `SearchCard` exactly
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: AppIconSize.md,
                        color: AppIconColor.muted,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: AppTextStyles.bodyLarge,
                          decoration: InputDecoration(
                            hintText: 'Search location...',
                            hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.hairline, height: 1, thickness: 1),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: mockListings.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: AppColors.hairline,
                      height: 1,
                      thickness: 1,
                      indent: 56, // 16 (padding) + 24 (icon) + 16 (gap)
                    ),
                    itemBuilder: (context, index) {
                      final listing = mockListings[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pop(listing.area);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: AppColors.textMuted,
                                size: AppIconSize.md,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listing.area,
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      listing.landmark,
                                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
