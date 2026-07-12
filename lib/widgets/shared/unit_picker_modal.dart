import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/unit_option.dart';

class UnitPickerDropdown {
  static OverlayEntry? _currentOverlay;

  static void show({
    required BuildContext context,
    required LayerLink layerLink,
    required List<UnitOption> options,
    required UnitOption selectedUnit,
    required Function(UnitOption) onSelected,
    double width = 280,
    bool showSearch = false,
  }) {
    dismiss();

    final OverlayState overlayState = Overlay.of(context);
    
    _currentOverlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Translucent barrier to dismiss on tapping outside
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: dismiss,
                child: Container(color: Colors.transparent),
              ),
            ),
            // Floating Dropdown Card
            Positioned(
              width: width,
              child: CompositedTransformFollower(
                link: layerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 65), // Position just below the field
                child: Material(
                  elevation: 6,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 280),
                    child: _DropdownList(
                      options: options,
                      selectedUnit: selectedUnit,
                      onSelected: (unit) {
                        onSelected(unit);
                        dismiss();
                      },
                      showSearch: showSearch,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlayState.insert(_currentOverlay!);
  }

  static void dismiss() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }

  static bool get isShowing => _currentOverlay != null;
}

class _DropdownList extends StatefulWidget {
  final List<UnitOption> options;
  final UnitOption selectedUnit;
  final Function(UnitOption) onSelected;
  final bool showSearch;

  const _DropdownList({
    required this.options,
    required this.selectedUnit,
    required this.onSelected,
    required this.showSearch,
  });

  @override
  State<_DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<_DropdownList> {
  late List<UnitOption> _filteredOptions;

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
  }

  void _filter(String query) {
    setState(() {
      _filteredOptions = widget.options
          .where((opt) =>
              opt.name.toLowerCase().contains(query.toLowerCase()) ||
              opt.abbreviation.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showSearch)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
              ),
              onChanged: _filter,
            ),
          ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _filteredOptions.length,
            itemBuilder: (context, index) {
              final option = _filteredOptions[index];
              final isSelected = option == widget.selectedUnit;

              return ListTile(
                title: Text(
                  option.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.primary : AppColors.textDark,
                  ),
                ),
                trailing: Text(
                  option.abbreviation,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textLight,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                onTap: () => widget.onSelected(option),
              );
            },
          ),
        ),
      ],
    );
  }
}
