import 'billboard_listing.dart';

/// Lifecycle of a booking request, in the order Campaigns tabs show it.
enum CampaignStatus { pending, upcoming, active, completed }

/// An advertiser's request to book a listing for a date range.
class BookingRequest {
  const BookingRequest({
    required this.id,
    required this.listing,
    required this.createdAt,
    this.start,
    this.end,
    this.status = CampaignStatus.pending,
  });

  final String id;
  final BillboardListing listing;
  final DateTime createdAt;
  final DateTime? start;
  final DateTime? end;
  final CampaignStatus status;
}
