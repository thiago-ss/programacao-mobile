import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/pet.dart';

class PetProfilePreview extends StatefulWidget {
  final Pet pet;
  final XFile? imageFile;

  const PetProfilePreview({
    super.key,
    required this.pet,
    this.imageFile,
  });

  @override
  State<PetProfilePreview> createState() => _PetProfilePreviewState();
}

class _PetProfilePreviewState extends State<PetProfilePreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String get generoTexto =>
      widget.pet.genero == PetGenero.macho ? 'Macho' : 'Fêmea';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview do Perfil'),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compartilhar perfil')),
              );
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  elevation: 8,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: _buildPetImage(),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
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
                              widget.pet.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    widget.pet.genero == PetGenero.macho
                                        ? Icons.male
                                        : Icons.female,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    generoTexto,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF2FF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    widget.pet.breed,
                                    style: const TextStyle(
                                      color: Color(0xFF5C6BC0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF2FF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${widget.pet.age} anos',
                                    style: const TextStyle(
                                      color: Color(0xFF5C6BC0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: widget.pet.disponivelParaAdocao
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    widget.pet.disponivelParaAdocao
                                        ? 'Disponível'
                                        : 'Indisponível',
                                    style: TextStyle(
                                      color: widget.pet.disponivelParaAdocao
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (widget.pet.observations.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              const Text(
                                'Observações:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF5C6BC0),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Text(
                                  widget.pet.observations,
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 8,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Color(0xFF5C6BC0),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Preferências de Convivência',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF5C6BC0),
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildPreferenceRow(
                            'Gosta de crianças', widget.pet.gostaCriancas),
                        _buildPreferenceRow('Convive bem com outros animais',
                            widget.pet.conviveOutrosAnimais),
                        _buildPreferenceRow('Adapta-se bem a apartamentos',
                            widget.pet.adaptaApartamentos),
                        _buildPreferenceRow('Gosta de passeios ao ar livre',
                            widget.pet.gostaPasseios),
                        _buildPreferenceRow('É tranquilo com visitas',
                            widget.pet.tranquiloVisitas),
                        _buildPreferenceRow('Late pouco', widget.pet.latePouco),
                        _buildPreferenceRow('Sociável com estranhos',
                            widget.pet.sociavelEstranhos),
                        _buildPreferenceRow('Compatível com crianças pequenas',
                            widget.pet.compativelCriancasPequenas),
                        _buildPreferenceRow('Gosta de carros e viagens',
                            widget.pet.gostaCarrosViagens),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.home),
                        label: const Text('Voltar para Home'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
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
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  Widget _buildPetImage() {
    if (widget.imageFile != null) {
      if (kIsWeb) {
        return Image.network(
          widget.imageFile!.path,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      } else {
        return Image.file(
          File(widget.imageFile!.path),
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }
    } else if (widget.pet.imageUrl != null) {
      if (kIsWeb) {
        return Image.network(
          widget.pet.imageUrl!,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      } else {
        try {
          return Image.file(
            File(widget.pet.imageUrl!),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        } catch (e) {
          return Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey.shade300,
            child: const Icon(
              Icons.pets,
              size: 80,
              color: Colors.white,
            ),
          );
        }
      }
    } else {
      return Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey.shade300,
        child: const Icon(
          Icons.pets,
          size: 80,
          color: Colors.white,
        ),
      );
    }
  }

  Widget _buildPreferenceRow(String title, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: value
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                value ? Icons.check : Icons.close,
                color: value ? Colors.green : Colors.red,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
