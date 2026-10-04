import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/content/app_copy.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/button_style.dart';
import '../models/billboard_listing.dart';
import '../providers/providers.dart';
import '../widgets/explore/ad_space_types.dart';
import '../widgets/explore/available_spaces.dart';
import '../widgets/explore/search_card.dart';
import 'date_search_screen.dart';
import 'listing_detail_screen.dart';
import 'notifications_screen.dart';
import 'search_results_screen.dart';

/// Explore / home screen — the advertiser's entry point into Layoq.
///
/// Scope for this iteration:
/// - Greeting on the plain page background
/// - A floating search card: area search, campaign date range, CTA
/// - Available spaces in Kochi (horizontal scroll, mock data)
/// - A single restrained secondary action for first-time users
///   ("Browse all billboard spaces in Kochi"); recently viewed listings
///   replace it once browsing history exists.
///
/// "Search by type" is intentionally omitted — V1 supports static
/// billboards only, so a type picker would set expectations Layoq
/// can't meet yet.
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  Future<void> _pickCampaignDates() async {
    // final now = DateTime.now();
    final picked = await Navigator.of(context).push<DateTimeRange>(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, _, _) {
          return const DateSearchDialog();
        },
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    if (picked != null) {
      ref.read(searchFilterProvider.notifier).setDates(picked);
    }
  }

  String _formatRange(DateTimeRange range) {
    final start = range.start;
    final end = range.end;
    final startMonth = _months[start.month - 1];
    final endMonth = _months[end.month - 1];

    if (start.year == end.year && start.month == end.month) {
      return '${start.day}–${end.day} $startMonth ${start.year}';
    }
    if (start.year == end.year) {
      return '${start.day} $startMonth – ${end.day} $endMonth ${start.year}';
    }
    return '${start.day} $startMonth ${start.year} – '
        '${end.day} $endMonth ${end.year}';
  }

  void _handleSearch() {
    HapticFeedback.selectionClick();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const SearchResultsScreen()));
  }

  void _handleBrowseAll() {
    ref.read(searchFilterProvider.notifier).setArea('');
    _handleSearch();
  }

  void _openListing(BillboardListing listing) {
    ref.read(recentlyViewedIdsProvider.notifier).add(listing.id);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: listing)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dates = ref.watch(searchFilterProvider.select((f) => f.dates));
    final listings = ref.watch(listingsProvider);
    final recent = ref.watch(recentlyViewedProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 20, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppCopy.exploreGreeting,
                          style: AppTextStyles.h1,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          AppCopy.exploreSubtitle,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                    AppIconButton(
                      icon: Icons.notifications_none_rounded,
                      showBadge: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SearchCard(
                  dateLabel: dates == null ? null : _formatRange(dates),
                  onPickDates: _pickCampaignDates,
                  onSearch: _handleSearch,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          const AdSpaceTypesRow(),
          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: GestureDetector(
                onTap: _handleBrowseAll,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Relevant Spaces', style: AppTextStyles.h3),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AvailableSpacesRow(listings: listings, onTap: _openListing),
          const SizedBox(height: 32),

          if (recent.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recently Checked Space', style: AppTextStyles.h3),
                    SizedBox(height: 4),
                    Text(
                      'Pick up right where you left off',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            AvailableSpacesRow(listings: recent, onTap: _openListing),
          ],
          const SizedBox(height: 120), // Padding for the floating pill navbar
        ],
      ),
    );
  }
}
