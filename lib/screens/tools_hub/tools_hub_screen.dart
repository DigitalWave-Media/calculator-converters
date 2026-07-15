import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/measurement/shape_painters.dart';

class HubItem {
  final String name;
  final IconData? icon;
  final String? shapeId;
  final String route;
  final Color color;

  const HubItem({
    required this.name,
    this.icon,
    this.shapeId,
    required this.route,
    required this.color,
  });
}

class MeasurementHubScreen extends StatelessWidget {
  const MeasurementHubScreen({super.key});

  static const List<HubItem> items = [
    HubItem(name: 'Area\nMeasurement', shapeId: 'square', route: AppRoutes.measurementArea, color: Colors.green),
    HubItem(name: 'Volume\nMeasurement', shapeId: 'cube', route: AppRoutes.measurementVolume, color: Colors.indigo),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemTextColor = isDark ? Colors.white : AppColors.textDark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: SafeArea(
        top: false,
        child: GridView.builder(
          padding: const EdgeInsets.all(10.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 4.0,
            childAspectRatio: 1.0,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.push(item.route),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: item.shapeId != null
                            ? ShapeIcon(shapeId: item.shapeId!, color: item.color, size: 28)
                            : Icon(
                                item.icon,
                                color: item.color,
                                size: 28,
                              ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: itemTextColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
