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
class RootShell extends ConsumerStatefulWidget {
  const RootShell({super.key});

  @override
  ConsumerState<RootShell> createState() => _RootShellState();
}

class _RootShellState extends ConsumerState<RootShell> {
  static const List<Widget> _tabBodies = [
    ExploreScreen(),
    WishlistScreen(),
    CampaignsScreen(),
    ProfileScreen(),
  ];

  // Tabs are built the first time they're opened, then kept alive. The
  // first frame after sign-in only pays for Explore, not all four.
  final Set<int> _visited = {0};

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(currentTabProvider);
    final index = AppTab.values.indexOf(currentTab);
    _visited.add(index);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: index,
            children: [
              for (var i = 0; i < _tabBodies.length; i++)
                _visited.contains(i) ? _tabBodies[i] : const SizedBox.shrink(),
            ],
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
