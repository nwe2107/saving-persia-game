import 'dart:ui';

import 'package:flame/components.dart';

class Collectible extends PositionComponent {
  Collectible({required Vector2 position})
      : super(
          position: position,
          size: Vector2.all(12),
          anchor: Anchor.topLeft,
        );

  final Paint _fillPaint = Paint()..color = const Color(0xFFFBBF24);
  final Paint _outlinePaint = Paint()
    ..color = const Color(0xFFFFF7D6)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  bool isCollected = false;

  Rect get rect => Rect.fromLTWH(position.x, position.y, size.x, size.y);

  void collect() {
    isCollected = true;
  }

  void reset() {
    isCollected = false;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (isCollected) {
      return;
    }

    final path = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(size.x, size.y / 2)
      ..lineTo(size.x / 2, size.y)
      ..lineTo(0, size.y / 2)
      ..close();

    canvas.drawPath(path, _fillPaint);
    canvas.drawPath(path, _outlinePaint);
  }
}
