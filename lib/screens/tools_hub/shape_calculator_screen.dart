import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../models/measurement_shape.dart';
import '../../models/unit_option.dart';
import '../../services/measurement_calculator.dart';
import '../../widgets/shared/numeric_keypad.dart';
import '../../widgets/measurement/dimension_input_field.dart';
import '../../widgets/measurement/shape_painters.dart';

class ShapeCalculatorScreen extends StatefulWidget {
  final ShapeDefinition shape;

  const ShapeCalculatorScreen({super.key, required this.shape});

  @override
  State<ShapeCalculatorScreen> createState() => _ShapeCalculatorScreenState();
}

class _ShapeCalculatorScreenState extends State<ShapeCalculatorScreen> {
  bool _isAdvancedMode = false;
  String? _activeFieldKey;
  
  final Map<String, String> _inputs = {};
  final Map<String, UnitOption> _units = {};

  static const List<UnitOption> _lengthUnits = [
    UnitOption(name: 'Meters', abbreviation: 'm', multiplier: 1.0),
    UnitOption(name: 'Centimeters', abbreviation: 'cm', multiplier: 100.0),
    UnitOption(name: 'Millimeters', abbreviation: 'mm', multiplier: 1000.0),
    UnitOption(name: 'Feet', abbreviation: 'ft', multiplier: 3.28084),
    UnitOption(name: 'Inches', abbreviation: 'in', multiplier: 39.3701),
  ];
  
  static const List<UnitOption> _angleUnits = [
    UnitOption(name: 'Degrees', abbreviation: '°', multiplier: 1.0),
  ];

  static const List<UnitOption> _percentageUnits = [
    UnitOption(name: 'Percentage', abbreviation: '%', multiplier: 1.0),
  ];

  static const List<UnitOption> _currencyUnits = [
    UnitOption(name: 'Dollar', abbreviation: '\$', multiplier: 1.0),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.shape.fields.isNotEmpty) {
      _activeFieldKey = widget.shape.fields.first.key;
    }
    
