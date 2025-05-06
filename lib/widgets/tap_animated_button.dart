import 'package:flutter/material.dart';

class TapAnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const TapAnimatedButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<TapAnimatedButton> createState() => _TapAnimatedButtonState();
}

class _TapAnimatedButtonState extends State<TapAnimatedButton> {
  double _scale = 1.0;

  void _animateDown() {
    setState(() => _scale = 0.95);
  }

  void _animateUp() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animateDown(),
      onTapUp: (_) {
        _animateUp();
        Future.delayed(
          Duration(milliseconds: 100),
          widget.onTap,
        ); // Delay navigation
      },
      onTapCancel: _animateUp,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
