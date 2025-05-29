# explicação do app pet management

## grupo

Camila Sara
Thiago Schweder Souza

## principais métodos/classes

**User** -> classe modelo para usuários
```dart
class User {
  final int? id;
  final String name;
  final String email;
  final String? password;
  final String? imageUrl;
  // outros campos...
}
```

**Pet** -> classe modelo para pets
```dart
class Pet {
  final int? id;
  final String name;
  final String breed;
  final int age;
  final PetGenero genero;
  final bool gostaCriancas;
  // outras características...
}
```

**DatabaseHelper** -> singleton para gerenciar banco de dados
```dart
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
}
```

**LandingPage** -> widget da tela inicial com animações
```dart
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
}
```

**_buildLandingContent** -> método que constrói o conteúdo da landing page com logo animado, carrossel de recursos e botões

**LoginScreen** -> tela de login/registro de usuários

**_submitForm** em _LoginScreenState -> processa o login ou registro do usuário

**HomeScreen** -> tela principal que mostra os pets cadastrados

**_buildPetImage** -> método para carregar imagens de pets de forma compatível com web e mobile

**RegisterPetScreen** -> tela para cadastro de novos pets

**_submitForm** em _RegisterPetScreenState -> salva os dados do pet no banco de dados

**PetProfilePreview** -> tela de visualização detalhada do perfil do pet

**UserProfileScreen** -> tela de perfil do usuário

**_SearchBarDelegate** -> implementa a barra de pesquisa fixa no topo da tela principal

## lógica

### inicialização do banco de dados
```dart
Future<Database> _initDatabase() async {
  // Não inicializar no web
  if (_isWebPlatform) {
    throw UnsupportedError('SQLite não é suportado na web');
  }

  String path = join(await getDatabasesPath(), 'pet_database.db');
  return await openDatabase(
    path,
    version: 2,
    onCreate: _createDb,
    onUpgrade: _upgradeDb,
  );
}
```
cria o banco de dados SQLite para armazenamento em dispositivos móveis
define a estrutura das tabelas para pets e usuários
implementa sistema de versão para atualizações do esquema

### armazenamento web
```dart
// Lista em memória para armazenar pets na web
static List<Pet> _webPets = [];
static int _webPetId = 1;
  
// Lista em memória para armazenar usuários na web
static List<User> _webUsers = [];
static int _webUserId = 1;
```
usa listas em memória para simular banco de dados na web
mantém contadores de ID para simular auto-incremento

### cadastro de pet
```dart
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
      // Create pet object
      final pet = Pet(
        name: _nameController.text,
        breed: _breedController.text,
        age: int.parse(_ageController.text),
        // outros campos...
      );

      // Save to database
      final id = await _databaseHelper.insertPet(pet);
      // ...
    } catch (e) {
      // tratamento de erro
    }
  }
}
```
valida os campos do formulário
cria um objeto Pet com os dados informados
salva no banco de dados usando DatabaseHelper
trata erros e mostra feedback ao usuário

### carregamento de imagens
```dart
Widget _buildPetImage(String? imageUrl) {
  if (imageUrl == null) {
    return const Icon(Icons.pets, color: Color(0xFF5C6BC0));
  }
  
  if (kIsWeb) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      // ...
    );
  } else {
    try {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        // ...
      );
    } catch (e) {
      return const Icon(Icons.pets, color: Color(0xFF5C6BC0));
    }
  }
}
```
verifica se a URL da imagem existe
usa Image.network para web e Image.file para mobile
implementa tratamento de erros com fallback para ícone

### autenticação de usuário
```dart
Future<User?> getUserByEmail(String email, {String? password}) async {
  if (_isWebPlatform) {
    // Busca na lista em memória para web
    try {
      final user = _webUsers.firstWhere((user) => user.email == email);
      if (password != null && user.password != password) {
        return null; // Senha incorreta
      }
      return user;
    } catch (e) {
      return null;
    }
  } else {
    // Implementação para mobile/desktop
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      final user = User.fromMap(maps.first);
      if (password != null && user.password != password) {
        return null; // Senha incorreta
      }
      return user;
    }
    return null;
  }
}
```
busca usuário pelo email
verifica a senha se fornecida
implementação diferente para web e mobile

