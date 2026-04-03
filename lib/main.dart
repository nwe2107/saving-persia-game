import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/hud/controls_overlay.dart';
import 'game/hud/mission_overlay.dart';
import 'game/saving_persia_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SavingPersiaApp());
}

class SavingPersiaApp extends StatefulWidget {
  const SavingPersiaApp({super.key});

  @override
  State<SavingPersiaApp> createState() => _SavingPersiaAppState();
}

class _SavingPersiaAppState extends State<SavingPersiaApp> {
  late final SavingPersiaGame _game = SavingPersiaGame();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: AspectRatio(
                aspectRatio: SavingPersiaGame.viewportWidth /
                    SavingPersiaGame.viewportHeight,
                child: GameWidget<SavingPersiaGame>(game: _game),
              ),
            ),
            MissionOverlay(game: _game),
            ControlsOverlay(game: _game),
          ],
        ),
      ),
    );
  }
}
