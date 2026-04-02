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

  void _updateHorizontalInput() {
    final input = (_rightHeld ? 1 : 0) + (_leftHeld ? -1 : 0);
    widget.game.setHorizontalInput(input.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            left: 12,
            bottom: 12,
            child: Row(
              children: [
                _HoldButton(
                  icon: Icons.arrow_left,
                  onPressed: () {
                    _leftHeld = true;
                    _updateHorizontalInput();
                  },
                  onReleased: () {
                    _leftHeld = false;
                    _updateHorizontalInput();
                  },
                ),
                const SizedBox(width: 12),
                _HoldButton(
                  icon: Icons.arrow_right,
                  onPressed: () {
                    _rightHeld = true;
                    _updateHorizontalInput();
                  },
                  onReleased: () {
                    _rightHeld = false;
                    _updateHorizontalInput();
                  },
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: _HoldButton(
              icon: Icons.arrow_upward,
              onPressed: () => widget.game.queueJump(),
              onReleased: () {},
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
