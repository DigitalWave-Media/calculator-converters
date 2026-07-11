import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class TabHeader extends StatelessWidget {
  final int activeIndex;
  final Function(int) onTap;

  const TabHeader({
    super.key,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Row(
          children: [
            _buildTab(context, label: 'Calculator', index: 0),
            const SizedBox(width: 24),
            _buildTab(context, label: 'Converter', index: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, {required String label, required int index}) {
    final bool isActive = activeIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isActive ? AppColors.textDark : AppColors.textLight,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: isActive ? 28 : 0,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ],
      ),
    );
  }
}
