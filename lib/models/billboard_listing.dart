/// A single static billboard listing, as shown in browse/search results.
class BillboardListing {
  const BillboardListing({
    required this.id,
    required this.area,
    required this.landmark,
    required this.widthFt,
    required this.heightFt,
    required this.illuminated,
    required this.pricePerMonth,
    required this.dailyTraffic,
    required this.orientation,
    required this.materialType,
    required this.minBookingDuration,
    required this.restrictions,
  });

  final String id;
  final String area;
  final String landmark;
  final double widthFt;
  final double heightFt;
  final bool illuminated;
  final int pricePerMonth;
  
  // New details
  final String dailyTraffic;
  final String orientation;
  final String materialType;
  final String minBookingDuration;
  final String restrictions;

  String get sizeLabel => '${widthFt.toStringAsFixed(0)} x ${heightFt.toStringAsFixed(0)} ft';
}
