import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/app_bottom_nav.dart';
import 'campaigns_screen.dart';
import 'explore_screen.dart';
import 'profile_screen.dart';
import 'wishlist_screen.dart';

/// App shell owning the single bottom nav and the 4 top-level tab
/// bodies. Each body keeps its state alive across tab switches via
/// [IndexedStack]; the selected tab lives in [currentTabProvider].
class RootShell extends ConsumerWidget {
  const RootShell({super.key});

  static const List<Widget> _tabBodies = [
    ExploreScreen(),
    WishlistScreen(),
    CampaignsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: AppTab.values.indexOf(currentTab),
            children: _tabBodies,
          ),
        ),
        bottomNavigationBar: AppBottomNav(
          currentTab: currentTab,
          onTabSelected: ref.read(currentTabProvider.notifier).select,
        ),
      ),
    );
  }
}
