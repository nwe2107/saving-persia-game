import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class ExtractionZone extends PositionComponent {
  ExtractionZone({required Vector2 position})
      : super(
          position: position,
          size: Vector2(44, 28),
          anchor: Anchor.topLeft,
        );

  bool isActive = false;

  final Paint _basePaint = Paint()..color = const Color(0xFF0F172A);
  final Paint _inactivePaint = Paint()..color = const Color(0xFF475569);
  final Paint _activePaint = Paint()..color = const Color(0xFF38BDF8);
  final Paint _outlinePaint = Paint()
    ..color = const Color(0xFFDBEAFE)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  Rect get rect => Rect.fromLTWH(position.x, position.y, size.x, size.y);

  void activate() {
    isActive = true;
  }

  void reset() {
    isActive = false;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      TextComponent(
        text: 'VAN',
        position: Vector2(size.x / 2, size.y / 2),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 8,
            fontWeight: FontWeight.w800,
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
      const Radius.circular(8),
    );
    canvas.drawRRect(body, _basePaint);

    final padPaint = isActive ? _activePaint : _inactivePaint;
    for (var index = 0; index < 3; index++) {
      canvas.drawRect(
        Rect.fromLTWH(6 + (index * 12), 6, 8, size.y - 12),
        padPaint,
      );
    }

    canvas.drawRRect(body, _outlinePaint);
  }
}
