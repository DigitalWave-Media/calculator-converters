import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/unit_option.dart';
import '../shared/unit_picker_modal.dart';

class DimensionInputField extends StatefulWidget {
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

  const DimensionInputField({
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
    this.dropdownOffset = const Offset(0.0, 30.0),
  });

  @override
  State<DimensionInputField> createState() => _DimensionInputFieldState();
}

class _DimensionInputFieldState extends State<DimensionInputField> {
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    UnitPickerDropdown.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unitAbbrColor = isDark ? Colors.white70 : AppColors.textLight;
    final valueColor = widget.isActive
        ? (isDark ? AppColors.primaryDark : AppColors.primary)
        : (isDark ? Colors.white : AppColors.textDark);
    final activePrimary = isDark ? AppColors.primaryDark : AppColors.primary;
    final labelColor = isDark ? Colors.white54 : AppColors.textLight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: Label and Unit selector
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
              const SizedBox(height: 4),
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
                    children: [
                      Text(
                        widget.selectedUnit.abbreviation,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.isActive ? activePrimary : unitAbbrColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.unfold_more_rounded,
                        color: widget.isActive ? activePrimary : unitAbbrColor,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
