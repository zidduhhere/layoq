import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/content/app_copy.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/icon_style.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Back Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 22,
                        color: AppColors.primaryDark,
                      ),
                      padding: const EdgeInsets.all(12),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      AppCopy.notificationsTitle,
                      style: AppTextStyles.h1,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Notifications List
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _NotificationItem(
                      icon: Icons.campaign_rounded,
                      iconColor: AppColors.success,
                      title: 'Campaign Approved',
                      message: 'Your booking for "MG Road Digital" has been approved and is scheduled.',
                      time: '2h ago',
                      isUnread: true,
                    ),
                    SizedBox(height: 16),
                    _NotificationItem(
                      icon: Icons.receipt_long_rounded,
                      iconColor: AppColors.blue,
                      title: 'Invoice Available',
                      message:
                          'Invoice #INV-2451 is ready for your recent booking.',
                      time: '1d ago',
                      isUnread: true,
                    ),
                    SizedBox(height: 16),
                    _NotificationItem(
                      icon: Icons.error_outline_rounded,
                      iconColor: AppColors.warning,
                      title: 'Payment Pending',
                      message: 'Please complete the payment to secure your billboard on NH Bypass.',
                      time: '3d ago',
                      isUnread: false,
                    ),
                    SizedBox(height: 16),
                    _NotificationItem(
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: AppColors.primaryDark,
                      title: 'Campaign Completed',
                      message: 'Your campaign "Onam Special" has successfully concluded.',
                      time: '1w ago',
                      isUnread: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.time,
    required this.isUnread,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String time;
  final bool isUnread;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isUnread
            ? AppColors.fieldFill.withValues(alpha: 0.3)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: Icon(icon, size: AppIconSize.md, color: iconColor),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: isUnread
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isUnread
                              ? AppColors.primaryDark
                              : AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        time,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
