import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import 'calculator_state.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            flex: 30,
                            child: _DisplayAreaWidget(),
                          ),
                          _ChevronToggleWidget(),
                          Expanded(
                            flex: 80,
                            child: _KeypadWidget(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DisplayAreaWidget extends ConsumerWidget {
  const _DisplayAreaWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (expression, result, isCalculated, isScientific) = ref.watch(
      floatingCalculatorProvider.select((s) => (s.expression, s.result, s.isCalculated, s.isScientific)),
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: isScientific ? 1.0 : 0.0, end: isScientific ? 1.0 : 0.0),
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
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: isCalculated ? 0 : 0),
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
                                fontFamily: 'Roboto',
                                fontSize: isCalculated ? 42 : 105,
                                fontWeight: FontWeight.normal,
                                color: isDark
                                    ? (isCalculated ? const Color(0xFFF5F5F5).withValues(alpha: 0.7) : Colors.white)
                                    : (isCalculated ? AppColors.textSecondaryLight : AppColors.textPrimaryLight),
                              ),
                              child: Text(
                                expression.isEmpty ? '0' : (expression + (isCalculated ? ' =' : '')),
                              ),
                            ),
                            if (!isCalculated) ...[
                              const SizedBox(width: 2),
                              const RepaintBoundary(child: BlinkingCursor()),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
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
                          fontFamily: 'Roboto',
                          fontSize: isCalculated ? 85 : 48,
                          fontWeight: FontWeight.normal,
                          color: isCalculated
                              ? (isDark ? Colors.white : AppColors.textPrimaryLight)
                              : (isDark ? Colors.white70 : const Color(0xFF6E4D60)),
                        ),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: result.isEmpty ? 0.0 : 1.0,
                          child: Text(result),
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
}

class _ChevronToggleWidget extends ConsumerWidget {
  const _ChevronToggleWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isScientific = ref.watch(floatingCalculatorProvider.select((s) => s.isScientific));
    final notifier = ref.read(floatingCalculatorProvider.notifier);
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
}

class _KeypadWidget extends ConsumerWidget {
  const _KeypadWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (isScientific, isDegree, isInverse) = ref.watch(
      floatingCalculatorProvider.select((s) => (s.isScientific, s.isDegree, s.isInverse)),
    );
    final notifier = ref.read(floatingCalculatorProvider.notifier);
    const double keyPadding = 2.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;
        final sciTargetHeight = totalHeight * (3 / 8);

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: isScientific ? 1.0 : 0.0, end: isScientific ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          builder: (context, t, child) {
            final sciHeight = t * sciTargetHeight;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
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
                              _KeySpec(isDegree ? 'Rad' : 'Deg', tagText: isDegree ? 'DEG' : 'RAD', action: notifier.toggleDegree),
                              _KeySpec(isInverse ? 'sin⁻¹' : 'sin', action: () => notifier.append(isInverse ? 'asin' : 'sin')),
                              _KeySpec(isInverse ? 'cos⁻¹' : 'cos', action: () => notifier.append(isInverse ? 'acos' : 'cos')),
                              _KeySpec(isInverse ? 'tan⁻¹' : 'tan', action: () => notifier.append(isInverse ? 'atan' : 'tan')),
                            ], keyPadding, isSci: true)),
                            Expanded(child: _buildKeyRow([
                              _KeySpec(isInverse ? 'eˣ' : 'ln', action: () => notifier.append(isInverse ? 'e^' : 'ln')),
                              _KeySpec(isInverse ? '10ˣ' : 'log', action: () => notifier.append(isInverse ? '10^' : 'log')),
                              _KeySpec('e', action: () => notifier.append('e')),
                              _KeySpec('Inv', tagText: isInverse ? 'ON' : null, action: notifier.toggleInverse),
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
    super.key,
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
