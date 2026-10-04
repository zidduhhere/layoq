import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/app_bottom_nav.dart';

/// Currently selected bottom-nav tab. Any screen can switch tabs
/// (e.g. the Wishlist empty state jumps to Explore).
class TabNotifier extends Notifier<AppTab> {
  @override
  AppTab build() => AppTab.explore;

  void select(AppTab tab) => state = tab;
}

final currentTabProvider = NotifierProvider<TabNotifier, AppTab>(
  TabNotifier.new,
);
