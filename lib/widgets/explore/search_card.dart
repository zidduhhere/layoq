import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/content/app_copy.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/button_style.dart';
import '../../core/theme/icon_style.dart';
import '../../screens/location_search_screen.dart';

/// The search card's job is to feel like one object, not a stack of
/// form fields: area and dates live as two rows of a single tinted
/// surface, split by one inset hairline instead of a border each.
/// The primary action sits below that surface as a left-aligned pill
/// button — not overlapping it, so it can never cover either row's
/// content regardless of text metrics.
class SearchCard extends StatelessWidget {
  const SearchCard({
    required this.areaController,
    required this.campaignDates,
    required this.dateLabel,
    required this.onPickDates,
    required this.onSearch,
    super.key,
  });

  final TextEditingController areaController;
  final DateTimeRange? campaignDates;
  final String? dateLabel;
  final VoidCallback onPickDates;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.hairline),
            ),
            child: Column(
              children: [
                Semantics(
                  button: true,
                  label: AppCopy.searchCardTitle,
                  child: Hero(
                    tag: 'search_location',
                    child: Material(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _SearchRow(
                        icon: Icons.location_on_rounded,
                        onTap: () async {
                          final result = await Navigator.of(context)
                              .push<String>(
                                PageRouteBuilder(
                                  opaque: false, // Ensures the background from the previous screen is visible
                                  barrierDismissible:
                                      true, // Allows tapping outside to close
                                  barrierColor: Colors.black.withValues(
                                    alpha: 0.5,
                                  ), // Dim the background
                                  transitionDuration: const Duration(
                                    milliseconds: 350,
                                  ),
                                  pageBuilder: (_, _, _) =>
                                      const LocationSearchDialog(),
                                  transitionsBuilder:
                                      (_, animation, _, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                ),
                              );
                          if (result != null) {
                            areaController.text = result;
                          }
                        },
                        // We use a Builder to access the controller's text if needed,
                        // but since SearchCard is stateless we can use ValueListenableBuilder
                        child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: areaController,
                          builder: (context, value, child) {
                            return Text(
                              value.text.isEmpty
                                  ? AppCopy.searchHint
                                  : value.text,
                              style: value.text.isEmpty
                                  ? AppTextStyles.bodyLarge.copyWith(
                                      color: AppColors.textMuted,
                                    )
                                  : AppTextStyles.bodyLarge,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 52),
                  child: Divider(
                    color: AppColors.hairline,
                    height: 1,
                    thickness: 1,
                  ),
                ),
                Semantics(
                  button: true,
                  label: AppCopy.campaignDatesLabel,
                  child: Hero(
                    tag: 'search_dates',
                    child: Material(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _SearchRow(
                        icon: Icons.calendar_today_rounded,
                        onTap: onPickDates,
                        child: Text(
                          dateLabel ?? AppCopy.addDatesPlaceholder,
                          style: dateLabel == null
                              ? AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textMuted,
                                )
                              : AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SearchButton(onTap: onSearch),
        ],
      ),
    );
  }
}

/// One row of the merged search surface: a muted leading icon and
/// whatever content the row needs (a text field, or a label to tap).
class _SearchRow extends StatelessWidget {
  const _SearchRow({required this.icon, required this.child, this.onTap});

  final IconData icon;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          Icon(icon, size: AppIconSize.md, color: AppIconColor.muted),
          const SizedBox(width: 16),
          Expanded(child: child),
        ],
      ),
    );
    if (onTap == null) return row;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        HapticFeedback.selectionClick();
        onTap!();
      },
      child: row,
    );
  }
}

/// The card's one bold move: a solid-purple rectangular action
/// breaking out of the tinted surface's bottom-left corner, instead
/// of a flat full-width button underneath it. Flat, no shadow — like
/// every button in the app.
class _SearchButton extends StatelessWidget {
  const _SearchButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      style: AppButtonStyle.primary(
        shape: AppButtonShape.rounded,
        fullWidth: true,
      ),
      child: const Text(
        AppCopy.searchButton,
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
