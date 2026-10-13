import 'package:flutter/material.dart';

import '../../core/content/app_copy.dart';
import '../../core/theme/app_text_styles.dart';

class RecentlyViewedSection extends StatelessWidget {
  const RecentlyViewedSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder structure for when browsing history exists.
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppCopy.recentlyViewedTitle, style: AppTextStyles.h3),
        SizedBox(height: 12),
        SizedBox(height: 96),
      ],
    );
  }
}
