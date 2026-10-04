import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/content/app_copy.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/icon_style.dart';
import '../models/booking_request.dart';
import '../providers/providers.dart';

/// Campaigns tab: tracks the advertiser's booking requests across
/// Pending / Upcoming / Active / Completed, read from
/// [campaignsProvider] and filtered by [campaignTabProvider].
class CampaignsScreen extends ConsumerWidget {
  const CampaignsScreen({super.key});

  static const Map<CampaignStatus, String> _labels = {
    CampaignStatus.pending: AppCopy.campaignStatusPending,
    CampaignStatus.upcoming: AppCopy.campaignStatusUpcoming,
    CampaignStatus.active: AppCopy.campaignStatusActive,
    CampaignStatus.completed: AppCopy.campaignStatusCompleted,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(campaignTabProvider);
    final requests = ref.watch(visibleCampaignsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(AppCopy.campaignsTitle, style: AppTextStyles.h1),
          const SizedBox(height: 4),
          const Text(
            AppCopy.campaignsSubtitle,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: CampaignStatus.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final status = CampaignStatus.values[index];
                final isSelected = status == selected;
                return ChoiceChip(
                  label: Text(_labels[status]!),
                  selected: isSelected,
                  onSelected: (_) =>
                      ref.read(campaignTabProvider.notifier).select(status),
                  labelStyle: AppTextStyles.labelMedium.copyWith(
                    color: isSelected ? Colors.white : AppColors.primaryDark,
                  ),
                  backgroundColor: AppColors.fieldFill,
                  selectedColor: AppColors.primary,
                  showCheckmark: false,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                );
              },
            ),
          ),
          if (requests.isNotEmpty)
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 16, bottom: 120),
                itemCount: requests.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _RequestTile(request: requests[i]),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: AppColors.fieldFill,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.campaign_rounded,
                        size: AppIconSize.xl,
                        color: AppIconColor.muted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppCopy.campaignsEmptyTitle(
                        _labels[selected]!.toLowerCase(),
                      ),
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      AppCopy.campaignsEmptyBody,
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
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

class _RequestTile extends StatelessWidget {
  const _RequestTile({required this.request});

  final BookingRequest request;

  static const _months = [
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

  String _fmt(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    final dates = request.start == null || request.end == null
        ? 'Dates not set'
        : '${_fmt(request.start!)} – ${_fmt(request.end!)}';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(request.listing.area, style: AppTextStyles.h3),
          const SizedBox(height: 2),
          Text(request.listing.landmark, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 10),
          Text(dates, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}
