import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'difficulty_manager.dart';

class PlayerScore {
  final String playerName;
  final int score;
  final int level;
  final GameDifficulty difficulty;
  final DateTime date;

  PlayerScore({
    required this.playerName,
    required this.score,
    required this.level,
    required this.difficulty,
    required this.date,
  });

  factory PlayerScore.fromJson(Map<String, dynamic> json) {
    return PlayerScore(
      playerName: json['playerName'],
      score: json['score'],
      level: json['level'],
      difficulty: GameDifficulty.values[json['difficulty']],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'score': score,
      'level': level,
      'difficulty': difficulty.index,
      'date': date.millisecondsSinceEpoch,
    };
  }
}

class ScoreManager {
  static const String _scoresKey = 'player_scores';
  static const int _maxScoresPerDifficulty = 10;

  // Limpar todas as pontuações
  static Future<bool> clearScores() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_scoresKey);
  }

  // Obter todas as pontuações
  static Future<List<PlayerScore>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonScores = prefs.getStringList(_scoresKey) ?? [];

    return jsonScores
        .map((jsonString) => PlayerScore.fromJson(jsonDecode(jsonString)))
        .toList();
  }

  // Obter as melhores pontuações para uma dificuldade específica
  static Future<List<PlayerScore>> getTopScoresForDifficulty(
    GameDifficulty difficulty,
  ) async {
    final allScores = await getScores();

    // Filtrar por dificuldade e ordenar por pontuação (decrescente)
    final filteredScores =
        allScores.where((score) => score.difficulty == difficulty).toList()
          ..sort((a, b) => b.score.compareTo(a.score));

    // Retornar apenas as melhores pontuações
    return filteredScores.take(_maxScoresPerDifficulty).toList();
  }

  // Verificar se uma pontuação está entre as melhores
  static Future<bool> isHighScore(int score, GameDifficulty difficulty) async {
    final topScores = await getTopScoresForDifficulty(difficulty);

    if (topScores.length < _maxScoresPerDifficulty) {
      return true; // Ainda há espaço na tabela
    }

    // Verificar se a pontuação é maior que a menor pontuação na tabela
    return score > topScores.last.score;
  }

  // Salvar uma nova pontuação
  static Future<bool> saveScore(PlayerScore score) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = await getScores();

    // Adicionar a nova pontuação
    scores.add(score);

    // Ordenar as pontuações por dificuldade e pontuação (decrescente)
    scores.sort((a, b) {
      final diffComparison = a.difficulty.index.compareTo(b.difficulty.index);
      if (diffComparison != 0) return diffComparison;
      return b.score.compareTo(a.score); // Ordem decrescente de pontuação
    });

    // Filtrar para manter apenas as melhores pontuações por dificuldade
    final filteredScores = <PlayerScore>[];
    final countByDifficulty = <GameDifficulty, int>{};

    for (final s in scores) {
      countByDifficulty[s.difficulty] =
          (countByDifficulty[s.difficulty] ?? 0) + 1;
      if (countByDifficulty[s.difficulty]! <= _maxScoresPerDifficulty) {
        filteredScores.add(s);
      }
    }

    // Salvar as pontuações filtradas
    final jsonScores =
        filteredScores.map((s) => jsonEncode(s.toJson())).toList();
    return await prefs.setStringList(_scoresKey, jsonScores);
  }
}
