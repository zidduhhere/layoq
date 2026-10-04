import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/billboard_listing.dart';
import 'listings_provider.dart';

/// The Explore search card's inputs: an area and optional campaign dates.
class SearchFilter {
  const SearchFilter({this.area = '', this.dates});

  final String area;
  final DateTimeRange? dates;
}

class SearchFilterNotifier extends Notifier<SearchFilter> {
  @override
  SearchFilter build() => const SearchFilter();

  void setArea(String area) =>
      state = SearchFilter(area: area, dates: state.dates);

  void setDates(DateTimeRange? dates) =>
      state = SearchFilter(area: state.area, dates: dates);
}

final searchFilterProvider =
    NotifierProvider<SearchFilterNotifier, SearchFilter>(
      SearchFilterNotifier.new,
    );

bool _matches(BillboardListing l, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return true;
  return l.area.toLowerCase().contains(q) ||
      l.landmark.toLowerCase().contains(q);
}

/// Listings matching the chosen area. Date availability is not
/// filtered yet because bookings carry no per-listing blocked dates.
final searchResultsProvider = Provider<List<BillboardListing>>((ref) {
  final area = ref.watch(searchFilterProvider.select((f) => f.area));
  return ref.watch(listingsProvider).where((l) => _matches(l, area)).toList();
});

/// Which result is focused on the map / carousel.
class SelectedResultNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int index) => state = index;
}

final selectedResultIndexProvider =
    NotifierProvider.autoDispose<SelectedResultNotifier, int>(
      SelectedResultNotifier.new,
    );

/// Text typed in the location search dialog.
class LocationQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void set(String query) => state = query;
}

final locationQueryProvider =
    NotifierProvider.autoDispose<LocationQueryNotifier, String>(
      LocationQueryNotifier.new,
    );

final locationSuggestionsProvider =
    Provider.autoDispose<List<BillboardListing>>((ref) {
      final query = ref.watch(locationQueryProvider);
      return ref
          .watch(listingsProvider)
          .where((l) => _matches(l, query))
          .toList();
    });

/// Draft state of the date range dialog; only committed to
/// [searchFilterProvider] when the user taps Apply.
class DateDraft {
  const DateDraft({required this.month, this.start, this.end});

  final DateTime month;
  final DateTime? start;
  final DateTime? end;

  DateTimeRange? get range => start != null && end != null
      ? DateTimeRange(start: start!, end: end!)
      : null;
}

class DateDraftNotifier extends Notifier<DateDraft> {
  @override
  DateDraft build() {
    final existing = ref.read(searchFilterProvider).dates;
    final base = existing?.start ?? DateTime.now();
    return DateDraft(
      month: DateTime(base.year, base.month),
      start: existing?.start,
      end: existing?.end,
    );
  }

  void tapDay(DateTime date) {
    final s = state.start, e = state.end;
    if (s == null) {
      state = DateDraft(month: state.month, start: date);
    } else if (e == null) {
      state = date.isBefore(s)
          ? DateDraft(month: state.month, start: date, end: s)
          : DateDraft(month: state.month, start: s, end: date);
    } else {
      state = DateDraft(month: state.month, start: date);
    }
  }

  void setMonth(DateTime month) => state = DateDraft(
    month: DateTime(month.year, month.month),
    start: state.start,
    end: state.end,
  );

  void nextMonth() =>
      setMonth(DateTime(state.month.year, state.month.month + 1));

  void prevMonth() =>
      setMonth(DateTime(state.month.year, state.month.month - 1));

  void reset() => state = DateDraft(month: state.month);
}

final dateDraftProvider =
    NotifierProvider.autoDispose<DateDraftNotifier, DateDraft>(
      DateDraftNotifier.new,
    );
