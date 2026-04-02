import 'package:flame/components.dart';

import 'collectible.dart';
import 'hazard.dart';
import 'platform_block.dart';
import 'rescue_target.dart';

class Level extends Component {
  Level({
    required this.size,
    required this.spawnPoint,
  });

  final Vector2 size;
  final Vector2 spawnPoint;
  final List<PlatformBlock> platforms = [];
  final List<Hazard> hazards = [];
  final List<Collectible> collectibles = [];
  late final RescueTarget rescueTarget;

  int get totalCollectibles => collectibles.length;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    platforms.addAll([
      PlatformBlock(
        position: Vector2(0, size.y - 16),
        size: Vector2(size.x, 16),
      ),
      PlatformBlock(
        position: Vector2(88, size.y - 48),
        size: Vector2(72, 12),
      ),
      PlatformBlock(
        position: Vector2(196, size.y - 76),
        size: Vector2(68, 12),
      ),
      PlatformBlock(
        position: Vector2(314, size.y - 104),
        size: Vector2(72, 12),
      ),
      PlatformBlock(
        position: Vector2(438, size.y - 76),
        size: Vector2(60, 12),
      ),
      PlatformBlock(
        position: Vector2(532, size.y - 92),
        size: Vector2(80, 12),
      ),
    ]);

    hazards.addAll([
      Hazard(
        position: Vector2(166, size.y - 28),
        size: Vector2(32, 12),
      ),
      Hazard(
        position: Vector2(342, size.y - 116),
        size: Vector2(24, 12),
      ),
      Hazard(
        position: Vector2(404, size.y - 28),
        size: Vector2(36, 12),
      ),
    ]);

    collectibles.addAll([
      Collectible(position: Vector2(118, size.y - 70)),
      Collectible(position: Vector2(224, size.y - 98)),
      Collectible(position: Vector2(462, size.y - 98)),
    ]);

    rescueTarget = RescueTarget(
      position: Vector2(560, size.y - 120),
    );

    addAll([
      ...platforms,
      ...hazards,
      ...collectibles,
      rescueTarget,
    ]);
  }

  void reset() {
    for (final collectible in collectibles) {
      collectible.reset();
    }
  }
}
