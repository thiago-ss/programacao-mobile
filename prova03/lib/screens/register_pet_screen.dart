import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/pet.dart';
import '../services/database_helper.dart';
import 'pet_profile_preview.dart';

class RegisterPetScreen extends StatefulWidget {
  const RegisterPetScreen({super.key});

  @override
  State<RegisterPetScreen> createState() => _RegisterPetScreenState();
}

class _RegisterPetScreenState extends State<RegisterPetScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _obsController = TextEditingController();

  PetGenero? _generoSelecionado;
  XFile? _imageFile;
  String? _imageUrl;

  bool _gostaCriancas = false;
  bool _conviveOutrosAnimais = false;
  bool _adaptaApartamentos = false;
  bool _gostaPasseios = false;
  bool _tranquiloVisitas = false;
  bool _latePouco = false;
  bool _sociavelEstranhos = false;
  bool _compativelCriancasPequenas = false;
  bool _gostaCarrosViagens = false;
  bool _disponivelParaAdocao = false;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Pet'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Perfil do Usuário',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perfil do usuário clicado')),
              );
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cadastro de Perfil do Pet',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5C6BC0),
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Preencha os dados do seu pet!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            image: _imageFile != null
                                ? DecorationImage(
                                    image: kIsWeb
                                        ? NetworkImage(_imageFile!.path)
                                        : FileImage(File(_imageFile!.path))
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _imageFile == null
                              ? const Icon(
                                  Icons.pets,
                                  size: 80,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5C6BC0),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Pet',
                    prefixIcon: Icon(Icons.pets),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o nome do pet';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _breedController,
                  decoration: const InputDecoration(
                    labelText: 'Raça',
                    prefixIcon: Icon(Icons.category),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a raça do pet';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Idade (anos)',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a idade do pet';
                    }
                    final idade = int.tryParse(value);
                    if (idade == null || idade < 0) {
                      return 'Informe uma idade válida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _obsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Observações (opcional)',
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 64),
                      child: Icon(Icons.note),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gênero do Pet',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF5C6BC0),
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<PetGenero>(
                                title: const Text('Macho'),
                                value: PetGenero.macho,
                                groupValue: _generoSelecionado,
                                onChanged: (value) =>
                                    setState(() => _generoSelecionado = value),
                                activeColor: const Color(0xFF5C6BC0),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<PetGenero>(
                                title: const Text('Fêmea'),
                                value: PetGenero.femea,
                                groupValue: _generoSelecionado,
                                onChanged: (value) =>
                                    setState(() => _generoSelecionado = value),
                                activeColor: const Color(0xFF5C6BC0),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preferências de Convivência',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF5C6BC0),
                                  ),
                        ),
                        const SizedBox(height: 8),
                        _buildAnimatedCheckbox(
                          title: 'Gosta de crianças',
                          value: _gostaCriancas,
                          onChanged: (value) =>
                              setState(() => _gostaCriancas = value ?? false),
                        ),
                        _buildAnimatedCheckbox(
                          title: 'Convive bem com outros animais',
                          value: _conviveOutrosAnimais,
                          onChanged: (value) => setState(
                              () => _conviveOutrosAnimais = value ?? false),
                        ),
                        _buildAnimatedCheckbox(
                          title: 'Adapta-se bem a apartamentos',
                          value: _adaptaApartamentos,
                          onChanged: (value) => setState(
                              () => _adaptaApartamentos = value ?? false),
                        ),
                        _buildAnimatedCheckbox(
                          title: 'Gosta de passeios ao ar livre',
                          value: _gostaPasseios,
                          onChanged: (value) =>
                              setState(() => _gostaPasseios = value ?? false),
                        ),
                        _buildAnimatedCheckbox(
                          title: 'É tranquilo com visitas em casa',
                          value: _tranquiloVisitas,
                          onChanged: (value) => setState(
                              () => _tranquiloVisitas = value ?? false),
                        ),
                        _buildAnimatedCheckbox(
                          title: 'Tem hábito de latir/miar pouco',
                          value: _latePouco,
                          onChanged: (value) =>
                              setState(() => _latePouco = value ?? false),
                        ),
                        _buildAnimatedCheckbox(
                          title: 'É sociável com estranhos',
                          value: _sociavelEstranhos,
                          onChanged: (value) => setState(
                              () => _sociavelEstranhos = value ?? false),
                        ),
                        _buildAnimatedCheckbox(
                          title: 'Compatível com crianças pequenas',
                          value: _compativelCriancasPequenas,
                          onChanged: (value) => setState(() =>
                              _compativelCriancasPequenas = value ?? false),
                        ),
                        _buildAnimatedCheckbox(
                          title: 'Gosta de carros e viagens',
                          value: _gostaCarrosViagens,
                          onChanged: (value) => setState(
                              () => _gostaCarrosViagens = value ?? false),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status de Adoção',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF5C6BC0),
                                  ),
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          title: const Text('Disponível para adoção'),
                          value: _disponivelParaAdocao,
                          onChanged: (valor) =>
                              setState(() => _disponivelParaAdocao = valor),
                          activeColor: const Color(0xFF5C6BC0),
                          contentPadding: EdgeInsets.zero,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _disponivelParaAdocao
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Status: ${_disponivelParaAdocao ? 'Disponível' : 'Indisponível'}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _disponivelParaAdocao
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _submitForm,
                        icon: _isLoading
                            ? Container(
                                width: 24,
                                height: 24,
                                padding: const EdgeInsets.all(2.0),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(_isLoading ? 'Salvando...' : 'Salvar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _clearForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade400,
                        ),
                        icon: const Icon(Icons.clear),
                        label: const Text('Limpar'),
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
    _animationController.dispose();
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  Widget _buildAnimatedCheckbox({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: value ? const Color(0xFFEEF2FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CheckboxListTile(
        title: Text(title),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF5C6BC0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        dense: true,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _breedController.clear();
    _ageController.clear();
    _obsController.clear();
    setState(() {
      _generoSelecionado = null;
      _gostaCriancas = false;
      _conviveOutrosAnimais = false;
      _adaptaApartamentos = false;
      _gostaPasseios = false;
      _tranquiloVisitas = false;
      _latePouco = false;
      _sociavelEstranhos = false;
      _compativelCriancasPequenas = false;
      _gostaCarrosViagens = false;
      _disponivelParaAdocao = false;
      _imageFile = null;
      _imageUrl = null;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
        _imageUrl = pickedFile.path;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_generoSelecionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione o gênero do pet')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final pet = Pet(
          name: _nameController.text,
          breed: _breedController.text,
          age: int.parse(_ageController.text),
          observations: _obsController.text,
          genero: _generoSelecionado!,
          gostaCriancas: _gostaCriancas,
          conviveOutrosAnimais: _conviveOutrosAnimais,
          adaptaApartamentos: _adaptaApartamentos,
          gostaPasseios: _gostaPasseios,
          tranquiloVisitas: _tranquiloVisitas,
          latePouco: _latePouco,
          sociavelEstranhos: _sociavelEstranhos,
          compativelCriancasPequenas: _compativelCriancasPequenas,
          gostaCarrosViagens: _gostaCarrosViagens,
          disponivelParaAdocao: _disponivelParaAdocao,
          imageUrl: _imageUrl,
        );

        final id = await _databaseHelper.insertPet(pet);
        final savedPet = Pet(
          id: id,
          name: pet.name,
          breed: pet.breed,
          age: pet.age,
          observations: pet.observations,
          genero: pet.genero,
          gostaCriancas: pet.gostaCriancas,
          conviveOutrosAnimais: pet.conviveOutrosAnimais,
          adaptaApartamentos: pet.adaptaApartamentos,
          gostaPasseios: pet.gostaPasseios,
          tranquiloVisitas: pet.tranquiloVisitas,
          latePouco: pet.latePouco,
          sociavelEstranhos: pet.sociavelEstranhos,
          compativelCriancasPequenas: pet.compativelCriancasPequenas,
          gostaCarrosViagens: pet.gostaCarrosViagens,
          disponivelParaAdocao: pet.disponivelParaAdocao,
          imageUrl: pet.imageUrl,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dados salvos com sucesso!')),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PetProfilePreview(
                pet: savedPet,
                imageFile: _imageFile,
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar: $e')),
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
  }
}
