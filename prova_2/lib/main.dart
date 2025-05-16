import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'difficulty_manager.dart';
import 'difficulty_selector.dart';
import 'leaderboard_screen.dart';
import 'name_input_dialog.dart';
import 'particle_system.dart';
import 'score_manager.dart';

// Ponto de entrada da aplicação
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

// Botão de ação estilo arcade
class ArcadeActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;

  const ArcadeActionButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color = const Color(0xFFFF00FF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            onPressed();
          },
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color, width: 3),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withOpacity(0.5)],
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.pressStart2p(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Botão estilo arcade
class ArcadeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool enabled;
  final bool isSpecial;
  final bool isSmall;

  const ArcadeButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.enabled,
    this.isSpecial = false,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    Color baseColor;
    Color glowColor;

    if (!enabled && text == '⬆️') {
      baseColor = Colors.blue;
      glowColor = Colors.blue;
    } else if (!enabled && text == '⬇️') {
      baseColor = Colors.orange;
      glowColor = Colors.orange;
    } else if (!enabled && text == '❌') {
      baseColor = Colors.grey;
      glowColor = Colors.grey;
    } else if (text == '🏆') {
      baseColor = Colors.amber;
      glowColor = Colors.yellow;
    } else if (text == '💣') {
      baseColor = Colors.red;
      glowColor = Colors.redAccent;
    } else if (text == '👾') {
      baseColor = Colors.purple;
      glowColor = Colors.purpleAccent;
    } else {
      baseColor = const Color(0xFF6200EA);
      glowColor = const Color(0xFFB388FF);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow:
            enabled || isSpecial
                ? [
                  BoxShadow(
                    color: glowColor.withOpacity(0.6),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: enabled || isSpecial ? baseColor : Colors.grey.shade800,
                width: 2,
              ),
              gradient:
                  enabled || isSpecial
                      ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [baseColor.withOpacity(0.3), Colors.black],
                      )
                      : null,
            ),
            child: Center(
              child: Text(
                text,
                style:
                    text.length > 2
                        ? GoogleFonts.pressStart2p(
                          color:
                              enabled || isSpecial ? Colors.white : Colors.grey,
                          fontSize: isSmall ? 8 : 12,
                        )
                        : TextStyle(fontSize: isSmall ? 18 : 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Classe para armazenar o estado de cada botão
class ButtonState {
  final int number;
  bool enabled;
  String display;

  ButtonState({
    required this.number,
    required this.enabled,
    required this.display,
  });
}

// Tela principal do jogo - StatefulWidget pois precisa gerenciar o estado do jogo
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

// Widget raiz da aplicação - StatelessWidget pois não precisa gerenciar estado
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Jogo',
      theme: ThemeData(
        primaryColor: const Color(0xFF6200EA),
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.pressStart2p(color: Colors.white),
          bodyLarge: GoogleFonts.pressStart2p(
            color: Colors.white,
            fontSize: 16,
          ),
          titleLarge: GoogleFonts.pressStart2p(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6200EA),
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.pressStart2p(),
          ),
        ),
      ),
      home: const GameScreen(), // Tela principal do jogo
      debugShowCheckedModeBanner: false,
    );
  }
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late int treasureNumber; // Número do tesouro
  late int bombNumber; // Número da bomba
  late int monsterNumber; // Número do monstro
  String message = "encontre o tesouro! cuidado com a bomba e o monstro.";
  bool gameOver = false;
  int score = 0;
  int highScore = 0;
  int level = 1;
  GameDifficulty difficulty = GameDifficulty.easy;
  late DifficultyConfig difficultyConfig;

  late AnimationController _buttonAnimController;
  late AnimationController _messageAnimController;

  // Adicionar variáveis para controlar as partículas
  bool _showParticles = false;
  ParticleType? _particleType;
  Offset _particlePosition = Offset.zero;

  List<ButtonState> buttonStates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF000000),
                  Color(0xFF1A0029),
                  Color(0xFF000000),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Cabeçalho do jogo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'nivel: $level',
                              style: GoogleFonts.pressStart2p(
                                color: Colors.amber,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'pontos: $score',
                              style: GoogleFonts.pressStart2p(
                                color: Colors.greenAccent,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        ShinyEffect(
                          child: Text(
                            'the\njogo',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.pressStart2p(
                              color: const Color(0xFFFF00FF),
                              fontSize: 14,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Seletor de dificuldade
                    DifficultySelector(
                      currentDifficulty: difficulty,
                      onDifficultyChanged: changeDifficulty,
                    ),

                    // Mensagem do jogo
                    AnimatedBuilder(
                      animation: _messageAnimController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 0.9 + (_messageAnimController.value * 0.1),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color:
                                    gameOver
                                        ? (treasureNumber ==
                                                buttonStates.indexWhere(
                                                      (b) => b.display == '🏆',
                                                    ) +
                                                    1
                                            ? Colors.greenAccent
                                            : Colors.redAccent)
                                        : const Color(0xFF00FFFF),
                                width: 2.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      gameOver
                                          ? (treasureNumber ==
                                                  buttonStates.indexWhere(
                                                        (b) =>
                                                            b.display == '🏆',
                                                      ) +
                                                      1
                                              ? Colors.greenAccent.withOpacity(
                                                0.5,
                                              )
                                              : Colors.redAccent.withOpacity(
                                                0.5,
                                              ))
                                          : const Color(
                                            0xFF00FFFF,
                                          ).withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Text(
                              message,
                              style: GoogleFonts.pressStart2p(
                                fontSize: 10.0,
                                color:
                                    gameOver
                                        ? (treasureNumber ==
                                                buttonStates.indexWhere(
                                                      (b) => b.display == '🏆',
                                                    ) +
                                                    1
                                            ? Colors.greenAccent
                                            : Colors.redAccent)
                                        : const Color(0xFF00FFFF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    // Grade de botões
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _buttonAnimController,
                        builder: (context, child) {
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: difficultyConfig.columns,
                                  childAspectRatio: 1.0,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                ),
                            itemCount: difficultyConfig.totalButtons,
                            itemBuilder: (context, index) {
                              final buttonState = buttonStates[index];
                              final delay =
                                  (index / difficultyConfig.totalButtons) * 0.5;
                              final animValue =
                                  _buttonAnimController.value > delay
                                      ? ((_buttonAnimController.value - delay) /
                                              (1 - delay))
                                          .clamp(0.0, 1.0)
                                      : 0.0;

                              return Transform.scale(
                                scale: animValue,
                                child: ArcadeButton(
                                  onPressed:
                                      buttonState.enabled
                                          ? () => handleButtonPress(index + 1)
                                          : null,
                                  text: buttonState.display,
                                  enabled: buttonState.enabled,
                                  isSpecial:
                                      buttonState.display == '🏆' ||
                                      buttonState.display == '💣' ||
                                      buttonState.display == '👾',
                                  isSmall: difficultyConfig.totalButtons > 30,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Botões de ação
                    Row(
                      children: [
                        // Botão de recordes
                        Expanded(
                          child: ArcadeActionButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => const LeaderboardScreen(),
                                ),
                              );
                            },
                            text: 'recordes',
                            color: const Color(0xFF00FFFF),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Botão de novo jogo
                        Expanded(
                          child: ArcadeActionButton(
                            onPressed: startNewGame,
                            text: 'novo jogo',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Pontuação máxima
                    Text(
                      'recorde: $highScore',
                      style: GoogleFonts.pressStart2p(
                        color: Colors.amber,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Sistema de partículas
          if (_showParticles && _particleType != null)
            // Usar um FutureBuilder para atrasar ligeiramente a renderização das partículas
            // e evitar jank durante a transição
            FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 50)),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox.shrink();
                }
                return ParticleSystem(
                  type: _particleType!,
                  position: _particlePosition,
                  onComplete: () {
                    setState(() {
                      _showParticles = false;
                    });
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  // Função para mudar a dificuldade
  void changeDifficulty(GameDifficulty newDifficulty) {
    setState(() {
      difficulty = newDifficulty;
      difficultyConfig = DifficultyManager.getConfig(difficulty);
    });
    _loadHighScore();
    startNewGame();
  }

  // Função para desabilitar todos os botões exceto os especiais
  void disableAllButtons() {
    for (var i = 0; i < buttonStates.length; i++) {
      if (i + 1 != treasureNumber &&
          i + 1 != bombNumber &&
          i + 1 != monsterNumber) {
        buttonStates[i].enabled = false;
      }
    }
  }

  @override
  void dispose() {
    _buttonAnimController.dispose();
    _messageAnimController.dispose();
    super.dispose();
  }

  // Função chamada quando um botão é pressionado
  void handleButtonPress(int number) {
    if (gameOver) return;

    HapticFeedback.mediumImpact();

    setState(() {
      if (number == treasureNumber) {
        message = "parabens! voce encontrou o tesouro!";
        buttonStates[number - 1].display = '🏆';
        gameOver = true;
        score += 100 * level * difficultyConfig.scoreMultiplier;

        // Verificar e salvar pontuação alta
        _checkAndSaveHighScore();

        level++;
        disableAllButtons();
        _showParticleEffect(number - 1, ParticleType.treasure);
      } else if (number == bombNumber) {
        message = "boom! voce encontrou a bomba! fim de jogo.";
        buttonStates[number - 1].display = '💣';
        gameOver = true;

        // Verificar e salvar pontuação alta antes de resetar
        _checkAndSaveHighScore();

        score = 0;
        level = 1;
        disableAllButtons();
        _showParticleEffect(number - 1, ParticleType.bomb);
      } else if (number == monsterNumber) {
        message = "argh! voce foi pego pelo monstro! fim de jogo.";
        buttonStates[number - 1].display = '👾';
        gameOver = true;

        // Verificar e salvar pontuação alta antes de resetar
        _checkAndSaveHighScore();

        score = 0;
        level = 1;
        disableAllButtons();
        _showParticleEffect(number - 1, ParticleType.monster);
      } else {
        message = _generateHintMessage(number);

        // Definir o ícone com base na dificuldade
        if (difficultyConfig.showExactHints) {
          if (treasureNumber > number) {
            buttonStates[number - 1].display = '⬆️';
          } else {
            buttonStates[number - 1].display = '⬇️';
          }
        } else {
          buttonStates[number - 1].display = '❌';
        }

        buttonStates[number - 1].enabled = false;
      }
    });

    _messageAnimController.reset();
    _messageAnimController.forward();
  }

  @override
  void initState() {
    super.initState();
    difficultyConfig = DifficultyManager.getConfig(difficulty);

    _buttonAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _messageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _loadHighScore();
    startNewGame(); // Inicia um novo jogo quando o aplicativo é aberto
  }

  // Função para iniciar um novo jogo
  void startNewGame() {
    final random = Random();
    final Set<int> numbers = {}; // Usa Set para garantir números únicos

    while (numbers.length < 3) {
      numbers.add(
        random.nextInt(difficultyConfig.totalButtons) + 1,
      ); // Gera número entre 1 e totalButtons
    }

    final numbersAsList = numbers.toList();
    treasureNumber = numbersAsList[0]; // Primeiro número é o tesouro
    bombNumber = numbersAsList[1]; // Segundo número é a bomba
    monsterNumber = numbersAsList[2]; // Terceiro número é o monstro

    setState(() {
      message = "encontre o tesouro! cuidado com a bomba e o monstro.";
      gameOver = false;
      buttonStates = List.generate(
        difficultyConfig.totalButtons,
        (index) => ButtonState(
          number: index + 1,
          enabled: true,
          display: '${index + 1}',
        ),
      );
      _showParticles = false;
    });

    _buttonAnimController.reset();
    _buttonAnimController.forward();
    _messageAnimController.reset();
    _messageAnimController.forward();

    print(
      'Tesouro: $treasureNumber, Bomba: $bombNumber, Monstro: $monsterNumber',
    );
  }

  // Função para verificar e salvar pontuação alta
  Future<void> _checkAndSaveHighScore() async {
    if (await ScoreManager.isHighScore(score, difficulty)) {
      // Mostrar diálogo para inserir nome
      final playerName = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) => NameInputDialog(score: score, level: level),
      );

      if (playerName != null) {
        // Salvar pontuação
        final playerScore = PlayerScore(
          playerName: playerName,
          score: score,
          level: level,
          difficulty: difficulty,
          date: DateTime.now(),
        );

        await ScoreManager.saveScore(playerScore);

        // Atualizar highScore se necessário
        if (score > highScore) {
          setState(() {
            highScore = score;
          });
        }
      }
    }
  }

  // Função para gerar a mensagem de dica com base na dificuldade
  String _generateHintMessage(int number) {
    if (!difficultyConfig.showDetailedHints) {
      return "tente outro numero...";
    }

    if (difficultyConfig.showExactHints) {
      if (treasureNumber > number) {
        return "o tesouro esta em um numero maior que $number";
      } else {
        return "o tesouro esta em um numero menor que $number";
      }
    } else {
      // Dicas menos precisas para dificuldade média
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

  // Carregar a pontuação mais alta
  Future<void> _loadHighScore() async {
    final scores = await ScoreManager.getTopScoresForDifficulty(difficulty);
    if (scores.isNotEmpty) {
      setState(() {
        highScore = scores.first.score;
      });
    }
  }

  // Função para mostrar partículas
  void _showParticleEffect(int buttonIndex, ParticleType type) {
    // Calcular a posição do botão para exibir as partículas
    final RenderBox box = context.findRenderObject() as RenderBox;
    final size = box.size;

    // Calcular a posição aproximada do botão na grade
    final int row = buttonIndex ~/ difficultyConfig.columns;
    final int col = buttonIndex % difficultyConfig.columns;

    final double buttonWidth =
        (size.width - 48 - (difficultyConfig.columns - 1) * 10) /
        difficultyConfig.columns;
    final double buttonHeight = buttonWidth; // Altura do botão (quadrado)

    final double x = 16 + col * (buttonWidth + 10) + buttonWidth / 2;
    final double y = 250 + row * (buttonHeight + 10) + buttonHeight / 2;

    setState(() {
      _showParticles = true;
      _particleType = type;
      _particlePosition = Offset(x, y);
    });

    // Vibrar o dispositivo para feedback tátil
    if (type == ParticleType.treasure) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.vibrate();
    }
  }
}
