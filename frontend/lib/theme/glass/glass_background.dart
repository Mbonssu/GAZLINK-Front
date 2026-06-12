import 'dart:ui';

import 'package:flutter/material.dart';

import 'glass_constants.dart';

class GlassBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? gradient;

  const GlassBackground({
    super.key,
    required this.child,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = gradient ?? GlassConstants.backgroundGradient(brightness);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          fit: StackFit.expand,
          children: [
            AnimatedContainer(
              duration: GlassConstants.motionMedium,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                ),
              ),
            ),
            _BlurOrb(
              left: -width * 0.20,
              top: -height * 0.05,
              size: width * 0.62,
              color: Colors.white.withValues(alpha: 0.18),
            ),
            _BlurOrb(
              right: -width * 0.15,
              top: height * 0.20,
              size: width * 0.55,
              color: GlassConstants.accent.withValues(alpha: 0.18),
            ),
            _BlurOrb(
              right: width * 0.05,
              bottom: -height * 0.10,
              size: width * 0.55,
              color: const Color(0xFFFFA86A).withValues(alpha: 0.20),
            ),
            child,
          ],
        );
      },
    );
  }
}

class _BlurOrb extends StatelessWidget {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double size;
  final Color color;

  const _BlurOrb({
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: GlassConstants.strongBlur * 2,
            sigmaY: GlassConstants.strongBlur * 2,
          ),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
