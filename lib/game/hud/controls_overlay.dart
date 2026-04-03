import 'package:flutter/material.dart';

import '../saving_persia_game.dart';

class ControlsOverlay extends StatefulWidget {
  const ControlsOverlay({super.key, required this.game});

  final SavingPersiaGame game;
  static const String id = 'controls';

  @override
  State<ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<ControlsOverlay> {
  bool _leftHeld = false;
  bool _rightHeld = false;
  bool _upHeld = false;
  bool _downHeld = false;

  void _updateMovementInput() {
    final horizontal = (_rightHeld ? 1 : 0) + (_leftHeld ? -1 : 0);
    final vertical = (_downHeld ? 1 : 0) + (_upHeld ? -1 : 0);
    widget.game.setMovementInput(
      horizontal: horizontal.toDouble(),
      vertical: vertical.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            left: 12,
            bottom: 12,
            child: Column(
              children: [
                _HoldButton(
                  icon: Icons.keyboard_arrow_up,
                  onPressed: () {
                    _upHeld = true;
                    _updateMovementInput();
                  },
                  onReleased: () {
                    _upHeld = false;
                    _updateMovementInput();
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _HoldButton(
                      icon: Icons.keyboard_arrow_left,
                      onPressed: () {
                        _leftHeld = true;
                        _updateMovementInput();
                      },
                      onReleased: () {
                        _leftHeld = false;
                        _updateMovementInput();
                      },
                    ),
                    const SizedBox(width: 12),
                    _HoldButton(
                      icon: Icons.keyboard_arrow_right,
                      onPressed: () {
                        _rightHeld = true;
                        _updateMovementInput();
                      },
                      onReleased: () {
                        _rightHeld = false;
                        _updateMovementInput();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _HoldButton(
                  icon: Icons.keyboard_arrow_down,
                  onPressed: () {
                    _downHeld = true;
                    _updateMovementInput();
                  },
                  onReleased: () {
                    _downHeld = false;
                    _updateMovementInput();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HoldButton extends StatelessWidget {
  const _HoldButton({
    required this.icon,
    required this.onPressed,
    required this.onReleased,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final VoidCallback onReleased;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      onTapUp: (_) => onReleased(),
      onTapCancel: onReleased,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
