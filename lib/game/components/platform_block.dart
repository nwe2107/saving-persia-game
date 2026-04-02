import 'dart:ui';

import 'package:flame/components.dart';

class PlatformBlock extends RectangleComponent {
  PlatformBlock({
    required super.position,
    required super.size,
  }) {
    paint = Paint()..color = const Color(0xFF4B5563);
  }

  Rect get rect => Rect.fromLTWH(position.x, position.y, size.x, size.y);
}
