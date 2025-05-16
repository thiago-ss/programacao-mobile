# principais métodos/classes

_generateHintMessage -> método pra gerar dica

GameScreen -> widget principal

método build em _GameScreenState -> constrói a tela do jogo, com o gradiente, header, grid dos botões e os botões de ação

ArcadeButton -> classe dos botões numerados com o estilo arcade

ArcadeActionButton -> classe dos botões de ação com o estilo arcade (novo jogos, recordes)

GridView.builder dentro do método build em _GameScreenState -> cria o grid de botões

DifficultySelector -> botões pra escolher a dificuldade

DifficultyButton -> classe do botão pra escolher dificuldade

LeaderboardScreen -> tela da tabela de recordes

método build em _LeaderboardScreenState -> constrói o layout da tabela de recordes

NameInputDialog -> dialog pra escrever o nome quando faz uma nova pontuação

ParticleSystem -> cria as partículas

método build em _ParticleSystemState -> renderiza as partículas na tela

ShinyEffect -> efeito de brilho no título

ShinyText -> texto com brilho na tela de recordes

AnimatedBuilder no método build em _GameScreenState -> cria a animação da mensagem

# lógica

## incialização

```dart
void startNewGame() {
  final random = Random();
  final Set<int> numbers = {}; 
  
  while (numbers.length < 3) {
    numbers.add(random.nextInt(difficultyConfig.totalButtons) + 1);
  }
  
  treasureNumber = numbersAsList[0]; 
  bombNumber = numbersAsList[1];     
  monsterNumber = numbersAsList[2];  
}
```

Set pra garantir que tesouro, bomba e monstro sejam únicos  
todo botão começa habilitado mostrando o número

## cliques

```dart
void handleButtonPress(int number) {
  if (gameOver) return;
  
  if (number == treasureNumber) {
    score += 100 * level * difficultyConfig.scoreMultiplier;
    gameOver = true;
  } 
  else if (number == bombNumber || number == monsterNumber) {
    gameOver = true;
  } 
  else {
    message = _generateHintMessage(number);
  }
}
```

verifica se o número clicado é o tesouro, a bomba, o monstro ou um número normal  
cada resultado tem uma ação diferente no estado  
jogo termina quando encontra um dos três

## dicas

```dart
String _generateHintMessage(int number) {
  if (!difficultyConfig.showDetailedHints) {
    return "tente outro numero...";
  }
  
  if (difficultyConfig.showExactHints) {
    if (treasureNumber > number) {
      return "o tesouro esta em um numero maior que number";
    } else {
      return "o tesouro esta em um numero menor que number";
    }
  } else {
    final int difference = (treasureNumber - number).abs();
    final int maxDifference = difficultyConfig.totalButtons ~/ 2;
    
    if (difference < maxDifference / 3) {
      return "esta muito perto!";
    } else if (difference < maxDifference / 2) {
      return "esta perto...";
    } else {
      return "esta longe...";
    }
  }
}
```

calcula a diferença entre o número clicado e o tesouro para determinar a proximidade

## pontuação

```dart
score += 100 * level * difficultyConfig.scoreMultiplier;
```

pontuação base -> 100 pontos  
a pontuação aumenta de acordo com o nível  
multiplicada pelo fator dificuldade  
mais dificuldade = mais pontos

## recordes

```dart
Future<void> _checkAndSaveHighScore() async {
  if (await ScoreManager.isHighScore(score, difficulty)) {
    final playerName = await showDialog<String>(/* ... */);
    if (playerName != null) {
      final playerScore = PlayerScore(
        playerName: playerName,
        score: score,
        level: level,
        difficulty: difficulty,
        date: DateTime.now(),
      );
      await ScoreManager.saveScore(playerScore);
    }
  }
}
```

verifica se a pontuação atual é alta o suficiente para entrar na tabela de recordes  
se verdadeiro, pede o nome do jogador  
salva a pontuação com as informações relevantes

## armazenamento de recordes

```dart
static Future<bool> saveScore(PlayerScore score) async {
  final prefs = await SharedPreferences.getInstance();
  final scores = await getScores();
  
  scores.add(score);
  
  scores.sort(/* ... */);
  
  final filteredScores = <PlayerScore>[];
  final countByDifficulty = <GameDifficulty, int>{};
  
  for (final s in scores) {
    countByDifficulty[s.difficulty] = (countByDifficulty[s.difficulty] ?? 0) + 1;
    if (countByDifficulty[s.difficulty]! <= _maxScoresPerDifficulty) {
      filteredScores.add(s);
    }
  }
  
  final jsonScores = filteredScores.map((s) => jsonEncode(s.toJson())).toList();
  return await prefs.setStringList(_scoresKey, jsonScores);
}
```

converte os objetos da pontuação em JSON  
mantém os 10 melhores por dificuldade  
usa a lib SharedPreferences pra armazenar os dados nas sessões

## gerenciamento da dificuldade

```dart
static const Map<GameDifficulty, DifficultyConfig> configurations = {
  GameDifficulty.easy: DifficultyConfig(
    gridSize: 20,
    totalButtons: 20,
    columns: 4,
    showDetailedHints: true,
    showExactHints: true,
    scoreMultiplier: 1,
  ),
  GameDifficulty.medium: DifficultyConfig(/* ... */),
  GameDifficulty.hard: DifficultyConfig(/* ... */),
};
```

cada dificuldade tem sua própria configuração  
muda o número de botões, dicas, pontuação e layout  
quando o jogador escolhe a dificuldade, o jogo ajusta os parâmetros