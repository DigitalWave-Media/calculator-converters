import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/unit_option.dart';

class UnitPickerDropdown {
  static OverlayEntry? _currentOverlay;
  static _DropdownOverlayContentState? _currentState;

  static void show({
    required BuildContext context,
    required LayerLink layerLink,
    required List<UnitOption> options,
    required UnitOption selectedUnit,
    required Function(UnitOption) onSelected,
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
          selectedUnit: selectedUnit,
          onSelected: (unit) {
            onSelected(unit);
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
}

class _DropdownOverlayContent extends StatefulWidget {
  final LayerLink layerLink;
  final List<UnitOption> options;
  final UnitOption selectedUnit;
  final ValueChanged<UnitOption> onSelected;
  final VoidCallback onDismiss;
  final double width;
  final Offset offset;
  final bool showSearch;

  const _DropdownOverlayContent({
    required this.layerLink,
    required this.options,
    required this.selectedUnit,
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
  late List<UnitOption> _filteredOptions;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    UnitPickerDropdown._currentState = this;
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
    if (UnitPickerDropdown._currentState == this) {
      UnitPickerDropdown._currentState = null;
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
          .where((opt) =>
              opt.name.toLowerCase().contains(query.toLowerCase()) ||
              opt.abbreviation.toLowerCase().contains(query.toLowerCase()))
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
    final unselectedAbbrColor = isDark ? Colors.white70 : AppColors.textLight;

    return Stack(
      children: [
        // Dimmed background barrier
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
        // Dropdown card positioned relative to the target field
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
                                  hintText: 'Search...',
                                  hintStyle: TextStyle(color: unselectedAbbrColor),
                                  prefixIcon: Icon(Icons.search, size: 20, color: unselectedAbbrColor),
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
                                        color: unselectedAbbrColor,
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
                                      final isSelected = option == widget.selectedUnit;

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
                                                Expanded(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                                        color: isSelected ? primaryColor : unselectedNameColor,
                                                      ),
                                                      children: [
                                                        TextSpan(text: option.name),
                                                        const TextSpan(text: ' '),
                                                        TextSpan(
                                                          text: option.abbreviation,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                                                            color: isSelected
                                                                ? primaryColor
                                                                : unselectedAbbrColor,
                                                          ),
                                                        ),
                                                      ],
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
