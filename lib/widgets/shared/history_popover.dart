import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/history_entry.dart';

class HistoryPopover extends StatelessWidget {
  final List<HistoryEntry> history;
  final VoidCallback onClear;
  final Function(String) onItemTapped;

  const HistoryPopover({
    super.key,
    required this.history,
    required this.onClear,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              if (history.isNotEmpty)
                TextButton(
                  onPressed: onClear,
                  child: const Text(
                    'Clear all',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
            ],
          ),
          const Divider(),
          if (history.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Text(
                'No history yet',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textLight),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final entry = history[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      entry.expression,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textGray,
                      ),
                    ),
                    subtitle: Text(
                      '= ${entry.result}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    onTap: () {
                      onItemTapped(entry.expression);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
