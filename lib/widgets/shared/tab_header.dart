import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../services/app_share_service.dart';
import 'feedback_dialog.dart';
import 'theme_selection_dialog.dart';

class TabHeader extends ConsumerWidget {
  final int activeIndex;
  final Function(int) onTap;

  const TabHeader({
    super.key,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTab(context, label: 'Calculator', index: 0, isDark: isDark),
                    const SizedBox(width: 16),
                    _buildTab(context, label: 'Converter', index: 1, isDark: isDark),
                    const SizedBox(width: 16),
                    _buildTab(context, label: 'Tools', index: 2, isDark: isDark),
                  ],
                ),
              ),
            ),
            // More options button (three vertical dots) in top right corner
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                size: 24,
                color: isDark ? Colors.white : AppColors.textSecondaryLight,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: isDark ? AppColors.darkSurface : Colors.white,
              elevation: 4,
              onSelected: (value) => _onMenuSelected(context, ref, value),
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'history',
                  child: Row(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 20,
                        color: isDark ? Colors.white70 : AppColors.textDark,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'History',
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'theme',
                  child: Row(
                    children: [
                      Icon(
                        Icons.palette_outlined,
                        size: 20,
                        color: isDark ? Colors.white70 : AppColors.textDark,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Choose theme',
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'feedback',
                  child: Row(
                    children: [
                      Icon(
                        Icons.feedback_outlined,
                        size: 20,
                        color: isDark ? Colors.white70 : AppColors.textDark,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Send feedback',
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(
                        Icons.share_outlined,
                        size: 20,
                        color: isDark ? Colors.white70 : AppColors.textDark,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Share app',
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onMenuSelected(BuildContext context, WidgetRef ref, String value) {
    switch (value) {
      case 'history':
        context.push(AppRoutes.history);
        break;
      case 'theme':
        showDialog(
          context: context,
          builder: (context) => const ThemeSelectionDialog(),
        );
        break;
      case 'feedback':
        showDialog(
          context: context,
          builder: (context) => const FeedbackDialog(),
        );
        break;
      case 'share':
        AppShareService.shareApp(context);
        break;
    }
  }

  Widget _buildTab(
    BuildContext context, {
    required String label,
    required int index,
    required bool isDark,
  }) {
    final bool isActive = activeIndex == index;
    final primaryColor = isDark ? AppColors.primaryDark : AppColors.primary;
    final activeTextColor = isDark ? Colors.white : AppColors.textDark;
    final inactiveTextColor = isDark ? const Color(0xFFF5F5F5).withValues(alpha: 0.6) : AppColors.textLight;

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
              color: isActive ? activeTextColor : inactiveTextColor,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: isActive ? 28 : 0,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ],
      ),
    );
  }
}
