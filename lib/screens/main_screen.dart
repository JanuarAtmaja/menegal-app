import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'favorite_screen.dart';
import 'profile_screen.dart';
import 'leaderboard_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();
  final GlobalKey<ExploreScreenState> _exploreKey = GlobalKey<ExploreScreenState>();
  final GlobalKey<FavoriteScreenState> _favoriteKey = GlobalKey<FavoriteScreenState>();
  final GlobalKey<ProfileScreenState> _profileKey = GlobalKey<ProfileScreenState>();
  final GlobalKey<LeaderboardScreenState> _leaderboardKey = GlobalKey<LeaderboardScreenState>();

  void _goToHome() => _onTabTap(0);

  void _onTabTap(int index) {
    setState(() => _currentIndex = index);
    if (index == 0) _homeKey.currentState?.loadData();
    if (index == 1) _exploreKey.currentState?.loadData();
    if (index == 2) _favoriteKey.currentState?.loadData();
    if (index == 3) _profileKey.currentState?.loadData();
    if (index == 4) _leaderboardKey.currentState?.loadData();
  }

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)?.settings.arguments as String? ?? 'user1';

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(key: _homeKey, userId: userId),
          ExploreScreen(key: _exploreKey, userId: userId, onBackToHome: _goToHome),
          FavoriteScreen(key: _favoriteKey, userId: userId, onBackToHome: _goToHome),
          ProfileScreen(key: _profileKey, userId: userId),
          LeaderboardScreen(key: _leaderboardKey),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTap,
      ),
    );
  }
}
