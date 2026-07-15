import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/measurement_shape.dart';
import 'package:go_router/go_router.dart';

class ShapePickerModal {
  static OverlayEntry? _currentOverlay;
  static _DropdownOverlayContentState? _currentState;

  // Dropdown style (mimicking UnitPickerDropdown) for Area
  static void showDropdown({
    required BuildContext context,
    required LayerLink layerLink,
    required List<ShapeDefinition> options,
    required ShapeDefinition selectedShape,
    required Function(ShapeDefinition) onSelected,
    double width = 280,
    Offset offset = const Offset(0, 75),
    bool showSearch = false,
  }) {
    dismiss();

    final OverlayState overlayState = Overlay.of(context);
    
    _currentOverlay = OverlayEntry(
      builder: (context) {
        return _DropdownOverlayContent(
          layerLink: layerLink,
          options: options,
          selectedShape: selectedShape,
          onSelected: (shape) {
            onSelected(shape);
            dismiss();
          },
          onDismiss: () {
            _currentOverlay?.remove();
            _currentOverlay = null;
            _currentState = null;
          },
          width: width,
          offset: offset,
          showSearch: showSearch,
        );
      },
    );

    overlayState.insert(_currentOverlay!);
  }

  static void dismiss() {
    if (_currentState != null && _currentState!.mounted) {
      _currentState!._close(() {
        _currentOverlay?.remove();
        _currentOverlay = null;
        _currentState = null;
      });
    } else {
      _currentOverlay?.remove();
      _currentOverlay = null;
      _currentState = null;
    }
  }

  static bool get isShowing => _currentOverlay != null;

  // Bottom sheet grid style (mimicking ConverterHubScreen) for Volume
  static Future<void> showGridModal({
    required BuildContext context,
    required List<ShapeDefinition> options,
    required ShapeDefinition selectedShape,
    required Function(ShapeDefinition) onSelected,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemTextColor = isDark ? Colors.white : AppColors.textDark;

    return showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Select Shape',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: itemTextColor,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final shape = options[index];
                      final isSelected = shape == selectedShape;
                      final primaryColor = isDark ? AppColors.primaryDark : AppColors.primary;

                      return Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isSelected ? primaryColor : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        color: isDark 
                            ? (isSelected ? primaryColor.withValues(alpha: 0.2) : AppColors.darkSurface)
                            : (isSelected ? primaryColor.withValues(alpha: 0.1) : Colors.grey[100]),
                        child: InkWell(
                          onTap: () {
                            onSelected(shape);
                            context.pop();
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    shape.type == MeasurementType.area
                                        ? Icons.category_rounded
                                        : Icons.view_in_ar_rounded,
                                    color: primaryColor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  shape.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    color: itemTextColor,
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
              ],
            );
          },
        );
      },
    );
  }
}

class _DropdownOverlayContent extends StatefulWidget {
  final LayerLink layerLink;
  final List<ShapeDefinition> options;
  final ShapeDefinition selectedShape;
  final ValueChanged<ShapeDefinition> onSelected;
  final VoidCallback onDismiss;
  final double width;
  final Offset offset;
  final bool showSearch;

  const _DropdownOverlayContent({
    required this.layerLink,
    required this.options,
    required this.selectedShape,
    required this.onSelected,
    required this.onDismiss,
    required this.width,
    required this.offset,
    required this.showSearch,
  });

  @override
  State<_DropdownOverlayContent> createState() => _DropdownOverlayContentState();
}

