import 'dart:ui';

import 'package:flame/components.dart';

import '../saving_persia_game.dart';

class Player extends PositionComponent with HasGameReference<SavingPersiaGame> {
  Player()
      : super(
          size: Vector2.all(18),
          anchor: Anchor.topLeft,
        );

  final Vector2 _velocity = Vector2.zero();
  final Vector2 _movementInput = Vector2.zero();

  static const double _moveSpeed = 86;

  final Paint _bodyPaint = Paint()..color = const Color(0xFFEF4444);
  final Paint _detailPaint = Paint()..color = const Color(0xFF7F1D1D);
  final Paint _outlinePaint = Paint()
    ..color = const Color(0xFFFEE2E2)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  void applyInput({
    required double horizontalInput,
    required double verticalInput,
  }) {
    _movementInput.setValues(horizontalInput, verticalInput);
    if (_movementInput.length2 > 1) {
      _movementInput.normalize();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    _velocity
      ..setFrom(_movementInput)
      ..scale(_moveSpeed);

    _moveAndCollide(dt);
    _checkWorldInteractions();
  }

  void _moveAndCollide(double dt) {
    position.x += _velocity.x * dt;
    _resolveWallCollisions(horizontal: true);

    position.y += _velocity.y * dt;
    _resolveWallCollisions(horizontal: false);

    _clampToWorld();
  }

  void _resolveWallCollisions({required bool horizontal}) {
    for (final wall in game.level.walls) {
      if (!_intersects(wall.rect)) {
        continue;
      }

      if (horizontal) {
        if (_velocity.x > 0) {
          position.x = wall.position.x - size.x;
        } else if (_velocity.x < 0) {
          position.x = wall.position.x + wall.size.x;
        }
      } else {
        if (_velocity.y > 0) {
          position.y = wall.position.y - size.y;
        } else if (_velocity.y < 0) {
          position.y = wall.position.y + wall.size.y;
        }
      }
    }
  }

  void _clampToWorld() {
    if (position.x < 0) {
      position.x = 0;
    } else if (position.x + size.x > game.level.size.x) {
      position.x = game.level.size.x - size.x;
    }

    if (position.y < 0) {
      position.y = 0;
    } else if (position.y + size.y > game.level.size.y) {
      position.y = game.level.size.y - size.y;
    }
  }

  bool _intersects(Rect other) {
    return _bounds.overlaps(other);
  }

  Rect get _bounds => Rect.fromLTWH(position.x, position.y, size.x, size.y);

  void _checkWorldInteractions() {
    for (final collectible in game.level.collectibles) {
      if (!collectible.isCollected && _intersects(collectible.rect)) {
        game.collectScarf(collectible);
      }
    }

    for (final guard in game.level.guards) {
      if (_intersects(guard.rect)) {
        game.playerLost('A patrol guard caught the rescue team.');
        return;
      }
    }

    if (_intersects(game.level.rescueTarget.rect)) {
      game.tryRescuePersia();
    }

    if (_intersects(game.level.extractionZone.rect)) {
      game.tryExtract();
    }
  }

  void stop() {
    _velocity.setZero();
    _movementInput.setZero();
  }

  void resetTo(Vector2 spawnPoint) {
    position.setFrom(spawnPoint);
    stop();
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
      Rect.fromLTWH(5, 10, size.x - 10, 5),
      _detailPaint,
    );
  }
}
