import 'package:flutter/material.dart';

class DifficultyConfig {
  final int gridSize;
  final int totalButtons;
  final int columns;
  final bool showDetailedHints;
  final bool showExactHints;
  final int scoreMultiplier;
  final String label;
  final Color color;
  final String description;

  const DifficultyConfig({
    required this.gridSize,
    required this.totalButtons,
    required this.columns,
    required this.showDetailedHints,
    required this.showExactHints,
    required this.scoreMultiplier,
    required this.label,
    required this.color,
    required this.description,
  });
}

class DifficultyManager {
  static const Map<GameDifficulty, DifficultyConfig> configurations = {
    GameDifficulty.easy: DifficultyConfig(
      gridSize: 20,
      totalButtons: 20,
      columns: 4,
      showDetailedHints: true,
      showExactHints: true,
      scoreMultiplier: 1,
      label: "facil",
      color: Colors.green,
      description: "20 numeros, dicas completas",
    ),
    GameDifficulty.medium: DifficultyConfig(
      gridSize: 30,
      totalButtons: 30,
      columns: 5,
      showDetailedHints: true,
      showExactHints: false,
      scoreMultiplier: 2,
      label: "medio",
      color: Colors.orange,
      description: "30 numeros, dicas limitadas",
    ),
    GameDifficulty.hard: DifficultyConfig(
      gridSize: 42,
      totalButtons: 42,
      columns: 6,
      showDetailedHints: false,
      showExactHints: false,
      scoreMultiplier: 3,
      label: "dificil",
      color: Colors.red,
      description: "42 numeros, dicas minimas",
    ),
  };

  static DifficultyConfig getConfig(GameDifficulty difficulty) {
    return configurations[difficulty]!;
  }
}

enum GameDifficulty { easy, medium, hard }
