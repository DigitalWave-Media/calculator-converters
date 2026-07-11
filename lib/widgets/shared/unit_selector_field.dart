import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
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
  });

  @override
  State<UnitSelectorField> createState() => _UnitSelectorFieldState();
}

class _UnitSelectorFieldState extends State<UnitSelectorField> {
  final LayerLink _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.onTapField,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: widget.isActive ? Colors.white : Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isActive ? AppColors.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Unit Name & Abbreviation column
                  GestureDetector(
                    onTap: () {
                      widget.onTapField();
                      _showDropdown();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.selectedUnit.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            Text(
                              widget.selectedUnit.abbreviation,
                              style: AppTextStyles.labelLarge,
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  // Display value
                  Expanded(
                    child: Text(
                      widget.displayValue,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: widget.isActive ? AppColors.primary : AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
      showSearch: widget.showSearch,
    );
  }
}
