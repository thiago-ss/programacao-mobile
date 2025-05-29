import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  bool _isNavigating = false;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  late PageController _pageController;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.pets,
      'title': 'Gerencie seus Pets',
      'description':
          'Cadastre todos os seus animais de estimação e mantenha suas informações organizadas.',
    },
    {
      'icon': Icons.favorite,
      'title': 'Encontre Companheiros',
      'description':
          'Descubra pets compatíveis com seu estilo de vida e família.',
    },
    {
      'icon': Icons.calendar_today,
      'title': 'Acompanhe Cuidados',
      'description':
          'Registre vacinas, consultas e outros cuidados importantes para a saúde do seu pet.',
    },
    {
      'icon': Icons.people,
      'title': 'Comunidade Pet',
      'description':
          'Conecte-se com outros donos de pets e compartilhe experiências.',
    },
  ];

  Timer? _autoScrollTimer;
  bool _isAutoScrolling = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C6BC0),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigateToLogin,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF5C6BC0), Color(0xFF3F51B5)],
                ),
              ),
            ),
            _buildLandingContent(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startAutoScroll();
      }
    });
  }

  Widget _buildLandingContent() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotateAnimation.value * math.pi,
                      child: Transform.scale(
                        scale: _pulseAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(75),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.pets,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [Colors.white, Colors.white70],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'Pet Management',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Encontre seu companheiro perfeito',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _features.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final feature = _features[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          feature['icon'],
                          size: 48,
                          color: const Color(0xFF5C6BC0),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          feature['title'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          feature['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _features.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _navigateToLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF5C6BC0),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Entrar ou Registrar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _navigateToHome,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: const Text(
                  'Continuar sem login',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '© 2025 Pet Management',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Versão 1.0.0',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Route _createRoute(Widget destination) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tweenChild = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        final offsetAnimationChild = animation.drive(tweenChild);

        final tweenCurrent =
            Tween(begin: Offset.zero, end: const Offset(0, -0.3))
                .chain(CurveTween(curve: Curves.easeInCubic));
        final offsetAnimationCurrent = animation.drive(tweenCurrent);

        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: animation, curve: const Interval(0.4, 1.0)));

        return Stack(
          children: [
            SlideTransition(
              position: offsetAnimationCurrent,
              child: Scaffold(
                backgroundColor: const Color(0xFF5C6BC0),
                body: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _navigateToLogin,
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF5C6BC0), Color(0xFF3F51B5)],
                          ),
                        ),
                      ),
                      _buildLandingContent(),
                    ],
                  ),
                ),
              ),
            ),
            FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: offsetAnimationChild,
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHome() {
    if (_isNavigating) return;

    _stopAutoScroll();

    setState(() {
      _isNavigating = true;
    });

    Navigator.of(context).push(_createRoute(const HomeScreen())).then((_) {
      setState(() {
        _isNavigating = false;
      });

      if (mounted) {
        _startAutoScroll();
      }
    });
  }

  void _navigateToLogin() {
    if (_isNavigating) return;

    _stopAutoScroll();

    setState(() {
      _isNavigating = true;
    });

    Navigator.of(context).push(_createRoute(const LoginScreen())).then((_) {
      setState(() {
        _isNavigating = false;
      });

      if (mounted) {
        _startAutoScroll();
      }
    });
  }

  void _startAutoScroll() {
    if (_isAutoScrolling) return;

    _isAutoScrolling = true;
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) {
        _stopAutoScroll();
        return;
      }

      if (_pageController.hasClients) {
        try {
          final nextPage = (_currentPage + 1) % _features.length;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        } catch (e) {
          _stopAutoScroll();
        }
      }
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
    _isAutoScrolling = false;
  }
}