class _DropdownOverlayContentState extends State<_DropdownOverlayContent> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final ScrollController _scrollController;
  late List<ShapeDefinition> _filteredOptions;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    ShapePickerModal._currentState = this;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _scrollController = ScrollController();
    _filteredOptions = widget.options;
    _controller.forward();
  }

  @override
  void dispose() {
    if (ShapePickerModal._currentState == this) {
      ShapePickerModal._currentState = null;
    }
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _close(VoidCallback onFinished) {
    if (_isClosing) return;
    setState(() {
      _isClosing = true;
    });
    _controller.reverse().then((_) {
      onFinished();
    });
  }

  void _filter(String query) {
    setState(() {
      _filteredOptions = widget.options
          .where((opt) => opt.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const double itemHeight = 52.0;
    const double searchFieldHeight = 56.0;
    
    final int visibleCount = _filteredOptions.isEmpty ? 1 : _filteredOptions.length.clamp(1, 8);
    final double listHeight = itemHeight * visibleCount;
    final double dropdownHeight = listHeight + (widget.showSearch ? searchFieldHeight : 0.0);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dropdownBg = isDark ? AppColors.darkCardBg : Colors.white;
    final primaryColor = isDark ? AppColors.primaryDark : AppColors.primary;
    final unselectedNameColor = isDark ? Colors.white : AppColors.textDark;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _close(widget.onDismiss),
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Container(
                  color: Colors.black.withValues(alpha: _fadeAnimation.value * 0.55),
                );
              },
            ),
          ),
        ),
        Positioned(
          width: widget.width,
          child: CompositedTransformFollower(
            link: widget.layerLink,
            showWhenUnlinked: false,
            offset: widget.offset,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                alignment: Alignment.topCenter,
                child: Material(
                  elevation: isDark ? 0 : 8,
                  color: dropdownBg,
                  borderRadius: BorderRadius.circular(20),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    height: dropdownHeight,
                    decoration: BoxDecoration(
                      color: dropdownBg,
                      borderRadius: BorderRadius.circular(20),
                      border: isDark ? Border.all(color: const Color(0xFF2C2C2E)) : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.showSearch)
                          SizedBox(
                            height: searchFieldHeight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                autofocus: true,
                                style: TextStyle(fontSize: 14, color: isDark ? Colors.white : AppColors.textDark),
                                decoration: InputDecoration(
                                  hintText: 'Search shapes...',
                                  hintStyle: TextStyle(color: isDark ? Colors.white70 : AppColors.textLight),
                                  prefixIcon: Icon(Icons.search, size: 20, color: isDark ? Colors.white70 : AppColors.textLight),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: isDark ? const Color(0xFF2C2C2E) : AppColors.divider),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: primaryColor),
                                  ),
                                ),
                                onChanged: _filter,
                              ),
                            ),
                          ),
                        Flexible(
                          child: _filteredOptions.isEmpty
                              ? SizedBox(
                                  height: itemHeight,
                                  child: Center(
                                    child: Text(
                                      'No results found',
                                      style: TextStyle(
                                        color: isDark ? Colors.white70 : AppColors.textLight,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                              : Scrollbar(
                                  controller: _scrollController,
                                  thumbVisibility: true,
                                  thickness: 4.0,
                                  radius: const Radius.circular(2.0),
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    padding: EdgeInsets.zero,
                                    itemCount: _filteredOptions.length,
                                    itemExtent: itemHeight,
                                    physics: const ClampingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final option = _filteredOptions[index];
                                      final isSelected = option == widget.selectedShape;

                                      return GestureDetector(
                                        onTap: () {
                                          _close(() => widget.onSelected(option));
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: SizedBox(
                                          height: itemHeight,
                                          child: Container(
                                            color: isSelected
                                                ? primaryColor.withValues(alpha: 0.15)
                                                : Colors.transparent,
                                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  option.type == MeasurementType.area
                                                      ? Icons.category_rounded
                                                      : Icons.view_in_ar_rounded,
                                                  size: 20,
                                                  color: isSelected ? primaryColor : (isDark ? Colors.white54 : Colors.black54),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    option.name,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                                      color: isSelected ? primaryColor : unselectedNameColor,
                                                    ),
                                                  ),
                                                ),
                                                if (isSelected)
                                                  Icon(
                                                    Icons.check,
                                                    color: primaryColor,
                                                    size: 20,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
