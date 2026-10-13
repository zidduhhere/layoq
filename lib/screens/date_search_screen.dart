import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../providers/providers.dart';

/// A custom date range picker designed to mirror the exact structure
/// and Hero animation of the LocationSearchDialog.
class DateSearchDialog extends ConsumerStatefulWidget {
  const DateSearchDialog({super.key});

  @override
  ConsumerState<DateSearchDialog> createState() => _DateSearchDialogState();
}

class _DateSearchDialogState extends ConsumerState<DateSearchDialog> {
  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  int _getDaysInMonth(int year, int month) {
    if (month == 12) return DateTime(year + 1, 1, 0).day;
    return DateTime(year, month + 1, 0).day;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isInRange(DateTime date, DateDraft d) {
    if (d.start == null || d.end == null) return false;
    return date.isAfter(d.start!) && date.isBefore(d.end!);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(dateDraftProvider);
    final notifier = ref.read(dateDraftProvider.notifier);
    final currentMonth = draft.month;
    final startDate = draft.start;
    final endDate = draft.end;
    final daysInMonth = _getDaysInMonth(currentMonth.year, currentMonth.month);
    // DateTime.weekday returns 1 for Monday, 7 for Sunday. We want Sunday = 0.
    final offset =
        DateTime(currentMonth.year, currentMonth.month, 1).weekday % 7;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Hero(
        tag: 'search_dates',
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 520),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Calendar header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            DateTime tempMonth = currentMonth;
                            final picked = await showDialog<DateTime>(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setDialogState) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.chevron_left_rounded,
                                                    color:
                                                        AppColors.primaryDark,
                                                  ),
                                                  onPressed: () =>
                                                      setDialogState(() {
                                                        tempMonth = DateTime(
                                                          tempMonth.year - 1,
                                                          tempMonth.month,
                                                        );
                                                      }),
                                                ),
                                                Text(
                                                  tempMonth.year.toString(),
                                                  style: AppTextStyles.h2,
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.chevron_right_rounded,
                                                    color:
                                                        AppColors.primaryDark,
                                                  ),
                                                  onPressed: () =>
                                                      setDialogState(() {
                                                        tempMonth = DateTime(
                                                          tempMonth.year + 1,
                                                          tempMonth.month,
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              alignment: WrapAlignment.center,
                                              children: List.generate(12, (
                                                index,
                                              ) {
                                                final isSelected =
                                                    index + 1 ==
                                                    tempMonth.month;
                                                return ChoiceChip(
                                                  label: Text(
                                                    _months[index].substring(
                                                      0,
                                                      3,
                                                    ),
                                                    style: AppTextStyles
                                                        .bodyMedium
                                                        .copyWith(
                                                          color: isSelected
                                                              ? Colors.white
                                                              : AppColors
                                                                    .primaryDark,
                                                          fontWeight: isSelected
                                                              ? FontWeight.w700
                                                              : FontWeight.w500,
                                                        ),
                                                  ),
                                                  selected: isSelected,
                                                  selectedColor:
                                                      AppColors.primary,
                                                  backgroundColor:
                                                      AppColors.fieldFill,
                                                  showCheckmark: false,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    side: BorderSide.none,
                                                  ),
                                                  onSelected: (selected) {
                                                    Navigator.of(context).pop(
                                                      DateTime(
                                                        tempMonth.year,
                                                        index + 1,
                                                      ),
                                                    );
                                                  },
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                            if (picked != null) {
                              notifier.setMonth(picked);
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                '${_months[currentMonth.month - 1]} ${currentMonth.year}',
                                style: AppTextStyles.h3,
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.primaryDark,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.chevron_left_rounded,
                                color: AppColors.primaryDark,
                              ),
                              onPressed: notifier.prevMonth,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.primaryDark,
                              ),
                              onPressed: notifier.nextMonth,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Weekdays
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _weekdays
                          .map(
                            (d) => SizedBox(
                              width: 32,
                              child: Center(
                                child: Text(
                                  d,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Calendar Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            childAspectRatio: 1.1,
                          ),
                      itemCount: 42, // 6 weeks max
                      itemBuilder: (context, index) {
                        if (index < offset || index >= offset + daysInMonth) {
                          return const SizedBox();
                        }

                        final day = index - offset + 1;
                        final date = DateTime(
                          currentMonth.year,
                          currentMonth.month,
                          day,
                        );
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);

                        // Disable past dates
                        if (date.isBefore(today)) {
                          return Center(
                            child: Text(
                              day.toString(),
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textMuted.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          );
                        }

                        final isStart =
                            startDate != null && _isSameDay(date, startDate);
                        final isEnd =
                            endDate != null && _isSameDay(date, endDate);
                        final inRange = _isInRange(date, draft);

                        return GestureDetector(
                          onTap: () => notifier.tapDay(date),
                          child: Stack(
                            children: [
                              // Range highlight connecting the circles
                              if (inRange ||
                                  (isStart && endDate != null) ||
                                  (isEnd && startDate != null))
                                Positioned(
                                  left: isStart ? 24 : 0,
                                  right: isEnd ? 24 : 0,
                                  top: 4,
                                  bottom: 4,
                                  child: Container(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                              // The actual day circle/text
                              Center(
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isStart || isEnd
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      day.toString(),
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: (isStart || isEnd)
                                            ? Colors.white
                                            : (inRange
                                                  ? AppColors.primaryDark
                                                  : AppColors.primaryDark),
                                        fontWeight:
                                            (isStart || isEnd || inRange)
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom Actions
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: notifier.reset,
                          child: Text(
                            'Reset',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: AppColors.primary
                                .withValues(alpha: 0.3),
                            disabledForegroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            elevation: 0,
                          ),
                          onPressed: (startDate != null && endDate != null)
                              ? () {
                                  Navigator.of(context).pop(
                                    DateTimeRange(
                                      start: startDate,
                                      end: endDate,
                                    ),
                                  );
                                }
                              : null,
                          child: const Text(
                            'Apply',
                            style: TextStyle(fontWeight: FontWeight.w600),
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
      ),
    );
  }
}
