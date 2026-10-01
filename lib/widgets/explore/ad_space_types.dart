import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import '../../core/theme/button_style.dart';

/// A horizontal scrollable row of buttons that navigate to
/// category-specific listing pages.
class AdSpaceTypesRow extends StatelessWidget {
  const AdSpaceTypesRow({super.key});

  static const List<String> _types = [
    'Static Billboards',
    'Digital Displays',
    'Transit Media',
    'Retail Screens',
    'Street Furniture',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _types.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final type = _types[index];

          return ElevatedButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              // TODO: Navigate to the filtered category view
            },
            style: AppButtonStyle.chip(),
            child: Text(type),
          );
        },
      ),
    );
  }
}
