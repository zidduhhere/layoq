import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/content/app_copy.dart';
import '../models/billboard_listing.dart';
import '../widgets/map/stylized_map.dart';
import '../providers/providers.dart';
import 'listing_detail_screen.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  late final PageController _pageController;

  // Arbitrary fixed offsets for our mock listings to spread them out on the map.
  // The first point is the origin (center).
  final List<Offset> _fixedOffsets = const [
    Offset(0, 0),
    Offset(200, 150),
    Offset(-180, 120),
    Offset(250, -100),
    Offset(-120, -150),
    Offset(50, -250),
  ];

  @override
  void initState() {
    super.initState();
    // viewportFraction gives a peek of the next/previous cards
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listings = ref.watch(searchResultsProvider);
    final area = ref.watch(searchFilterProvider.select((f) => f.area));
    final selectedIndex = ref.watch(selectedResultIndexProvider);
    // Get the target offset based on the selected index.
    // If there are more mock listings than our fixed offsets, loop back.
    final targetOffset = _fixedOffsets[selectedIndex % _fixedOffsets.length];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // The Panning Map Layer
          AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutQuint,
            transform: Matrix4.translationValues(
              -targetOffset.dx,
              -targetOffset.dy,
              0,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // The Minimalist Map Background. We make it oversized so panning doesn't reveal edges.
                Positioned(
                  top: -2000,
                  bottom: -2000,
                  left: -2000,
                  right: -2000,
                  child: const StylizedMap(),
                ),

                // Markers
                ...List.generate(listings.length, (index) {
                  final offset = _fixedOffsets[index % _fixedOffsets.length];
                  return Positioned(
                    // We position the marker such that an offset of (0,0) places it in the center of the screen
                    top:
                        (screenHeight / 2) +
                        offset.dy -
                        100, // Shifted up slightly to accommodate the carousel
                    left: (screenWidth / 2) + offset.dx - 40,
                    child: _MapMarker(
                      listing: listings[index],
                      isSelected: index == selectedIndex,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutQuint,
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          // Header (Back button + Search Context)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.hairline),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 22,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: AppColors.hairline),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search_rounded,
                              size: 18,
                              color: AppColors.primaryDark,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              area.isEmpty ? 'All of Kochi' : area,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 1,
                              height: 16,
                              color: AppColors.hairline,
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.tune_rounded,
                              size: 18,
                              color: AppColors.primaryDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors.hairline),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    AppCopy.searchResultsCount(listings.length),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Carousel of Listings
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 260,
              child: PageView.builder(
                controller: _pageController,
                clipBehavior: Clip.none,
                itemCount: listings.length,
                onPageChanged: (index) {
                  HapticFeedback.selectionClick();
                  ref.read(selectedResultIndexProvider.notifier).select(index);
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _MapListingCard(
                      listing: listings[index],
                      isSelected: index == selectedIndex,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({
    required this.listing,
    required this.isSelected,
    required this.onTap,
  });

  final BillboardListing listing;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
            bottomLeft: Radius.circular(0),
          ),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.hairline,
            width: isSelected ? 0 : 1.5,
          ),
        ),
        child: Text(
          '₹${(listing.pricePerMonth / 1000).toStringAsFixed(0)}k',
          style: AppTextStyles.labelSmall.copyWith(
            color: isSelected ? Colors.white : AppColors.primaryDark,
            fontWeight: FontWeight.w800,
            fontSize: 14,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}

class _MapListingCard extends ConsumerWidget {
  const _MapListingCard({required this.listing, required this.isSelected});

  final BillboardListing listing;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuint,
      // Scale down slightly if not selected
      transform: Matrix4.identity()..scale(isSelected ? 1.0 : 0.95),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isSelected ? 0.12 : 0.05),
            blurRadius: isSelected ? 32 : 16,
            offset: Offset(0, isSelected ? 16 : 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            ref.read(recentlyViewedIdsProvider.notifier).add(listing.id);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ListingDetailScreen(listing: listing),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                width: double.infinity,
                color: AppColors.primary.withValues(alpha: 0.04),
                child: const Center(
                  child: Opacity(
                    opacity: 0.4,
                    child: Icon(
                      Icons.aspect_ratio_rounded,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.area,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        listing.landmark,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.directions_car_rounded,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            listing.dailyTraffic,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            listing.illuminated
                                ? Icons.lightbulb_rounded
                                : Icons.lightbulb_outline_rounded,
                            size: 14,
                            color: listing.illuminated
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            listing.illuminated ? 'Lit' : 'Unlit',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: listing.illuminated
                                  ? AppColors.primaryDark
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.layers_rounded,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            listing.materialType,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.calendar_month_rounded,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            listing.minBookingDuration,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.fieldFill,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              listing.sizeLabel,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${(listing.pricePerMonth / 1000).toStringAsFixed(0)}k',
                                style: AppTextStyles.h2.copyWith(
                                  color: AppColors.primaryDark,
                                  height: 1,
                                  letterSpacing: -1,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text(
                                  '/mo',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
