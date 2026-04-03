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
    required this.persiaRescued,
  });

  final GamePhase phase;
  final int collectedCount;
  final int totalCollectibles;
  final String objective;
  final String status;
  final bool persiaRescued;
}

class SavingPersiaGame extends FlameGame with KeyboardEvents {
  static const double worldWidth = 640;
  static const double worldHeight = 360;
  static const double viewportWidth = 320;
  static const double viewportHeight = 180;

  final Level level = Level(
    size: Vector2(worldWidth, worldHeight),
    spawnPoint: Vector2(32, 316),
  );
  late final Player player;
  final ValueNotifier<GameUiState> uiState = ValueNotifier(
    const GameUiState(
      phase: GamePhase.playing,
      collectedCount: 0,
      totalCollectibles: 0,
      objective: 'Collect the scarves, free Persia, then reach the van.',
      status: 'Use the D-pad or WASD. Avoid patrol guards.',
      persiaRescued: false,
    ),
  );

  double _horizontalInput = 0;
  double _verticalInput = 0;
  GamePhase _phase = GamePhase.playing;
  int _collectedCount = 0;
  bool _persiaRescued = false;
  String _status = 'Use the D-pad or WASD. Avoid patrol guards.';

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

  void setMovementInput({
    required double horizontal,
    required double vertical,
  }) {
    if (!isPlaying) {
      return;
    }

    _horizontalInput = horizontal.clamp(-1.0, 1.0);
    _verticalInput = vertical.clamp(-1.0, 1.0);
  }

  void collectScarf(Collectible collectible) {
    if (!isPlaying || collectible.isCollected) {
      return;
    }

    collectible.collect();
    _collectedCount += 1;

    final remaining = level.totalCollectibles - _collectedCount;
    _setStatus(
      remaining == 0
          ? 'All scarves secured. Reach Persia.'
          : 'Crew scarf secured. $remaining left.',
    );
  }

  void tryRescuePersia() {
    if (!isPlaying) {
      return;
    }

    if (_persiaRescued) {
      return;
    }

    final remaining = level.totalCollectibles - _collectedCount;
    if (remaining > 0) {
      _setStatus(
        remaining == 1
            ? 'Need 1 more scarf before Persia can move.'
            : 'Need $remaining more scarves before Persia can move.',
      );
      return;
    }

    _persiaRescued = true;
    level.rescueTarget.rescue();
    level.extractionZone.activate();
    _setStatus('Persia is with you. Reach the van.');
  }

  void tryExtract() {
    if (!isPlaying) {
      return;
    }

    if (!_persiaRescued) {
      _setStatus('Find Persia before heading to the van.');
      return;
    }

    _finish(
      phase: GamePhase.won,
      status: 'Persia is clear. Extraction complete.',
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
    _verticalInput = 0;
    _collectedCount = 0;
    _persiaRescued = false;
    _status = 'Use the D-pad or WASD. Avoid patrol guards.';

    resumeEngine();
    _syncUiState();
  }

  @override
  void update(double dt) {
    player.applyInput(
      horizontalInput: _horizontalInput,
      verticalInput: _verticalInput,
    );
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
    final up = keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW);
    final down = keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS);

    setMovementInput(
      horizontal: (right ? 1 : 0) + (left ? -1 : 0),
      vertical: (down ? 1 : 0) + (up ? -1 : 0),
    );

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
    _verticalInput = 0;
    _status = status;
    player.stop();
    pauseEngine();
    _syncUiState();
  }

  void _setStatus(String status) {
    if (_status == status) {
      return;
    }

    _status = status;
    _syncUiState();
  }

  void _syncUiState() {
    uiState.value = GameUiState(
      phase: _phase,
      collectedCount: _collectedCount,
      totalCollectibles: level.totalCollectibles,
      objective: _buildObjective(),
      status: _status,
      persiaRescued: _persiaRescued,
    );
  }

  String _buildObjective() {
    if (_phase == GamePhase.won) {
      return 'Persia extracted.';
    }

    if (_phase == GamePhase.lost) {
      return 'Reset and run the route again.';
    }

    if (_persiaRescued) {
      return 'Reach the van and extract Persia.';
    }

    if (_collectedCount >= level.totalCollectibles) {
      return 'Reach Persia and get him out.';
    }

    return 'Collect ${level.totalCollectibles} scarves, free Persia, then extract.';
  }
}
