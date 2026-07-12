import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../widgets/shared/tab_header.dart';
import 'calculator/calculator_screen.dart';
import 'converter_hub/converter_hub_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          TabHeader(
            activeIndex: _currentIndex,
            onTap: _onTabTapped,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: const [
                CalculatorScreen(),
                ConverterHubScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
