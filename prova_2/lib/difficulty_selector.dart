import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'difficulty_manager.dart';

class DifficultyButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const DifficultyButton({
    super.key,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: isSelected ? 3 : 1),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: color.withOpacity(0.6),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                  : null,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.pressStart2p(
              color: isSelected ? color : color.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}

class DifficultySelector extends StatelessWidget {
  final GameDifficulty currentDifficulty;
  final Function(GameDifficulty) onDifficultyChanged;

  const DifficultySelector({
    super.key,
    required this.currentDifficulty,
    required this.onDifficultyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'dificuldade:',
            style: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                GameDifficulty.values.map((difficulty) {
                  final config = DifficultyManager.getConfig(difficulty);
                  final isSelected = currentDifficulty == difficulty;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: DifficultyButton(
                        label: config.label,
                        color: config.color,
                        isSelected: isSelected,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          onDifficultyChanged(difficulty);
                        },
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            DifficultyManager.getConfig(currentDifficulty).description,
            style: GoogleFonts.pressStart2p(
              color: DifficultyManager.getConfig(currentDifficulty).color,
              fontSize: 8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
