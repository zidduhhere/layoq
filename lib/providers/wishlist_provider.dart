import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/billboard_listing.dart';
import 'listings_provider.dart';

/// Ids of saved listings, in the order they were saved.
class WishlistNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => const [];

  void toggle(String id) {
    state = state.contains(id)
        ? state.where((e) => e != id).toList()
        : [...state, id];
  }
}

final wishlistIdsProvider = NotifierProvider<WishlistNotifier, List<String>>(
  WishlistNotifier.new,
);

final wishlistProvider = Provider<List<BillboardListing>>((ref) {
  final all = ref.watch(listingsProvider);
  final ids = ref.watch(wishlistIdsProvider);
  return [
    for (final id in ids)
      for (final l in all)
        if (l.id == id) l,
  ];
});

final isSavedProvider = Provider.family<bool, String>(
  (ref, id) => ref.watch(wishlistIdsProvider.select((ids) => ids.contains(id))),
);
