import 'dart:ui';

import 'package:flame/components.dart';

import '../saving_persia_game.dart';

class Player extends RectangleComponent
    with HasGameReference<SavingPersiaGame> {
  Player()
      : super(
          size: Vector2(16, 24),
          anchor: Anchor.topLeft,
        ) {
    paint = Paint()..color = const Color(0xFFEF4444);
  }

  final Vector2 _velocity = Vector2.zero();
  double _horizontalInput = 0;
  bool _jumpRequested = false;
  bool _isOnGround = false;

  static const double _moveSpeed = 90;
  static const double _jumpSpeed = 280;
  static const double _gravity = 900;
  static const double _maxFallSpeed = 520;

  void applyInput({
    required double horizontalInput,
    required bool jumpRequested,
  }) {
    _horizontalInput = horizontalInput;
    if (jumpRequested) {
      _jumpRequested = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    _velocity.x = _horizontalInput * _moveSpeed;

    if (_jumpRequested && _isOnGround) {
      _velocity.y = -_jumpSpeed;
      _isOnGround = false;
    }
    _jumpRequested = false;

    _velocity.y += _gravity * dt;
    if (_velocity.y > _maxFallSpeed) {
      _velocity.y = _maxFallSpeed;
    }

    _moveAndCollide(dt);
    _checkWorldInteractions();

    if (position.y > game.level.size.y + size.y) {
      game.playerLost('You fell off the route.');
    }
  }

  void _moveAndCollide(double dt) {
    position.x += _velocity.x * dt;
    _resolveHorizontalCollisions();

    position.y += _velocity.y * dt;
    _resolveVerticalCollisions();

    _clampToWorld();
  }

  void _resolveHorizontalCollisions() {
    for (final platform in game.level.platforms) {
      if (!_intersects(platform.rect)) {
        continue;
      }

      if (_velocity.x > 0) {
        position.x = platform.position.x - size.x;
      } else if (_velocity.x < 0) {
        position.x = platform.position.x + platform.size.x;
      }
      _velocity.x = 0;
    }
  }

  void _resolveVerticalCollisions() {
    _isOnGround = false;
    for (final platform in game.level.platforms) {
      if (!_intersects(platform.rect)) {
        continue;
      }

      if (_velocity.y > 0) {
        position.y = platform.position.y - size.y;
        _isOnGround = true;
      } else if (_velocity.y < 0) {
        position.y = platform.position.y + platform.size.y;
      }
      _velocity.y = 0;
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
      _velocity.y = 0;
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

    for (final hazard in game.level.hazards) {
      if (_intersects(hazard.rect)) {
        game.playerLost('The defense shut down the rescue.');
        return;
      }
    }

    if (_intersects(game.level.rescueTarget.rect)) {
      game.tryRescuePersia();
    }
  }

  void stop() {
    _velocity.setZero();
    _horizontalInput = 0;
    _jumpRequested = false;
  }

  void resetTo(Vector2 spawnPoint) {
    position.setFrom(spawnPoint);
    stop();
    _isOnGround = false;
  }
}
