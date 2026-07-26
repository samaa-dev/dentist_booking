import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Scales layout values against a Full HD TV design baseline (1920×1080).
extension TvScaleX on BuildContext {
  static const double _designWidth = 1920;
  static const double _designHeight = 1080;
  static const double _minScale = 0.65;
  static const double _maxScale = 1.35;

  double get tvScale {
    final size = MediaQuery.sizeOf(this);
    final scale = math.min(
      size.width / _designWidth,
      size.height / _designHeight,
    );
    return scale.clamp(_minScale, _maxScale);
  }

  double s(double value) => value * tvScale;
}
