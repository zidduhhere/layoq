import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/content/app_copy.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/icon_style.dart';

/// The four top-level sections of the app.
enum AppTab { explore, wishlist, campaigns, profile }

/// Shared bottom navigation bar for Explore, Wishlist, Campaigns, and
/// Profile. Icons are chosen to read literally against each tab's name.
/// Redesigned as an elevated, glassmorphism pill with elegant hover/expand
/// transition animations following ui-ux-pro-max guidelines.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentTab, this.onTabSelected});

  final AppTab currentTab;
  final ValueChanged<AppTab>? onTabSelected;

  static const List<_NavItemData> _items = [
    _NavItemData(
      tab: AppTab.explore,
      icon: Icons.explore_rounded,
      label: AppCopy.navExplore,
    ),
    _NavItemData(
      tab: AppTab.wishlist,
      icon: Icons.favorite_rounded,
      label: AppCopy.navWishlist,
    ),
    _NavItemData(
      tab: AppTab.campaigns,
      icon: Icons.campaign_rounded,
      label: AppCopy.navCampaigns,
    ),
    _NavItemData(
      tab: AppTab.profile,
      icon: Icons.person_rounded,
      label: AppCopy.navProfile,
    ),
  ];

  double _getTextWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w700),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }

  double _getTargetWidth(int index, int selectedIndex) {
    if (index == selectedIndex) {
      return 16.0 + 24.0 + 8.0 + _getTextWidth(_items[index].label) + 16.0;
    }
    return 12.0 + 24.0 + 12.0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _items.indexWhere((item) => item.tab == currentTab);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 24 + MediaQuery.of(context).padding.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(100),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  double totalItemsWidth = 0;
                  for (int i = 0; i < 4; i++) {
                    totalItemsWidth += _getTargetWidth(i, selectedIndex);
                  }
                  final gap = (w - totalItemsWidth) / 3.0;

                  double leftOffset = 0;
                  for (int i = 0; i < selectedIndex; i++) {
                    leftOffset += _getTargetWidth(i, selectedIndex) + gap;
                  }
                  final selectedWidth =
                      _getTargetWidth(selectedIndex, selectedIndex);

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutQuint,
                        left: leftOffset,
                        width: selectedWidth,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (final item in _items)
                            _NavItem(
                              data: item,
                              selected: item.tab == currentTab,
                              onTap: onTabSelected == null
                                  ? null
                                  : () {
                                      if (item.tab != currentTab) {
                                        HapticFeedback.mediumImpact();
                                        onTabSelected!(item.tab);
                                      }
                                    },
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.tab,
    required this.icon,
    required this.label,
  });

  final AppTab tab;
  final IconData icon;
  final String label;
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.data, required this.selected, this.onTap});

  final _NavItemData data;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppIconColor.light : AppIconColor.muted;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(data.icon, color: color, size: AppIconSize.lg),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuint,
              child: selected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          data.label,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
