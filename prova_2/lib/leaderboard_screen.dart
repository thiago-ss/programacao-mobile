import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'difficulty_manager.dart';
import 'score_manager.dart';

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

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class ShinyText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const ShinyText({super.key, required this.text, required this.style});

  @override
  State<ShinyText> createState() => _ShinyTextState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  GameDifficulty _selectedDifficulty = GameDifficulty.easy;
  List<PlayerScore> _scores = [];
  bool _isLoading = true;
  late AnimationController _animController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF000000), Color(0xFF1A0029), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Cabeçalho
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Expanded(
                      child: Center(
                        child: ShinyText(
                          text: 'recordes',
                          style: GoogleFonts.pressStart2p(
                            color: Colors.amber,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Para balancear o layout
                  ],
                ),

                const SizedBox(height: 20),

                // Seletor de dificuldade
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      GameDifficulty.values.map((difficulty) {
                        final config = DifficultyManager.getConfig(difficulty);
                        final isSelected = _selectedDifficulty == difficulty;

                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            _changeDifficulty(difficulty);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: config.color,
                                width: isSelected ? 3 : 1,
                              ),
                              boxShadow:
                                  isSelected
                                      ? [
                                        BoxShadow(
                                          color: config.color.withOpacity(0.6),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                      : null,
                            ),
                            child: Text(
                              config.label,
                              style: GoogleFonts.pressStart2p(
                                color:
                                    isSelected
                                        ? config.color
                                        : config.color.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 20),

                // Cabeçalho da tabela
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    border: Border.all(
                      color: const Color(0xFF00FFFF),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text(
                          'pos',
                          style: GoogleFonts.pressStart2p(
                            color: const Color(0xFF00FFFF),
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'jogador',
                          style: GoogleFonts.pressStart2p(
                            color: const Color(0xFF00FFFF),
                            fontSize: 10,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          'pontos',
                          style: GoogleFonts.pressStart2p(
                            color: const Color(0xFF00FFFF),
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          'nivel',
                          style: GoogleFonts.pressStart2p(
                            color: const Color(0xFF00FFFF),
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),

                // Lista de pontuações
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      border: Border.all(
                        color: const Color(0xFF00FFFF),
                        width: 2,
                      ),
                    ),
                    child:
                        _isLoading
                            ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF00FFFF),
                              ),
                            )
                            : _scores.isEmpty
                            ? Center(
                              child: Text(
                                'sem recordes ainda!',
                                style: GoogleFonts.pressStart2p(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                            )
                            : ListView.builder(
                              itemCount: _scores.length,
                              itemBuilder: (context, index) {
                                final score = _scores[index];
                                final isTop3 = index < 3;

                                // Cores para os 3 primeiros lugares
                                Color rowColor;
                                if (index == 0) {
                                  rowColor = Colors.amber.withOpacity(0.3);
                                } else if (index == 1) {
                                  rowColor = Colors.grey.shade300.withOpacity(
                                    0.3,
                                  );
                                } else if (index == 2) {
                                  rowColor = Colors.brown.shade300.withOpacity(
                                    0.3,
                                  );
                                } else {
                                  rowColor = Colors.transparent;
                                }

                                return AnimatedBuilder(
                                  animation: _animController,
                                  builder: (context, child) {
                                    final delay = index * 0.1;
                                    final animValue =
                                        _animController.value > delay
                                            ? ((_animController.value - delay) /
                                                    (1 - delay))
                                                .clamp(0.0, 1.0)
                                            : 0.0;

                                    return Opacity(
                                      opacity: animValue,
                                      child: Transform.translate(
                                        offset: Offset(0, 20 * (1 - animValue)),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: rowColor,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: const Color(
                                            0xFF00FFFF,
                                          ).withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          child: Row(
                                            children: [
                                              if (isTop3)
                                                Text(
                                                  index == 0
                                                      ? '🥇'
                                                      : (index == 1
                                                          ? '🥈'
                                                          : '🥉'),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                )
                                              else
                                                Text(
                                                  '${index + 1}',
                                                  style:
                                                      GoogleFonts.pressStart2p(
                                                        color: Colors.white
                                                            .withOpacity(0.7),
                                                        fontSize: 10,
                                                      ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            score.playerName,
                                            style: GoogleFonts.pressStart2p(
                                              color:
                                                  isTop3
                                                      ? Colors.white
                                                      : Colors.white
                                                          .withOpacity(0.7),
                                              fontSize: 10,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            '${score.score}',
                                            style: GoogleFonts.pressStart2p(
                                              color:
                                                  isTop3
                                                      ? Colors.white
                                                      : Colors.white
                                                          .withOpacity(0.7),
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Text(
                                            '${score.level}',
                                            style: GoogleFonts.pressStart2p(
                                              color:
                                                  isTop3
                                                      ? Colors.white
                                                      : Colors.white
                                                          .withOpacity(0.7),
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ),

                const SizedBox(height: 20),

                // Botão de voltar
                SizedBox(
                  width: double.infinity,
                  child: ArcadeActionButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: 'voltar',
                    color: const Color(0xFF00FFFF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _loadScores();
    _animController.forward();
  }

  void _changeDifficulty(GameDifficulty difficulty) {
    if (_selectedDifficulty != difficulty) {
      setState(() {
        _selectedDifficulty = difficulty;
      });
      _loadScores();
    }
  }

  Future<void> _loadScores() async {
    setState(() {
      _isLoading = true;
    });

    final scores = await ScoreManager.getTopScoresForDifficulty(
      _selectedDifficulty,
    );

    setState(() {
      _scores = scores;
      _isLoading = false;
    });
  }
}

class _ShinyTextState extends State<ShinyText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.value;
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [Colors.white, Colors.amber, Colors.white],
              stops: [value - 0.3, value, value + 0.3],
            ).createShader(bounds);
          },
          child: Text(widget.text, style: widget.style),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }
}
