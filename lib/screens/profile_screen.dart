import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/content/app_copy.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/icon_style.dart';
import '../providers/providers.dart';
import '../widgets/app_bottom_nav.dart';
import 'notifications_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(authProvider.select((s) => s.email));
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 20, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Profile', style: AppTextStyles.h1),
                IconButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(authProvider.notifier).signOut();
                    ref
                        .read(currentTabProvider.notifier)
                        .select(AppTab.explore);
                  },
                  icon: const Icon(Icons.logout_rounded),
                  color: AppColors.error,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // Avatar Area
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.fieldFill,
                  border: Border.all(color: AppColors.hairline, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person_rounded,
                    size: 48,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              Positioned(
                bottom: -12,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.hairline),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.edit_outlined,
                          size: 12,
                          color: AppColors.blue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Edit',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.blue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // User Info
          Text(
            email.isEmpty ? 'Signed in with Google' : email,
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 4),
          Text(
            'Kochi advertiser',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 48),

          // Settings Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Settings', style: AppTextStyles.h3),
            ),
          ),
          const SizedBox(height: 16),

          // Settings List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.hairline),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  children: [
                    _SettingsItem(
                      icon: Icons.business_rounded,
                      label: AppCopy.menuMyBusiness,
                    ),
                    _SettingsItem(
                      icon: Icons.notifications_none_rounded,
                      label: 'Notifications',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    _SettingsItem(
                      icon: Icons.help_outline_rounded,
                      label: AppCopy.menuHelp,
                    ),
                    _SettingsItem(
                      icon: Icons.description_outlined,
                      label: AppCopy.menuTerms,
                    ),
                    _SettingsItem(
                      icon: Icons.info_outline_rounded,
                      label: AppCopy.menuAbout,
                      showBorder: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.label,
    this.showBorder = true,
    this.onTap,
  }) : trailingText = null;

  final IconData icon;
  final String label;
  final String? trailingText;
  final bool showBorder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        if (onTap != null) onTap!();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: showBorder
              ? const Border(bottom: BorderSide(color: AppColors.hairline))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.hairline),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: AppIconSize.md,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              size: AppIconSize.md,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
