import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/routes.dart';
import '../../providers/currency_provider.dart';

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
    HubItem(name: 'Num to Word', icon: Icons.text_fields_outlined, route: AppRoutes.numToWord, color: Colors.teal),
    HubItem(name: 'Currency', icon: Icons.attach_money, route: AppRoutes.currency, color: Colors.amber),
    HubItem(name: 'Date', icon: Icons.calendar_month, route: AppRoutes.date, color: Colors.redAccent),
    
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
    
    // Calculators
    HubItem(name: 'GST', icon: Icons.percent, route: AppRoutes.gst, color: Colors.blueGrey),
    HubItem(name: 'Discount', icon: Icons.discount_outlined, route: AppRoutes.discount, color: Colors.pink),
    HubItem(name: 'BMI', icon: Icons.accessibility_new, route: AppRoutes.bmi, color: Colors.cyan),
    HubItem(name: 'Finance', icon: Icons.account_balance, route: AppRoutes.finance, color: Colors.purpleAccent),
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
                        child: Icon(
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
                      ),
                      if (item.name == 'Currency')
                        Consumer(
                          builder: (context, ref, _) {
                            final currencyState = ref.watch(currencyProvider);
                            final timestamp = currencyState.ratesTimestamp;
                            if (timestamp == null) return const SizedBox.shrink();
                            
                            return Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: isDark ? Colors.white54 : Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  InkWell(
                                    onTap: () {
                                      ref.read(currencyProvider.notifier).refreshRates();
                                    },
                                    child: Icon(
                                      Icons.refresh,
                                      size: 11,
                                      color: isDark ? Colors.white54 : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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
