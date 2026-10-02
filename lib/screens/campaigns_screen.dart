import 'package:flutter/material.dart';

import '../core/content/app_copy.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/icon_style.dart';

/// Campaigns tab: tracks the advertiser's booking requests across
/// Pending / Upcoming / Active / Completed. No booking data layer
/// exists yet, so every status shows the same empty state.
class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

enum _CampaignStatus { pending, upcoming, active, completed }

class _CampaignsScreenState extends State<CampaignsScreen> {
  _CampaignStatus _selected = _CampaignStatus.pending;

  static const Map<_CampaignStatus, String> _labels = {
    _CampaignStatus.pending: AppCopy.campaignStatusPending,
    _CampaignStatus.upcoming: AppCopy.campaignStatusUpcoming,
    _CampaignStatus.active: AppCopy.campaignStatusActive,
    _CampaignStatus.completed: AppCopy.campaignStatusCompleted,
  };

  @override
  Widget build(BuildContext context) {
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
              itemCount: _CampaignStatus.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final status = _CampaignStatus.values[index];
                final selected = status == _selected;
                return ChoiceChip(
                  label: Text(_labels[status]!),
                  selected: selected,
                  onSelected: (_) => setState(() => _selected = status),
                  labelStyle: AppTextStyles.labelMedium.copyWith(
                    color: selected ? Colors.white : AppColors.primaryDark,
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
                      _labels[_selected]!.toLowerCase(),
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
