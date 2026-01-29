import 'package:flutter/material.dart';
import '../widgets/common/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'templates_screen.dart';
import 'create_screen.dart';
import 'shared_screen.dart';
import 'profile_screen.dart';

/// MainShell wraps all main screens with a single bottom navigation bar.
/// Uses IndexedStack to preserve state when switching between tabs.
class MainShell extends StatefulWidget {
  final int initialIndex;
  
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;
  
  // Keys to preserve state of each screen
  final List<GlobalKey> _screenKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(key: _screenKeys[0], showBottomNav: false),
          TemplatesScreen(key: _screenKeys[1], showBottomNav: false),
          CreateScreen(key: _screenKeys[2], showBottomNav: false),
          SharedScreen(key: _screenKeys[3], showBottomNav: false),
          ProfileScreen(key: _screenKeys[4], showBottomNav: false),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
