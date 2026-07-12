import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import 'calculator_state.dart';

class FloatingCalculatorOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final bool isOpen;

  const FloatingCalculatorOverlay({
    super.key,
    required this.onClose,
    required this.isOpen,
  });

  @override
  State<FloatingCalculatorOverlay> createState() => _FloatingCalculatorOverlayState();
}

class _FloatingCalculatorOverlayState extends State<FloatingCalculatorOverlay> with SingleTickerProviderStateMixin {
  // Animation controller for slide-in / slide-out of the calculator
  late AnimationController _transitionController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeOutCubic,
    ));

    if (widget.isOpen) {
      _transitionController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant FloatingCalculatorOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _transitionController.forward();
      } else {
        _transitionController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOpen && _transitionController.isDismissed) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned.fill(
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          elevation: 24,
          color: isDark ? const Color(0xFF121214) : const Color(0xFFF9F9FC),
          child: SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Consumer(
                  builder: (context, ref, child) {
                    final calcState = ref.watch(floatingCalculatorProvider);
                    final notifier = ref.read(floatingCalculatorProvider.notifier);

                    return Column(
                      children: [
                        // 1. Header with history icon and close button
                        _buildHeaderBar(context, notifier),

                        // 2. Main content area (Stack)
                        Expanded(
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  // Display Area — smaller flex pushes keypad up
                                  Expanded(
                                    flex: 25,
                                    child: _buildDisplayArea(context, calcState),
                                  ),

                                  // Chevron toggle (Static Anchor)
                                  _buildChevronToggle(context, notifier, calcState.isScientific),

                                  // Keypad — larger flex stretches grid upward
                                  Expanded(
                                    flex: 75,
                                    child: _buildKeypad(context, calcState, notifier),
                                  ),
                                ],
                              ),

                              // History Overlay Panel
                              _HistoryOverlay(
                                isOpen: calcState.isHistoryOpen,
                                history: calcState.history,
                                onClearHistory: notifier.clearHistory,
                                onTapItem: notifier.loadHistoryItem,
                                onClose: () {
                                  if (calcState.isHistoryOpen) {
                                    notifier.toggleHistory();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // HEADER BAR WIDGET
  Widget _buildHeaderBar(BuildContext context, FloatingCalculatorNotifier notifier) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close / Back Button (Replaces old Menu)
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 24),
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: widget.onClose,
          ),

          // History Toggle Button (Moved to top right)
          IconButton(
            icon: const Icon(Icons.history_rounded, size: 24),
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              notifier.toggleHistory();
            },
          ),
        ],
      ),
    );
  }

  // DISPLAY AREA WIDGET
  Widget _buildDisplayArea(BuildContext context, FloatingCalculatorState calcState) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: calcState.isScientific ? 1.0 : 0.0, end: calcState.isScientific ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, sciT, child) {
        return Align(
          alignment: Alignment.topCenter,
          child: FractionallySizedBox(
            heightFactor: 1.0 - (sciT * 0.15),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 24, right: 24, top: 4, bottom: 8),
              color: Colors.transparent,
              child: Stack(
                children: [
                  // EXPRESSION TEXT — pinned to top-right, larger & bold
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    alignment: calcState.isCalculated ? Alignment.topRight : Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: calcState.isCalculated ? 0 : 0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                              style: TextStyle(
                                fontSize: calcState.isCalculated ? 28 : 75,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? (calcState.isCalculated ? AppColors.textSecondaryDark : AppColors.textPrimaryDark)
                                    : (calcState.isCalculated ? AppColors.textSecondaryLight : AppColors.textPrimaryLight),
                              ),
                              child: Text(
                                calcState.expression.isEmpty ? '0' : (calcState.expression + (calcState.isCalculated ? ' =' : '')),
                              ),
                            ),
                            if (!calcState.isCalculated) ...[
                              const SizedBox(width: 2),
                              const BlinkingCursor(),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  // RESULT TEXT
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.bottomRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomRight,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        style: TextStyle(
                          fontSize: calcState.isCalculated ? 60 : 32,
                          fontWeight: calcState.isCalculated ? FontWeight.w700 : FontWeight.w500,
                          color: calcState.isCalculated
                              ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                              : (isDark ? const Color(0xFFC9A6BA) : const Color(0xFF6E4D60)),
                        ),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: calcState.result.isEmpty ? 0.0 : 1.0,
                          child: Text(calcState.result),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // History panel helper removed in favor of custom _HistoryOverlay component

  // KEYPAD EXPANDER CHEVRON
  Widget _buildChevronToggle(BuildContext context, FloatingCalculatorNotifier notifier, bool isScientific) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: notifier.toggleScientific,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: AnimatedRotation(
            turns: isScientific ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 28,
              color: isDark ? Colors.white70 : const Color(0xFF555555),
            ),
          ),
        ),
      ),
    );
  }

  // KEYPAD WIDGET
  Widget _buildKeypad(
    BuildContext context, 
    FloatingCalculatorState calcState, 
    FloatingCalculatorNotifier notifier,
  ) {
    const double keyPadding = 6.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;
        final sciTargetHeight = totalHeight * (3 / 8);

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: calcState.isScientific ? 1.0 : 0.0, end: calcState.isScientific ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          builder: (context, t, child) {
            final sciHeight = t * sciTargetHeight;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: sciHeight,
                    child: ClipRect(
                      child: OverflowBox(
                        alignment: Alignment.bottomCenter,
                        minHeight: sciTargetHeight,
                        maxHeight: sciTargetHeight,
                        child: Column(
                          children: [
                            Expanded(child: _buildKeyRow([
                              _KeySpec('√', action: () => notifier.append('√')),
                              _KeySpec('π', action: () => notifier.append('π')),
                              _KeySpec('^', action: () => notifier.append('^')),
                              _KeySpec('!', action: () => notifier.append('!')),
                            ], keyPadding, isSci: true)),
                            Expanded(child: _buildKeyRow([
                              _KeySpec(calcState.isDegree ? 'Rad' : 'Deg', tagText: calcState.isDegree ? 'DEG' : 'RAD', action: notifier.toggleDegree),
                              _KeySpec(calcState.isInverse ? 'sin⁻¹' : 'sin', action: () => notifier.append(calcState.isInverse ? 'asin' : 'sin')),
                              _KeySpec(calcState.isInverse ? 'cos⁻¹' : 'cos', action: () => notifier.append(calcState.isInverse ? 'acos' : 'cos')),
                              _KeySpec(calcState.isInverse ? 'tan⁻¹' : 'tan', action: () => notifier.append(calcState.isInverse ? 'atan' : 'tan')),
                            ], keyPadding, isSci: true)),
                            Expanded(child: _buildKeyRow([
                              _KeySpec(calcState.isInverse ? 'eˣ' : 'ln', action: () => notifier.append(calcState.isInverse ? 'e^' : 'ln')),
                              _KeySpec(calcState.isInverse ? '10ˣ' : 'log', action: () => notifier.append(calcState.isInverse ? '10^' : 'log')),
                              _KeySpec('e', action: () => notifier.append('e')),
                              _KeySpec('Inv', tagText: calcState.isInverse ? 'ON' : null, action: notifier.toggleInverse),
                            ], keyPadding, isSci: true)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        Expanded(child: _buildKeyRow([
                          _KeySpec('AC', isDanger: true, action: notifier.clearAll),
                          _KeySpec('()', isOperator: true, action: notifier.appendParentheses),
                          _KeySpec('%', isOperator: true, action: () => notifier.append('%')),
                          _KeySpec('÷', isOperator: true, action: () => notifier.append('÷')),
                        ], keyPadding)),
                        Expanded(child: _buildKeyRow([
                          _KeySpec('7', action: () => notifier.append('7')),
                          _KeySpec('8', action: () => notifier.append('8')),
                          _KeySpec('9', action: () => notifier.append('9')),
                          _KeySpec('×', isOperator: true, action: () => notifier.append('×')),
                        ], keyPadding)),
                        Expanded(child: _buildKeyRow([
                          _KeySpec('4', action: () => notifier.append('4')),
                          _KeySpec('5', action: () => notifier.append('5')),
                          _KeySpec('6', action: () => notifier.append('6')),
                          _KeySpec('−', isOperator: true, action: () => notifier.append('−')),
                        ], keyPadding)),
                        Expanded(child: _buildKeyRow([
                          _KeySpec('1', action: () => notifier.append('1')),
                          _KeySpec('2', action: () => notifier.append('2')),
                          _KeySpec('3', action: () => notifier.append('3')),
                          _KeySpec('+', isOperator: true, action: () => notifier.append('+')),
                        ], keyPadding)),
                        Expanded(child: _buildKeyRow([
                          _KeySpec('0', action: () => notifier.append('0')),
                          _KeySpec('.', action: () => notifier.append('.')),
                          _KeySpec('backspace', isIcon: true, icon: Icons.backspace_outlined, action: notifier.backspace),
                          _KeySpec('=', isEqual: true, action: notifier.calculate),
                        ], keyPadding)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Row builder for layout grid — enforces circular buttons via AspectRatio
  Widget _buildKeyRow(List<_KeySpec> keys, double padding, {bool isSci = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding / 2),
      child: Row(
        children: keys.map((key) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding / 2),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: _CalculatorKeyButton(
                  spec: key,
                  isSci: isSci,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Key Specification Model
class _KeySpec {
  final String label;
  final bool isOperator;
  final bool isDanger;
  final bool isEqual;
  final bool isIcon;
  final IconData? icon;
  final VoidCallback action;
  final String? tagText;

  _KeySpec(
    this.label, {
    this.isOperator = false,
    this.isDanger = false,
    this.isEqual = false,
    this.isIcon = false,
    this.icon,
    this.tagText,
    required this.action,
  });
}

// Custom Animated Button for Keyboard Keys
class _CalculatorKeyButton extends StatefulWidget {
  final _KeySpec spec;
  final bool isSci;

  const _CalculatorKeyButton({
    required this.spec,
    required this.isSci,
  });

  @override
  State<_CalculatorKeyButton> createState() => _CalculatorKeyButtonState();
}

class _CalculatorKeyButtonState extends State<_CalculatorKeyButton> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color? bgColor;
    Color? textColor;

    if (widget.spec.isEqual) {
      bgColor = isDark ? const Color(0xFF8C627A) : const Color(0xFF6E4D60);
      textColor = Colors.white;
    } else if (widget.spec.isDanger) {
      bgColor = isDark ? const Color(0xFF2C3246) : const Color(0xFFD9E2FC);
      textColor = isDark ? const Color(0xFF90CAF9) : const Color(0xFF1B2B65);
    } else if (widget.spec.isOperator || widget.isSci) {
      bgColor = isDark ? const Color(0xFF2C3246) : const Color(0xFFD9E2FC);
      textColor = isDark ? const Color(0xFFE2E6F2) : const Color(0xFF0F172A);
    } else {
      bgColor = isDark ? const Color(0xFF212529) : const Color(0xFFE9ECF4);
      textColor = isDark ? const Color(0xFFECEFF1) : const Color(0xFF0F172A);
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) {
          _animController.forward();
        },
        onTapUp: (_) {
          _animController.reverse();
          widget.spec.action();
        },
        onTapCancel: () {
          _animController.reverse();
        },
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              if (!isDark && !widget.isSci)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                )
            ],
          ),
          alignment: Alignment.center,
          child: widget.spec.isIcon
              ? Icon(
                  widget.spec.icon,
                  size: 28,
                  color: textColor,
                )
              : (widget.spec.tagText != null)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.spec.label,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: widget.spec.tagText == 'DEG'
                                ? const Color(0xFF8B5CF6).withValues(alpha: 0.12)
                                : const Color(0xFF10B981).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.spec.tagText!,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: widget.spec.tagText == 'DEG'
                                  ? const Color(0xFF8B5CF6)
                                  : const Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      widget.spec.label,
                      style: TextStyle(
                        fontSize: widget.isSci ? 18 : 30,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
        ),
      ),
    );
  }
}

// Custom Blinking Cursor Widget for active text editing appearance
class BlinkingCursor extends StatefulWidget {
  const BlinkingCursor({super.key});

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 2.2,
        height: 65,
        color: isDark ? const Color(0xFF90CAF9) : const Color(0xFF4C5D8B),
      ),
    );
  }
}

class _GroupedHistory {
  final String title;
  final List<HistoryItem> items;

  _GroupedHistory(this.title, this.items);
}

class _HistoryOverlay extends StatefulWidget {
  final bool isOpen;
  final List<HistoryItem> history;
  final VoidCallback onClearHistory;
  final ValueChanged<HistoryItem> onTapItem;
  final VoidCallback onClose;

  const _HistoryOverlay({
    required this.isOpen,
    required this.history,
    required this.onClearHistory,
    required this.onTapItem,
    required this.onClose,
  });

  @override
  State<_HistoryOverlay> createState() => _HistoryOverlayState();
}

class _HistoryOverlayState extends State<_HistoryOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  double _dragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    _controller.addListener(() {
      setState(() {});
    });

    if (widget.isOpen) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant _HistoryOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    _dragOffset += details.primaryDelta ?? 0.0;
    final dragFraction = _dragOffset / (screenHeight * 0.7);
    _controller.value = (1.0 + dragFraction).clamp(0.0, 1.0);
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    final double velocity = details.primaryVelocity ?? 0.0;
    if (_controller.value < 0.75 || velocity < -300) {
      widget.onClose();
    } else {
      _controller.forward();
    }
    _dragOffset = 0.0;
  }

  List<_GroupedHistory> _groupHistory(List<HistoryItem> history) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final List<HistoryItem> todayItems = [];
    final List<HistoryItem> yesterdayItems = [];
    final List<HistoryItem> earlierItems = [];

    for (final item in history) {
      final itemDate = DateTime(item.timestamp.year, item.timestamp.month, item.timestamp.day);
      if (itemDate == today) {
        todayItems.add(item);
      } else if (itemDate == yesterday) {
        yesterdayItems.add(item);
      } else {
        earlierItems.add(item);
      }
    }

    final List<_GroupedHistory> groups = [];
    if (todayItems.isNotEmpty) {
      groups.add(_GroupedHistory('Today', todayItems));
    }
    if (yesterdayItems.isNotEmpty) {
      groups.add(_GroupedHistory('Yesterday', yesterdayItems));
    }
    if (earlierItems.isNotEmpty) {
      groups.add(_GroupedHistory('Earlier', earlierItems));
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final bool isVisible = widget.isOpen || !_controller.isDismissed;
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final panelBgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);
    final shadowColor = Colors.black.withValues(alpha: isDark ? 0.3 : 0.08);

    return Positioned.fill(
      child: Stack(
        children: [
          IgnorePointer(
            ignoring: _controller.value == 0.0,
            child: GestureDetector(
              onTap: widget.onClose,
              child: Opacity(
                opacity: _controller.value * 0.4,
                child: Container(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          FractionalTranslation(
            translation: _slideAnimation.value - Offset.zero,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                decoration: BoxDecoration(
                  color: panelBgColor,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Expanded(
                      child: widget.history.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.history_toggle_off_rounded,
                                    size: 48,
                                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No history yet',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _buildGroupedList(isDark),
                    ),
                    GestureDetector(
                      onVerticalDragUpdate: _handleVerticalDragUpdate,
                      onVerticalDragEnd: _handleVerticalDragEnd,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        alignment: Alignment.center,
                        child: Container(
                          width: 48,
                          height: 5,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white24 : Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedList(bool isDark) {
    final groups = _groupHistory(widget.history);

    return ListView.builder(
      itemCount: groups.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemBuilder: (context, groupIndex) {
        final group = groups[groupIndex];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8, left: 8),
              child: Text(
                group.title.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                ),
              ),
            ),
            ...group.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => widget.onTapItem(item),
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              item.expression,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '= ${item.result}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: isDark ? const Color(0xFFC9A6BA) : const Color(0xFF6E4D60),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
