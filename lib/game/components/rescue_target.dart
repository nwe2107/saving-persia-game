import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class RescueTarget extends PositionComponent {
  RescueTarget({required Vector2 position})
      : super(
          position: position,
          size: Vector2(20, 20),
          anchor: Anchor.topLeft,
        );

  bool isRescued = false;

  final Paint _fillPaint = Paint()..color = const Color(0xFF22C55E);
  final Paint _rescuedPaint = Paint()..color = const Color(0xFF38BDF8);
  final Paint _outlinePaint = Paint()
    ..color = const Color(0xFFDCFCE7)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  final Paint _visorPaint = Paint()..color = const Color(0xFF0F172A);

  Rect get rect => Rect.fromLTWH(position.x, position.y, size.x, size.y);

  void rescue() {
    isRescued = true;
  }

  void reset() {
    isRescued = false;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      TextComponent(
        text: 'PERSIA',
        position: Vector2(size.x / 2, -4),
        anchor: Anchor.bottomCenter,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 6,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(5),
    );
    canvas.drawRRect(body, isRescued ? _rescuedPaint : _fillPaint);
    canvas.drawRRect(body, _outlinePaint);

    final visor = RRect.fromRectAndRadius(
      Rect.fromLTWH(4, 4, size.x - 8, 5),
      const Radius.circular(3),
    );
    canvas.drawRRect(visor, _visorPaint);

    canvas.drawRect(
      Rect.fromLTWH(6, 11, size.x - 12, 5),
      _visorPaint,
    );
  }
}
