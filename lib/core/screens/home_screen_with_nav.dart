import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/swipe/presentation/screens/discovery_screen.dart';
import 'package:tall_us/features/match/presentation/screens/matches_screen.dart';
import 'package:tall_us/features/profile/presentation/screens/profile_screen.dart';

/// Main home screen with bottom navigation
class HomeScreenWithNav extends ConsumerStatefulWidget {
  const HomeScreenWithNav({super.key});

  @override
  ConsumerState<HomeScreenWithNav> createState() => _HomeScreenWithNavState();
}

class _HomeScreenWithNavState extends ConsumerState<HomeScreenWithNav> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DiscoveryScreen(),
    MatchesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.bordeaux,
          unselectedItemColor: AppTheme.navy.withValues(alpha: 0.4),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Découvrir',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Matchs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
