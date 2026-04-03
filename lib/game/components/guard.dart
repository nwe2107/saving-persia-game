import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class Guard extends PositionComponent {
  Guard({
    required this.startPoint,
    required this.endPoint,
    this.speed = 42,
  }) : super(
          position: startPoint.clone(),
          size: Vector2.all(18),
          anchor: Anchor.topLeft,
        );

  final Vector2 startPoint;
  final Vector2 endPoint;
  final double speed;

  bool _towardsEnd = true;

  final Paint _bodyPaint = Paint()..color = const Color(0xFFF97316);
  final Paint _detailPaint = Paint()..color = const Color(0xFF7C2D12);
  final Paint _outlinePaint = Paint()
    ..color = const Color(0xFFFED7AA)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  Rect get rect => Rect.fromLTWH(position.x, position.y, size.x, size.y);

  @override
  void update(double dt) {
    super.update(dt);

    final target = _towardsEnd ? endPoint : startPoint;
    final delta = target - position;
    final distance = delta.length;
    if (distance <= speed * dt) {
      position.setFrom(target);
      _towardsEnd = !_towardsEnd;
      return;
    }

    delta.normalize();
    position += delta..scale(speed * dt);
  }

  void reset() {
    position.setFrom(startPoint);
    _towardsEnd = true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(6),
    );
    canvas.drawRRect(body, _bodyPaint);
    canvas.drawRRect(body, _outlinePaint);

    canvas.drawRect(
      Rect.fromLTWH(4, 4, size.x - 8, 4),
      _detailPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(6, 10, size.x - 12, 5),
      _detailPaint,
    );
  }
}