### animação do carrossel na landing page
```dart
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
```
usa Timer.periodic para avançar o carrossel automaticamente
verifica se o widget ainda está montado para evitar erros
implementa tratamento de exceções
controla o estado de animação para evitar múltiplos timers

### animação do logo
```dart
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
    // ...
    child: const Icon(
      Icons.pets,
      size: 80,
      color: Colors.white,
    ),
  ),
)
```
usa AnimationController para controlar a animação
combina rotação e escala para efeito de pulso
aplica ao ícone de pets na landing page

### carregamento de pets
```dart
Future<void> _loadData() async {
  setState(() {
    _isLoading = true;
  });
  
  try {
    // Carregar usuário atual
    _currentUser = _databaseHelper.getCurrentUser();
    
    // Carregar pets
    final pets = await _databaseHelper.getPets();
    setState(() {
      _recentPets = pets;
    });
  } catch (e) {
    // tratamento de erro
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
```
carrega o usuário atual da sessão
busca a lista de pets do banco de dados
atualiza o estado para refletir os dados carregados
implementa tratamento de erros e estado de carregamento

## estrutura de navegação

### transição entre telas
```dart
Route _createRoute(Widget destination) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 800),
    pageBuilder: (context, animation, secondaryAnimation) => destination,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // animações de transição
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      final tweenChild = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutCubic));
      final offsetAnimationChild = animation.drive(tweenChild);
      
      // mais código de animação...
      
      return Stack(
        children: [
          // implementação da transição
        ],
      );
    },
  );
}
```
cria uma transição personalizada entre telas
implementa efeito de deslize de baixo para cima
adiciona fade in/out para suavizar a transição

### fluxo de navegação
1. LandingPage -> ponto de entrada com animações e opções
2. LoginScreen -> autenticação do usuário
3. HomeScreen -> tela principal com lista de pets
4. RegisterPetScreen -> cadastro de novos pets
5. PetProfilePreview -> visualização detalhada do pet
6. UserProfileScreen -> gerenciamento do perfil do usuário

## persistência de dados

### inserção de pet
```dart
Future<int> insertPet(Pet pet) async {
  if (_isWebPlatform) {
    // Implementação para web usando memória
    final newPet = Pet(
      id: _webPetId,
      name: pet.name,
      // outros campos...
    );
    _webPets.add(newPet);
    _webPetId++;
    return newPet.id!;
  } else {
    // Implementação para mobile/desktop
    Database db = await database;
    return await db.insert('pets', pet.toMap());
  }
}
```
implementação diferente para web e mobile
web: adiciona à lista em memória
mobile: insere no banco SQLite

### consulta de pets
```dart
Future<List<Pet>> getPets() async {
  if (_isWebPlatform) {
    // Retorna a lista em memória para web
    return _webPets;
  } else {
    // Implementação para mobile/desktop
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pets');
    return List.generate(maps.length, (i) {
      return Pet.fromMap(maps[i]);
    });
  }
}
```
web: retorna a lista em memória
mobile: consulta o banco SQLite e converte para objetos Pet

## gerenciamento de estado

### estado do formulário
```dart
final _formKey = GlobalKey<FormState>();
final TextEditingController _nameController = TextEditingController();
final TextEditingController _breedController = TextEditingController();
final TextEditingController _ageController = TextEditingController();
final TextEditingController _obsController = TextEditingController();

PetGenero? _generoSelecionado;
XFile? _imageFile;
String? _imageUrl;

bool _gostaCriancas = false;
bool _conviveOutrosAnimais = false;
// outros estados...
```
usa GlobalKey para validação do formulário
controladores para campos de texto
variáveis de estado para checkboxes e seleções

### estado da aplicação
```dart
// Usuário atual
static User? _currentUser;

Future<void> setCurrentUser(User user) async {
  _currentUser = user;
}

User? getCurrentUser() {
  return _currentUser;
}

void clearCurrentUser() {
  _currentUser = null;
}
```
mantém o usuário logado em memória
métodos para gerenciar o estado de autenticação
