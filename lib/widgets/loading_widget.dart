import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({
    this.size = 24,
    this.strokeWidth,
    this.centered = true,
    super.key,
  });

  final double size;
  final double? strokeWidth;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    if (centered) {
      return Center(
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
            ),
          ),
        ),
      );
    }
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
      ),
    );
  }
}
