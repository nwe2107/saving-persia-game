import 'dart:ui';

import 'package:flame/components.dart';

import 'collectible.dart';
import 'extraction_zone.dart';
import 'guard.dart';
import 'rescue_target.dart';
import 'wall_block.dart';

class Level extends Component {
  Level({
    required this.size,
    required this.spawnPoint,
  });

  final Vector2 size;
  final Vector2 spawnPoint;
  final List<WallBlock> walls = [];
  final List<Guard> guards = [];
  final List<Collectible> collectibles = [];
  late final RescueTarget rescueTarget;
  late final ExtractionZone extractionZone;

  final Paint _floorPaint = Paint()..color = const Color(0xFF111827);
  final Paint _lanePaint = Paint()..color = const Color(0xFF1F2937);
  final Paint _gridPaint = Paint()
    ..color = const Color(0x223B82F6)
    ..strokeWidth = 1;

  int get totalCollectibles => collectibles.length;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    walls.addAll([
      WallBlock(
        position: Vector2(112, 24),
        size: Vector2(18, 220),
      ),
      WallBlock(
        position: Vector2(112, 24),
        size: Vector2(184, 18),
      ),
      WallBlock(
        position: Vector2(278, 24),
        size: Vector2(18, 120),
      ),
      WallBlock(
        position: Vector2(278, 126),
        size: Vector2(182, 18),
      ),
      WallBlock(
        position: Vector2(442, 126),
        size: Vector2(18, 174),
      ),
      WallBlock(
        position: Vector2(170, 282),
        size: Vector2(290, 18),
      ),
      WallBlock(
        position: Vector2(334, 218),
        size: Vector2(58, 44),
      ),
      WallBlock(
        position: Vector2(508, 48),
        size: Vector2(60, 38),
      ),
      WallBlock(
        position: Vector2(52, 192),
        size: Vector2(46, 48),
      ),
    ]);

    guards.addAll([
      Guard(
        startPoint: Vector2(154, 304),
        endPoint: Vector2(154, 188),
      ),
      Guard(
        startPoint: Vector2(326, 92),
        endPoint: Vector2(420, 92),
      ),
      Guard(
        startPoint: Vector2(530, 248),
        endPoint: Vector2(530, 152),
      ),
    ]);

    collectibles.addAll([
      Collectible(position: Vector2(66, 92)),
      Collectible(position: Vector2(228, 74)),
      Collectible(position: Vector2(516, 226)),
    ]);

    rescueTarget = RescueTarget(
      position: Vector2(550, 98),
    );
    extractionZone = ExtractionZone(
      position: Vector2(22, 300),
    );

    addAll([
      ...walls,
      ...guards,
      ...collectibles,
      rescueTarget,
      extractionZone,
    ]);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      _floorPaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(24, 48, 72, 256),
      _lanePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(132, 48, 128, 60),
      _lanePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(296, 48, 116, 60),
      _lanePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(296, 146, 128, 118),
      _lanePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(478, 106, 126, 176),
      _lanePaint,
    );

    for (double x = 0; x <= size.x; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.y), _gridPaint);
    }
    for (double y = 0; y <= size.y; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.x, y), _gridPaint);
    }
  }

  void reset() {
    for (final collectible in collectibles) {
      collectible.reset();
    }
    for (final guard in guards) {
      guard.reset();
    }
    rescueTarget.reset();
    extractionZone.reset();
  }
}
