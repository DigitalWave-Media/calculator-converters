import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/routes.dart';
import '../../widgets/shared/bottom_drag_handle.dart';

class HubItem {
  final String name;
  final IconData icon;
  final String route;
  final Color color;

  const HubItem({
    required this.name,
    required this.icon,
    required this.route,
    required this.color,
  });
}

class ConverterHubScreen extends StatelessWidget {
  const ConverterHubScreen({super.key});

  static const List<HubItem> items = [
    // Converters
    HubItem(name: 'Length', icon: Icons.linear_scale, route: AppRoutes.length, color: Colors.blue),
    HubItem(name: 'Mass', icon: Icons.monitor_weight_outlined, route: AppRoutes.mass, color: Colors.teal),
    HubItem(name: 'Area', icon: Icons.grid_on, route: AppRoutes.area, color: Colors.green),
    HubItem(name: 'Volume', icon: Icons.opacity, route: AppRoutes.volume, color: Colors.indigo),
    HubItem(name: 'Time', icon: Icons.access_time, route: AppRoutes.time, color: Colors.orange),
    HubItem(name: 'Speed', icon: Icons.speed, route: AppRoutes.speed, color: Colors.deepOrange),
    HubItem(name: 'Temp', icon: Icons.thermostat, route: AppRoutes.temperature, color: Colors.red),
    HubItem(name: 'Data', icon: Icons.pie_chart_outline, route: AppRoutes.data, color: Colors.purple),
    HubItem(name: 'Numeral', icon: Icons.onetwothree, route: AppRoutes.numeral, color: Colors.brown),
    HubItem(name: 'Currency', icon: Icons.attach_money, route: AppRoutes.currency, color: Colors.amber),
    
    // Calculators
    HubItem(name: 'GST', icon: Icons.percent, route: AppRoutes.gst, color: Colors.blueGrey),
    HubItem(name: 'Discount', icon: Icons.discount_outlined, route: AppRoutes.discount, color: Colors.pink),
    HubItem(name: 'BMI', icon: Icons.accessibility_new, route: AppRoutes.bmi, color: Colors.cyan),
    HubItem(name: 'Finance', icon: Icons.account_balance, route: AppRoutes.finance, color: Colors.purpleAccent),
    HubItem(name: 'Date', icon: Icons.calendar_month, route: AppRoutes.date, color: Colors.redAccent),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 0.95,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: AppColors.divider.withValues(alpha: 0.2)),
                    ),
                    color: Colors.white,
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, item.route),
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
                              child: Icon(
                                item.icon,
                                color: item.color,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const BottomDragHandle(),
          ],
        ),
      ),
    );
  }
}
