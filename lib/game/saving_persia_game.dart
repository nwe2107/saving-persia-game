import 'package:flame/camera.dart';
import 'package:flame/extensions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'components/collectible.dart';
import 'components/level.dart';
import 'components/player.dart';

enum GamePhase { playing, won, lost }

class GameUiState {
  const GameUiState({
    required this.phase,
    required this.collectedCount,
    required this.totalCollectibles,
    required this.objective,
    required this.status,
  });

  final GamePhase phase;
  final int collectedCount;
  final int totalCollectibles;
  final String objective;
  final String status;
}

class SavingPersiaGame extends FlameGame with KeyboardEvents {
  static const double worldWidth = 640;
  static const double worldHeight = 180;
  static const double viewportWidth = 320;
  static const double viewportHeight = 180;

  final Level level = Level(
    size: Vector2(worldWidth, worldHeight),
    spawnPoint: Vector2(32, worldHeight - 48),
  );
  late final Player player;
  final ValueNotifier<GameUiState> uiState = ValueNotifier(
    const GameUiState(
      phase: GamePhase.playing,
      collectedCount: 0,
      totalCollectibles: 0,
      objective: 'Collect the scarves and rescue Persia.',
      status: 'Move with arrows or A/D. Jump with space.',
    ),
  );

  double _horizontalInput = 0;
  bool _jumpQueued = false;
  GamePhase _phase = GamePhase.playing;
  int _collectedCount = 0;
  String _status = 'Move with arrows or A/D. Jump with space.';

  bool get isPlaying => _phase == GamePhase.playing;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(viewportWidth, viewportHeight),
    );

    await add(level);
    player = Player();
    player.position = level.spawnPoint.clone();
    await add(player);

    camera.setBounds(
      Rect.fromLTWH(0, 0, worldWidth, worldHeight).toFlameRectangle(),
      considerViewport: true,
    );
    camera.follow(player, snap: true);

    _syncUiState();
  }

  void setHorizontalInput(double input) {
    if (!isPlaying) {
      return;
    }
    _horizontalInput = input.clamp(-1.0, 1.0);
  }

  void queueJump() {
    if (!isPlaying) {
      return;
    }
    _jumpQueued = true;
  }

  void collectScarf(Collectible collectible) {
    if (!isPlaying || collectible.isCollected) {
      return;
    }

    collectible.collect();
    _collectedCount += 1;

    final remaining = level.totalCollectibles - _collectedCount;
    _status = remaining == 0
        ? 'All scarves secured. Reach Persia.'
        : 'Scarf secured. $remaining left.';
    _syncUiState();
  }

  void tryRescuePersia() {
    if (!isPlaying) {
      return;
    }

    final remaining = level.totalCollectibles - _collectedCount;
    if (remaining > 0) {
      _status = remaining == 1
          ? 'Need 1 more scarf before Persia can move.'
          : 'Need $remaining more scarves before Persia can move.';
      _syncUiState();
      return;
    }

    _finish(
      phase: GamePhase.won,
      status: 'Persia is safe. Mission complete.',
    );
  }

  void playerLost(String status) {
    if (!isPlaying) {
      return;
    }

    _finish(
      phase: GamePhase.lost,
      status: status,
    );
  }

  void restart() {
    level.reset();
    player.resetTo(level.spawnPoint);

    _phase = GamePhase.playing;
    _horizontalInput = 0;
    _jumpQueued = false;
    _collectedCount = 0;
    _status = 'Collect the scarves and rescue Persia.';

    resumeEngine();
    _syncUiState();
  }

  @override
  void update(double dt) {
    player.applyInput(
      horizontalInput: _horizontalInput,
      jumpRequested: _jumpQueued,
    );
    _jumpQueued = false;
    super.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final left = keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA);
    final right = keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD);

    setHorizontalInput((right ? 1 : 0) + (left ? -1 : 0));

    if (event is KeyDownEvent) {
      final isJumpKey = event.logicalKey == LogicalKeyboardKey.space ||
          event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.keyW;
      if (isJumpKey) {
        queueJump();
      }
    }

    return KeyEventResult.handled;
  }

  @override
  void onRemove() {
    uiState.dispose();
    super.onRemove();
  }

  void _finish({
    required GamePhase phase,
    required String status,
  }) {
    _phase = phase;
    _horizontalInput = 0;
    _jumpQueued = false;
    _status = status;
    player.stop();
    pauseEngine();
    _syncUiState();
  }

  void _syncUiState() {
    uiState.value = GameUiState(
      phase: _phase,
      collectedCount: _collectedCount,
      totalCollectibles: level.totalCollectibles,
      objective: _buildObjective(),
      status: _status,
    );
  }

  String _buildObjective() {
    if (_phase == GamePhase.won) {
      return 'Persia rescued.';
    }

    if (_phase == GamePhase.lost) {
      return 'Reset and try the route again.';
    }

    if (_collectedCount >= level.totalCollectibles) {
      return 'Reach Persia and complete the rescue.';
    }

    return 'Collect ${level.totalCollectibles} scarves and rescue Persia.';
  }
}
