import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class Particle {
  final ParticleType type;
  final AnimationController controller;
  final double size;
  final double angle;
  final double speed;
  final Offset position;
  final Color color;
  final IconData? icon;
  final String? emoji;

  Particle({
    required this.type,
    required this.controller,
    required this.size,
    required this.angle,
    required this.speed,
    required this.position,
    required this.color,
    this.icon,
    this.emoji,
  });
}

class ParticleSystem extends StatefulWidget {
  final ParticleType type;
  final Offset position;
  final VoidCallback? onComplete;

  const ParticleSystem({
    super.key,
    required this.type,
    required this.position,
    this.onComplete,
  });

  @override
  State<ParticleSystem> createState() => _ParticleSystemState();
}

enum ParticleType { treasure, bomb, monster }

class ShinyEffect extends StatelessWidget {
  final Widget child;

  const ShinyEffect({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Usar uma animação mais simples
    final tween =
        MovieTween()..tween(
          'dx',
          (-0.5).tweenTo(1.5),
          duration: 3.seconds,
          curve: Curves.easeInOut,
        );

    return Stack(
      children: [
        child,
        // Usar RepaintBoundary para isolar as operações de repintura
        RepaintBoundary(
          child: CustomAnimationBuilder<Movie>(
            duration: 3.seconds,
            tween: tween,
            builder: (context, value, _) {
              // Só mostrar o efeito em determinados momentos para economizar recursos
              if (value.get('dx') < 0 || value.get('dx') > 1) {
                return const SizedBox.shrink();
              }

              return Positioned.fill(
                child: Opacity(
                  opacity: 0.3,
                  child: Transform.rotate(
                    angle: pi / 4,
                    child: Transform.translate(
                      offset: Offset(
                        MediaQuery.of(context).size.width * value.get('dx'),
                        0,
                      ),
                      child: Container(
                        width: 30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ParticleSystemState extends State<ParticleSystem>
    with TickerProviderStateMixin {
  final List<Particle> _particles = [];
  final Random _random = Random();
  late AnimationController _systemController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _systemController,
      builder: (context, child) {
        // Usar RepaintBoundary para isolar as operações de repintura
        return RepaintBoundary(
          child: Stack(
            children:
                _particles.map((particle) {
                  return AnimatedBuilder(
                    animation: particle.controller,
                    builder: (context, child) {
                      final progress = particle.controller.value;
                      final distance = particle.speed * progress;
                      final dx = cos(particle.angle) * distance;
                      final dy = sin(particle.angle) * distance;
                      final opacity = (1 - progress).clamp(0.0, 1.0);
                      final scale =
                          widget.type == ParticleType.bomb
                              ? 1 + progress * 0.3
                              : 1 - progress * 0.3;

                      // Não renderizar partículas quase invisíveis para economizar recursos
                      if (opacity < 0.05) return const SizedBox.shrink();

                      return Positioned(
                        left: particle.position.dx + dx,
                        top: particle.position.dy + dy,
                        child: Opacity(
                          opacity: opacity,
                          child: Transform.scale(
                            scale: scale,
                            child:
                                particle.emoji != null
                                    ? Text(
                                      particle.emoji!,
                                      style: TextStyle(
                                        fontSize: particle.size * 2,
                                      ),
                                    )
                                    : Container(
                                      width: particle.size,
                                      height: particle.size,
                                      decoration: BoxDecoration(
                                        color: particle.color,
                                        shape:
                                            _random.nextBool()
                                                ? BoxShape.circle
                                                : BoxShape.rectangle,
                                        // Remover sombras para melhorar o desempenho
                                      ),
                                    ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _systemController.dispose();
    for (var particle in _particles) {
      particle.controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _systemController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _systemController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.onComplete != null) {
          widget.onComplete!();
        }
      }
    });

    _createParticles();
    _systemController.forward();
  }

  void _createParticles() {
    // Reduzir significativamente o número de partículas
    int particleCount = widget.type == ParticleType.treasure ? 30 : 20;

    for (int i = 0; i < particleCount; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: _random.nextInt(500) + 800),
      );

      double size = _random.nextDouble() * 8 + 4;
      double angle = _random.nextDouble() * 2 * pi;
      double speed = _random.nextDouble() * 150 + 50;

      Color color;
      String? emoji;

      switch (widget.type) {
        case ParticleType.treasure:
          // Cores douradas para o tesouro
          color = [Colors.amber, Colors.yellow][_random.nextInt(2)];

          // Reduzir a chance de emojis para melhorar o desempenho
          if (_random.nextInt(5) == 0) {
            emoji = ['💎', '✨'][_random.nextInt(2)];
          }
          break;
        case ParticleType.bomb:
          // Cores de explosão para a bomba
          color = [Colors.red, Colors.orange][_random.nextInt(2)];

          if (_random.nextInt(5) == 0) {
            emoji = ['💥', '🔥'][_random.nextInt(2)];
          }
          break;
        case ParticleType.monster:
          // Cores roxas para o monstro
          color = [Colors.purple, Colors.deepPurple][_random.nextInt(2)];

          if (_random.nextInt(5) == 0) {
            emoji = ['👾', '👹'][_random.nextInt(2)];
          }
          break;
      }

      _particles.add(
        Particle(
          type: widget.type,
          controller: controller,
          size: size,
          angle: angle,
          speed: speed,
          position: widget.position,
          color: color,
          emoji: emoji,
        ),
      );

      controller.forward();
    }
  }
}
