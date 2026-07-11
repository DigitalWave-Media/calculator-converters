import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BottomDragHandle extends StatelessWidget {
  const BottomDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(2.5),
        ),
      ),
    );
  }
}
