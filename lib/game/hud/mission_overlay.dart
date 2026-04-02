import 'package:flutter/material.dart';

import '../saving_persia_game.dart';

class MissionOverlay extends StatelessWidget {
  const MissionOverlay({super.key, required this.game});

  final SavingPersiaGame game;
  static const String id = 'mission';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder<GameUiState>(
        valueListenable: game.uiState,
        builder: (context, state, child) {
          return Stack(
            children: [
              Positioned(
                left: 12,
                top: 12,
                right: 12,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xCC0F172A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF334155),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Mission: Save Persia',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.objective,
                                style: const TextStyle(
                                  color: Color(0xFFE2E8F0),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                state.status,
                                style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Scarves',
                              style: TextStyle(
                                color: Color(0xFFFDE68A),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${state.collectedCount}/${state.totalCollectibles}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (state.phase != GamePhase.playing)
                Center(
                  child: Container(
                    width: 260,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xEE111827),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: state.phase == GamePhase.won
                            ? const Color(0xFF22C55E)
                            : const Color(0xFFEF4444),
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.phase == GamePhase.won
                              ? 'Persia Rescued'
                              : 'Mission Failed',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          state.status,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFE5E7EB),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 18),
                        FilledButton(
                          onPressed: game.restart,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Restart Run'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
