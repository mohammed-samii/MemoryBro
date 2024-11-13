import 'package:flutter/material.dart';
import 'package:movie_watchlist/views/watchlist/view_watchlist_and_add.dart';
import 'package:movie_watchlist/views/emoji/emoji_based.dart';
import 'package:movie_watchlist/views/home/home_screen.dart';
import 'package:movie_watchlist/views/profile/profile_screen.dart';
import 'package:movie_watchlist/widgets/bottom_navigation.dart';

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
