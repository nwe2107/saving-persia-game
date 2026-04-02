import 'dart:ui';

import 'package:flame/components.dart';

class Hazard extends PositionComponent {
  Hazard({
    required super.position,
    required super.size,
  });

  final Paint _fillPaint = Paint()..color = const Color(0xFFDC2626);
  final Paint _outlinePaint = Paint()
    ..color = const Color(0xFFFECACA)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  Rect get rect => Rect.fromLTWH(position.x, position.y, size.x, size.y);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final spikeWidth = size.x / 3;
    for (var index = 0; index < 3; index++) {
      final left = spikeWidth * index;
      final path = Path()
        ..moveTo(left, size.y)
        ..lineTo(left + (spikeWidth / 2), 0)
        ..lineTo(left + spikeWidth, size.y)
        ..close();

      canvas.drawPath(path, _fillPaint);
      canvas.drawPath(path, _outlinePaint);
    }
  }
}
