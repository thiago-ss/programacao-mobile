import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../models/pet.dart';
import '../models/user.dart';
import '../services/database_helper.dart';
import 'pet_profile_preview.dart';
import 'register_pet_screen.dart';
import 'user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Pet> _recentPets = [];
  bool _isLoading = true;
  User? _currentUser;

  final List<Map<String, String>> featuredPets = const [
    {
      'name': 'Luna',
      'breed': 'Golden Retriever',
      'age': '2 anos',
      'imageUrl': 'lib/assets/luna.jpg',
    },
    {
      'name': 'Pepe',
      'breed': 'Labrador',
      'age': '3 anos',
      'imageUrl': 'lib/assets/pepe.jpg',
    },
    {
      'name': 'Patrão',
      'breed': 'Bulldog Francês',
      'age': '1 ano',
      'imageUrl': 'lib/assets/paytrao.jpg',
    },
    {
      'name': 'Pixinguinha',
      'breed': 'Poodle',
      'age': '4 anos',
      'imageUrl': 'lib/assets/pixinguinha.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: Theme.of(context).primaryColor,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF5C6BC0), Color(0xFF3F51B5)],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentUser != null
                                    ? 'Olá, ${_currentUser!.name.split(' ')[0]}!'
                                    : 'Eai, Pet Lover!',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Encontre seu companheiro perfeito',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Hero(
                          tag: 'profile-pic',
                          child: GestureDetector(
                            onTap: _navigateToUserProfile,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: _buildUserAvatar(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SearchBarDelegate(),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Text(
                          'Pets Recentes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimationConfiguration.synchronized(
                        duration: const Duration(milliseconds: 600),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(16)),
                                        child: Image.asset(
                                          'lib/assets/pets.jpg',
                                          width: double.infinity,
                                          height: 200,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              width: double.infinity,
                                              height: 200,
                                              color: Colors.grey.shade300,
                                              child: const Icon(
                                                Icons.pets,
                                                size: 80,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(16)),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.7),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 16,
                                        left: 16,
                                        child: Text(
                                          'Registre seu Pet',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                offset: const Offset(1, 1),
                                                blurRadius: 3,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Crie um perfil para seu amigo peludo',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF5C6BC0),
                                                Color(0xFF3F51B5)
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF5C6BC0)
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RegisterPetScreen()),
                                              ).then((_) => _loadData());
                                            },
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 16),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'Começar Agora',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.2),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                        Icons.pets,
                                                        color: Colors.white,
                                                        size: 20),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Text(
                          'Pets em Destaque',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 260,
                        child: AnimationLimiter(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: featuredPets.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final pet = featuredPets[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                child: SlideAnimation(
                                  horizontalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: Container(
                                      width: 180,
                                      margin: EdgeInsets.only(
                                          right:
                                              index == featuredPets.length - 1
                                                  ? 0
                                                  : 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius
                                                    .vertical(
                                                    top: Radius.circular(16)),
                                                child: Image.asset(
                                                  pet['imageUrl']!,
                                                  width: 180,
                                                  height: 140,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      width: 180,
                                                      height: 140,
                                                      color:
                                                          Colors.grey.shade300,
                                                      child: const Icon(
                                                        Icons.pets,
                                                        size: 60,
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '${index + 3}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  pet['name']!,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF333333),
                                                  ),
                                                ),
                                                Text(
                                                  pet['breed']!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFF666666),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFEEF2FF),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 6),
                                                  child: Text(
                                                    pet['age']!,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF5C6BC0),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_recentPets.isNotEmpty) ...[
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: const Text(
                            'Seus Pets Cadastrados',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimationLimiter(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _recentPets.length,
                            itemBuilder: (context, index) {
                              final pet = _recentPets[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: Card(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 4,
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                        leading: CircleAvatar(
                                          radius: 30,
                                          backgroundColor:
                                              const Color(0xFFEEF2FF),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: pet.imageUrl != null
                                                  ? _buildPetImage(pet.imageUrl)
                                                  : const Icon(Icons.pets,
                                                      color: Color(0xFF5C6BC0)),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          pet.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${pet.breed} • ${pet.age} anos'),
                                            const SizedBox(height: 4),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: pet.disponivelParaAdocao
                                                    ? Colors.green
                                                        .withOpacity(0.1)
                                                    : Colors.red
                                                        .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                pet.disponivelParaAdocao
                                                    ? 'Disponível'
                                                    : 'Indisponível',
                                                style: TextStyle(
                                                  color:
                                                      pet.disponivelParaAdocao
                                                          ? Colors.green
                                                          : Colors.red,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PetProfilePreview(
                                                  pet: pet,
                                                  imageFile: null,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ] else if (!_isLoading) ...[
                        const SizedBox(height: 16),
                        Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.pets_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Nenhum pet cadastrado ainda',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPetScreen()),
                                  ).then((_) => _loadData());
                                },
                                child: const Text('Cadastrar um pet'),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
    _loadData();
  }

  Widget _buildPetImage(String? imageUrl) {
    if (imageUrl == null) {
      return const Icon(Icons.pets, color: Color(0xFF5C6BC0));
    }

    if (kIsWeb) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.pets, color: Color(0xFF5C6BC0));
        },
      );
    } else {
      try {
        return Image.file(
          File(imageUrl),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.pets, color: Color(0xFF5C6BC0));
          },
        );
      } catch (e) {
        return const Icon(Icons.pets, color: Color(0xFF5C6BC0));
      }
    }
  }

  Widget _buildUserAvatar() {
    if (_currentUser?.imageUrl != null) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: kIsWeb
            ? NetworkImage(_currentUser!.imageUrl!)
            : FileImage(File(_currentUser!.imageUrl!)) as ImageProvider,
        onBackgroundImageError: (_, __) {},
      );
    } else {
      return CircleAvatar(
        radius: 24,
        backgroundColor: Colors.white.withOpacity(0.3),
        child: const Icon(
          Icons.person,
          color: Colors.white,
        ),
      );
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _currentUser = _databaseHelper.getCurrentUser();

      final pets = await _databaseHelper.getPets();
      setState(() {
        _recentPets = pets;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToUserProfile() {
    if (_currentUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserProfileScreen()),
      ).then((_) => _loadData());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login para acessar seu perfil')),
      );
    }
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 64;

  @override
  double get minExtent => 64;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxExtent;
    final elevation = progress * 8;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        boxShadow: [
          if (overlapsContent)
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: elevation,
              offset: const Offset(0, 1),
            ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar pets...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5C6BC0), Color(0xFF3F51B5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5C6BC0).withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_list, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
