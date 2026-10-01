import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/app_bottom_nav.dart';
import 'campaigns_screen.dart';
import 'explore_screen.dart';
import 'profile_screen.dart';
import 'wishlist_screen.dart';

/// App shell owning the single bottom nav and the 4 top-level tab
/// bodies. Each body keeps its state alive across tab switches via
/// [IndexedStack] rather than being rebuilt from scratch.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  AppTab _currentTab = AppTab.explore;

  static const List<Widget> _tabBodies = [
    ExploreScreen(),
    WishlistScreen(),
    CampaignsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: AppTab.values.indexOf(_currentTab),
            children: _tabBodies,
          ),
        ),
        bottomNavigationBar: AppBottomNav(
          currentTab: _currentTab,
          onTabSelected: (tab) => setState(() => _currentTab = tab),
        ),
      ),
    );
  }
}
