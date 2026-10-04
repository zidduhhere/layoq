import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_listings.dart';
import '../models/billboard_listing.dart';

/// Source of listings. Swap the body for a network call when the data
/// layer exists; everything downstream reads through this provider.
final listingsProvider = Provider<List<BillboardListing>>(
  (ref) => mockListings,
);

/// Ids of listings the user opened, most recent first.
class RecentlyViewedNotifier extends Notifier<List<String>> {
  static const int _max = 10;

  @override
  List<String> build() => const [];

  void add(String id) {
    state = [id, ...state.where((e) => e != id)].take(_max).toList();
  }
}

final recentlyViewedIdsProvider =
    NotifierProvider<RecentlyViewedNotifier, List<String>>(
      RecentlyViewedNotifier.new,
    );

final recentlyViewedProvider = Provider<List<BillboardListing>>((ref) {
  final all = ref.watch(listingsProvider);
  final ids = ref.watch(recentlyViewedIdsProvider);
  return [
    for (final id in ids)
      for (final l in all)
        if (l.id == id) l,
  ];
});

/// Photo carousel page on the listing detail screen.
class PhotoIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void set(int index) => state = index;
}

final photoIndexProvider =
    NotifierProvider.autoDispose<PhotoIndexNotifier, int>(
      PhotoIndexNotifier.new,
    );
