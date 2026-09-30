import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'icon_style.dart';

/// The button shapes used across Layoq. Pill and rounded are both
/// fully rounded (stadium) today, kept as separate names so a future
/// design pass can split them again without touching call sites.
/// Rectangular is a true rectangle with a fixed corner radius.
enum AppButtonShape { pill, rounded, rectangular }

/// Flat button styles (no elevation, no shadow) with explicit
/// pressed/disabled states, for use as an [ElevatedButton.styleFrom]
/// or [OutlinedButton.styleFrom] replacement. Use [AppIconButton] for
/// icon-only buttons instead of these.
class AppButtonStyle {
  AppButtonStyle._();

  /// Space between an icon and its label inside a button — use this
  /// instead of ElevatedButton.icon's wider built-in gap when a
  /// button's content is a manually-built icon + label Row.
  static const double iconGap = 6;

  /// Button label style: the shared [AppTextStyles.button] sized up
  /// 1.2x (16 -> ~19) and pulled in slightly tighter so the larger
  /// text doesn't read as loosely tracked.
  static final TextStyle labelStyle = AppTextStyles.button.copyWith(
    fontSize: AppTextStyles.button.fontSize!,
    letterSpacing: -0.2,
  );

  /// Minimum width/height every button holds to, regardless of how
  /// short its label is — keeps small labels (e.g. "Search") from
  /// rendering as a cramped, barely-tappable pill.
  static const Size minimumSize = Size(140, 0);

  /// Corner radius for [AppButtonShape.rectangular].
  static const double rectangularRadius = 12;

  static OutlinedBorder _shape(AppButtonShape shape) {
    if (shape == AppButtonShape.rectangular) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rectangularRadius),
      );
    }
    return const StadiumBorder();
  }

  /// Solid primary button: brand-purple fill, white label, flat.
  static ButtonStyle primary({
    AppButtonShape shape = AppButtonShape.rounded,
    bool fullWidth = false,
  }) {
    return ButtonStyle(
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      ),
      minimumSize: WidgetStatePropertyAll(
        fullWidth ? const Size(double.infinity, 0) : minimumSize,
      ),
      shape: WidgetStatePropertyAll(_shape(shape)),
      textStyle: WidgetStatePropertyAll(labelStyle),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return AppColors.fieldFill;
        if (states.contains(WidgetState.pressed)) return AppColors.primaryDark;
        return AppColors.primary;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return AppColors.textMuted;
        return Colors.white;
      }),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }

  /// Outlined secondary button: transparent fill, primary-colored
  /// border and label, flat.
  static ButtonStyle secondary({
    AppButtonShape shape = AppButtonShape.rounded,
    bool fullWidth = false,
  }) {
    return ButtonStyle(
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return AppColors.fieldFill;
        }
        return Colors.transparent;
      }),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      minimumSize: WidgetStatePropertyAll(
        fullWidth ? const Size(double.infinity, 0) : minimumSize,
      ),
      shape: WidgetStatePropertyAll(_shape(shape)),
      textStyle: WidgetStatePropertyAll(labelStyle),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return const BorderSide(color: AppColors.hairline, width: 1.5);
        }
        return const BorderSide(color: AppColors.primary, width: 1.5);
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return AppColors.textMuted;
        return AppColors.primary;
      }),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }

  /// A chip-style button: compact padding, hairline border, no tinted fill.
  /// Typically used for horizontal scrolling categories or filters.
  static ButtonStyle chip({
    AppButtonShape shape = AppButtonShape.pill,
  }) {
    return ButtonStyle(
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return AppColors.fieldFill;
        if (states.contains(WidgetState.pressed)) return AppColors.fieldFill;
        return Colors.white;
      }),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      ),
      minimumSize: const WidgetStatePropertyAll(Size(0, 40)),
      shape: WidgetStatePropertyAll(_shape(shape)),
      textStyle: WidgetStatePropertyAll(
        AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      side: const WidgetStatePropertyAll(BorderSide(color: AppColors.hairline)),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return AppColors.textMuted;
        return AppColors.primaryDark;
      }),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }
}

/// Icon-only button in the app's standard circular style — a hairline
/// border, no shadow, centered icon — the same look as the Explore
/// screen's notification button. Use this for every standalone
/// icon action (back, save, notifications), instead of hand-rolling
/// a circular container each time.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 44,
    this.iconSize = AppIconSize.md,
    this.showBadge = false,
    this.backgroundColor = Colors.white,
    this.iconColor = AppIconColor.dark,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final bool showBadge;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: backgroundColor,
        shape: const CircleBorder(side: BorderSide(color: AppColors.hairline)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onTap!();
                },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Icon(icon, size: iconSize, color: iconColor),
              ),
              if (showBadge)
                Positioned(
                  top: (size - iconSize) / 2,
                  right: (size - iconSize) / 2,
                  child: Container(
                    width: size * 0.18,
                    height: size * 0.18,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
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