    // Initialize units
    for (var field in widget.shape.fields) {
      if (field.key == 'angle' || field.key == 'tilt') {
        _units[field.key] = _angleUnits.first;
      } else if (field.key == 'base_area') {
        _units[field.key] = UnitOption(name: 'Square Meters', abbreviation: 'm²', multiplier: 1.0);
      } else {
        _units[field.key] = _lengthUnits.first;
      }
    }
    _units['wastage'] = _percentageUnits.first;
    _units['cost'] = _currencyUnits.first;
  }

  void _onKeyPressed(String key) {
    if (_activeFieldKey == null) return;
    
    setState(() {
      final current = _inputs[_activeFieldKey] ?? '';
      
      if (key == 'Clear' || key == 'C') {
        _inputs[_activeFieldKey!] = '';
      } else if (key == '⌫') {
        if (current.isNotEmpty) {
          _inputs[_activeFieldKey!] = current.substring(0, current.length - 1);
        }
      } else if (key == '.') {
        if (!current.contains('.')) {
          _inputs[_activeFieldKey!] = current.isEmpty ? '0.' : '$current.';
        }
      } else if (key == '00') {
        if (current.isNotEmpty && current != '0') {
          _inputs[_activeFieldKey!] = '${current}00';
        }
      } else if (key == '+' || key == '−' || key == '×' || key == '÷' || key == '%' || key == '=') {
        // Ignored for simple input for now
      } else {
        if (current == '0') {
          _inputs[_activeFieldKey!] = key;
        } else {
          _inputs[_activeFieldKey!] = current + key;
        }
      }
    });
  }

  void _showShapeSwitcher() {
    final shapes = widget.shape.type == MeasurementType.area
        ? MeasurementCalculator.areaShapes
        : MeasurementCalculator.volumeShapes;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.shape.type == MeasurementType.area ? 'Area Shapes' : 'Volume Shapes',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: shapes.length,
                  itemBuilder: (ctx, index) {
                    final s = shapes[index];
                    final isSelected = s.id == widget.shape.id;
                    return InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                        if (!isSelected) {
                          context.pushReplacement(
                            AppRoutes.measurementCalculator.replaceAll(':shapeId', s.id),
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : (isDark ? AppColors.darkCardBg : Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.view_in_ar_rounded,
                              color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : AppColors.textLight),
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                s.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isDark ? Colors.white : AppColors.textDark,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Build the values map for calculation
    final Map<String, double> values = {};
    for (var f in widget.shape.fields) {
      double rawValue = double.tryParse(_inputs[f.key] ?? '') ?? 0.0;
      final unit = _units[f.key];
      if (unit != null && unit.multiplier != 0.0 && unit.multiplier != 1.0) {
        rawValue = rawValue / unit.multiplier;
      }
      values[f.key] = rawValue;
    }
    
    final wastage = double.tryParse(_inputs['wastage'] ?? '') ?? 0.0;
    final unitCost = double.tryParse(_inputs['cost'] ?? '');
    
    final result = MeasurementCalculator.calculate(
      shape: widget.shape, 
      values: values, 
      isAdvancedMode: _isAdvancedMode,
      wastagePercentage: wastage,
      unitCost: unitCost,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.shape.name, style: const TextStyle(fontSize: 18)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(_isAdvancedMode ? Icons.build_circle : Icons.build_circle_outlined),
            color: _isAdvancedMode ? AppColors.primary : null,
            tooltip: 'Advanced Mode',
            onPressed: () {
              setState(() {
                _isAdvancedMode = !_isAdvancedMode;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Change Shape',
            onPressed: _showShapeSwitcher,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: ShapeDiagram(
                        shapeId: widget.shape.id,
                        color: AppColors.primary,
                        height: 120, // Smaller diagram box
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (result.calculationSteps.isNotEmpty) ...[
                            Text(
                              'Formula & Calculation',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white54 : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            for (var step in result.calculationSteps)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  step,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? Colors.white70 : Colors.black87,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Form Fields
                ...widget.shape.fields.map((field) {
                  return DimensionInputField(
                    label: '${field.label} (${field.symbol})',
                    selectedUnit: _units[field.key] ?? _lengthUnits.first,
                    displayValue: _inputs[field.key]?.isEmpty ?? true ? '0' : _inputs[field.key]!,
                    options: (field.key == 'angle' || field.key == 'tilt') 
                        ? _angleUnits 
                        : (field.key == 'base_area' ? [_units[field.key]!] : _lengthUnits),
                    onUnitChanged: (unit) {
                      setState(() {
                        _units[field.key] = unit;
                      });
                    },
                    isActive: _activeFieldKey == field.key,
                    onTapField: () {
                      setState(() {
                        _activeFieldKey = field.key;
                      });
                    },
                  );
                }),
                
                if (_isAdvancedMode) ...[
                  const Divider(height: 32),
                  const Text('Advanced Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  DimensionInputField(
                    label: 'Wastage',
                    selectedUnit: _percentageUnits.first,
                    displayValue: _inputs['wastage']?.isEmpty ?? true ? '0' : _inputs['wastage']!,
                    options: _percentageUnits,
                    onUnitChanged: (unit) {},
                    isActive: _activeFieldKey == 'wastage',
                    onTapField: () {
                      setState(() {
                        _activeFieldKey = 'wastage';
                      });
                    },
                  ),
                  DimensionInputField(
                    label: 'Unit Cost',
                    selectedUnit: _currencyUnits.first,
                    displayValue: _inputs['cost']?.isEmpty ?? true ? '0' : _inputs['cost']!,
                    options: _currencyUnits,
                    onUnitChanged: (unit) {},
                    isActive: _activeFieldKey == 'cost',
                    onTapField: () {
                      setState(() {
                        _activeFieldKey = 'cost';
                      });
                    },
                  ),
                ],

                const SizedBox(height: 24),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: Text(
                      'Result: ${result.grossValueWithWastage.toStringAsFixed(3)} ${result.unitSymbol}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                if (_isAdvancedMode && result.totalCost != null) ...[
                  Center(
                    child: Text(
                      'Total Cost: \$${result.totalCost!.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                  ),
                ],
                
                // Give some padding at the bottom so we can scroll past the keyboard
                const SizedBox(height: 24),
              ],
            ),
          ),
          
          // Custom Keypad
          NumericKeypad(
            mode: KeypadMode.standard,
            onKeyPressed: _onKeyPressed,
            isKeyEnabled: (key) {
               if (key == '+' || key == '−' || key == '×' || key == '÷' || key == '%' || key == '=') {
                 return false; // Disable operators for simple numeric input
               }
               return true;
            },
          ),
        ],
      ),
    );
  }
}
