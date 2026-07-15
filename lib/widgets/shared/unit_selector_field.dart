import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/unit_option.dart';
import 'unit_picker_modal.dart';

class UnitSelectorField extends StatefulWidget {
  final String label;
  final UnitOption selectedUnit;
  final String displayValue;
  final List<UnitOption> options;
  final void Function(UnitOption) onUnitChanged;
  final bool isActive;
  final VoidCallback onTapField;
  final bool showSearch;
  final double dropdownWidth;
  final Offset dropdownOffset;

  const UnitSelectorField({
    super.key,
    required this.label,
    required this.selectedUnit,
    required this.displayValue,
    required this.options,
    required this.onUnitChanged,
    required this.isActive,
    required this.onTapField,
    this.showSearch = false,
    this.dropdownWidth = 240,
    this.dropdownOffset = const Offset(16.0, 0.0),
  });

  @override
  State<UnitSelectorField> createState() => _UnitSelectorFieldState();
}

class _UnitSelectorFieldState extends State<UnitSelectorField> {
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    UnitPickerDropdown.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unitNameColor = isDark ? Colors.white : AppColors.textDark;
    final unitAbbrColor = isDark ? Colors.white70 : AppColors.textLight;
    final valueColor = widget.isActive
        ? (isDark ? AppColors.primaryDark : AppColors.primary)
        : (isDark ? Colors.white : AppColors.textDark);
    final activePrimary = isDark ? AppColors.primaryDark : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          // Left side: Unit selector
          CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              onTap: () {
                widget.onTapField();
                _showDropdown();
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    widget.selectedUnit.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: unitNameColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.selectedUnit.abbreviation,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: unitAbbrColor,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Transform.translate(
                    offset: const Offset(0, 2),
                    child: Icon(
                      Icons.unfold_more_rounded,
                      color: widget.isActive ? activePrimary : unitAbbrColor,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Right side: Value
          Expanded(
            child: GestureDetector(
              onTap: widget.onTapField,
              behavior: HitTestBehavior.opaque,
              child: Text(
                widget.displayValue,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDropdown() {
    UnitPickerDropdown.show(
      context: context,
      layerLink: _layerLink,
      options: widget.options,
      selectedUnit: widget.selectedUnit,
      onSelected: widget.onUnitChanged,
      width: widget.dropdownWidth,
      offset: widget.dropdownOffset,
      showSearch: widget.showSearch,
    );
  }
}
