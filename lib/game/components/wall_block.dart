import 'dart:ui';

import 'package:flame/components.dart';

class WallBlock extends RectangleComponent {
  WallBlock({
    required super.position,
    required super.size,
  }) {
    paint = Paint()..color = const Color(0xFF334155);
  }

  Rect get rect => Rect.fromLTWH(position.x, position.y, size.x, size.y);
}
