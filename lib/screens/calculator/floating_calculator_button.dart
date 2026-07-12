import 'package:flutter/material.dart';

class FloatingCalculatorButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isVisible;

  const FloatingCalculatorButton({
    super.key,
    required this.onTap,
    this.isVisible = true,
  });

  @override
  State<FloatingCalculatorButton> createState() => _FloatingCalculatorButtonState();
}

class _FloatingCalculatorButtonState extends State<FloatingCalculatorButton> with SingleTickerProviderStateMixin {
  // Coordinates of the button
  double _x = 0;
  double _y = 250; // Default vertical position
  bool _isDragging = false;
  bool _isLeft = false; // Whether it is docked to the left edge

  // Animation controller for snapping effect
  late AnimationController _snapController;
  late Animation<double> _snapAnimation;
  double _snapStartX = 0;
  double _snapEndX = 0;

  final double _buttonWidth = 45;
  final double _buttonHeight = 56;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _snapAnimation = CurvedAnimation(
      parent: _snapController,
      curve: Curves.easeOutBack,
    )..addListener(() {
        setState(() {
          _x = _snapStartX + (_snapEndX - _snapStartX) * _snapAnimation.value;
        });
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Position the button on the right edge by default if not set
    if (_x == 0 && !_isLeft) {
      final screenWidth = MediaQuery.of(context).size.width;
      _x = screenWidth - _buttonWidth;
    }
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _snapController.stop();
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    setState(() {
      _x += details.delta.dx;
      _y += details.delta.dy;

      // Constrain within screen boundaries
      _x = _x.clamp(0.0, size.width - _buttonWidth);
      _y = _y.clamp(topPadding + 20.0, size.height - bottomPadding - _buttonHeight - 80.0);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final midpoint = screenWidth / 2;

    _snapStartX = _x;
    if (_x + (_buttonWidth / 2) < midpoint) {
      _snapEndX = 0; // Snap to left edge
      _isLeft = true;
    } else {
      _snapEndX = screenWidth - _buttonWidth; // Snap to right edge
      _isLeft = false;
    }

    setState(() {
      _isDragging = false;
    });

    _snapController.reset();
    _snapController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    // Outer border radius depending on which edge it is docked to
    final borderRadius = _isLeft
        ? const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          );

    return Positioned(
      left: _x,
      top: _y,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isDragging ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Material(
            elevation: _isDragging ? 12 : 6,
            shadowColor: const Color(0xFFEC4899).withValues(alpha: 0.4),
            borderRadius: borderRadius,
            child: Container(
              width: _buttonWidth,
              height: _buttonHeight,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: const LinearGradient(
                  colors: [Color(0xFFEC4899), Color(0xFFD946EF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Pulsing background glow decoration
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEC4899).withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                    ),
                  ),
                  // Sleek White Inner Circle containing Calculator Icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.calculate_rounded,
                      size: 20,
                      color: Color(0xFFD946EF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
