import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/theme_provider.dart';

class ThemeSelectionDialog extends ConsumerWidget {
  const ThemeSelectionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.primaryDark : AppColors.primary;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  color: primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Choose theme',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildOptionTile(
              context,
              ref,
              title: 'Light',
              subtitle: 'Classic bright appearance',
              icon: Icons.light_mode_outlined,
              value: ThemeMode.light,
              groupValue: currentTheme,
              isDark: isDark,
              primaryColor: primaryColor,
            ),
            _buildOptionTile(
              context,
              ref,
              title: 'Dark',
              subtitle: 'Sleek dark interface',
              icon: Icons.dark_mode_outlined,
              value: ThemeMode.dark,
              groupValue: currentTheme,
              isDark: isDark,
              primaryColor: primaryColor,
            ),
            _buildOptionTile(
              context,
              ref,
              title: 'System default',
              subtitle: 'Matches system device settings',
              icon: Icons.settings_brightness_outlined,
              value: ThemeMode.system,
              groupValue: currentTheme,
              isDark: isDark,
              primaryColor: primaryColor,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode value,
    required ThemeMode groupValue,
    required bool isDark,
    required Color primaryColor,
  }) {
    final bool isSelected = value == groupValue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: isSelected
            ? primaryColor.withValues(alpha: isDark ? 0.15 : 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
        onTap: () {
          ref.read(themeProvider.notifier).setThemeMode(value);
          Navigator.of(context).pop();
        },
        leading: Icon(
          icon,
          size: 22,
          color: isSelected
              ? primaryColor
              : (isDark ? Colors.white70 : Colors.black87),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isDark ? Colors.white : AppColors.textDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white54 : AppColors.textLight,
          ),
        ),
        trailing: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? primaryColor : (isDark ? Colors.white38 : Colors.grey.shade400),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: isSelected
              ? Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                )
              : null,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      ),
    );
  }
}
