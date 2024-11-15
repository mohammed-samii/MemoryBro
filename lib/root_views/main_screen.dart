import 'package:flutter/material.dart';
import 'package:movie_watchlist/root_views/emoji/views/emoji_based.dart';
import 'package:movie_watchlist/root_views/home/views/home_screen.dart';
import 'package:movie_watchlist/root_views/home/widgets/bottom_navigation.dart';
import 'package:movie_watchlist/root_views/profile/views/profile_screen.dart';
import 'package:movie_watchlist/root_views/watchlist/views/view_watchlist_and_add.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      const HomeScreen(),
      const EmojiScreen(),
      const ViewWatchlistScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
