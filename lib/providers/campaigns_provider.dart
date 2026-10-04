import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/billboard_listing.dart';
import '../models/booking_request.dart';

class CampaignsNotifier extends Notifier<List<BookingRequest>> {
  @override
  List<BookingRequest> build() => const [];

  /// Files a pending request. Returns false if this listing already has
  /// a pending one, so the user can't double-submit.
  bool request(BillboardListing listing, DateTimeRange? dates) {
    final duplicate = state.any(
      (r) => r.listing.id == listing.id && r.status == CampaignStatus.pending,
    );
    if (duplicate) return false;
    final now = DateTime.now();
    state = [
      BookingRequest(
        id: 'req-${now.microsecondsSinceEpoch}',
        listing: listing,
        createdAt: now,
        start: dates?.start,
        end: dates?.end,
      ),
      ...state,
    ];
    return true;
  }
}

final campaignsProvider =
    NotifierProvider<CampaignsNotifier, List<BookingRequest>>(
      CampaignsNotifier.new,
    );

class CampaignTabNotifier extends Notifier<CampaignStatus> {
  @override
  CampaignStatus build() => CampaignStatus.pending;

  void select(CampaignStatus status) => state = status;
}

final campaignTabProvider =
    NotifierProvider<CampaignTabNotifier, CampaignStatus>(
      CampaignTabNotifier.new,
    );

final visibleCampaignsProvider = Provider<List<BookingRequest>>((ref) {
  final tab = ref.watch(campaignTabProvider);
  return ref.watch(campaignsProvider).where((r) => r.status == tab).toList();
});
