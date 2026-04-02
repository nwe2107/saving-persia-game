import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/hud/controls_overlay.dart';
import 'game/hud/mission_overlay.dart';
import 'game/saving_persia_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SavingPersiaApp());
}

class SavingPersiaApp extends StatelessWidget {
  const SavingPersiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget<SavingPersiaGame>(
          game: SavingPersiaGame(),
          overlayBuilderMap: {
            ControlsOverlay.id: (context, game) => ControlsOverlay(game: game),
            MissionOverlay.id: (context, game) => MissionOverlay(game: game),
          },
          initialActiveOverlays: const [
            ControlsOverlay.id,
            MissionOverlay.id,
          ],
        ),
      ),
    );
  }
}
