import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/common/bottom_nav_bar.dart';
import 'home_content.dart';
import 'other_contents.dart';

/// Main navigation shell with persistent bottom nav bar
/// Uses IndexedStack to keep pages in memory and prevent refreshing
class MainShell extends StatefulWidget {
  final int initialIndex;
  
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      resizeToAvoidBottomInset: false, // Prevents bottom nav from moving with keyboard
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeContent(),
          TemplatesContent(),
          CreateContent(),
          SharedContent(),
          ProfileContent(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
