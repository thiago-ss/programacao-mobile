## 1. Container

**Descrição**:
Componente de caixa genérica que permite personalizar aparência, posicionamento e dimensões de seu conteúdo. Oferece controle sobre padding, margin, decoração, cor de fundo e restrições de tamanho.

**Aplicações**:
Criação de cartões visuais, blocos de conteúdo, seções organizadas da interface e elementos com bordas, sombras ou cores de fundo.

**Como usar**:

```dart
Container(
  height: 200,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: Colors.grey.shade200,
  ),
  child: Center(
    child: Icon(
      Icons.map,
      size: 48,
      color: Colors.grey.shade400,
    ),
  ),
)
```

**Exemplo no projeto**: No componente `LocationHoursSection`, usamos um Container para criar o espaço do mapa com cantos arredondados e ícone centralizado.

## 2. Stack

**Descrição**:
Permite empilhar widgets uns sobre os outros, criando camadas de elementos. Útil para sobreposições, como texto sobre imagens ou elementos decorativos.

**Aplicações**:
Criação de layouts complexos com elementos sobrepostos, como cartões com badges, imagens com gradientes ou texto, e interfaces com elementos flutuantes.

**Como usar**:

```dart
Stack(
  children: [
    Image.network(
      'https://via.placeholder.com/400x300?text=Sushi',
      fit: BoxFit.cover,
    ),
    Positioned(
      bottom: 16,
      left: 16,
      child: Text(
        'Sushi Premium',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
)
```

**Exemplo no projeto**: Na `HeroSection`, usamos Stack para sobrepor texto e botões sobre um fundo escuro com uma imagem decorativa.

## 3. Column

**Descrição**:
Organiza widgets filhos em uma sequência vertical. Permite controlar o alinhamento e espaçamento entre os elementos.

**Aplicações**:
Criação de layouts verticais como formulários, listas de informações, e seções de conteúdo que fluem de cima para baixo.

**Como usar**:

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Horários',
      style: TextStyle(
        color: Color(0xFF121212),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    SizedBox(height: 16),
    InfoRow(icon: Icons.access_time, text: 'Seg - Sex: 11:30 - 22:00'),
    InfoRow(icon: Icons.access_time, text: 'Sáb - Dom: 12:00 - 23:00'),
  ],
)
```

**Exemplo no projeto**: No componente `Footer`, usamos Column para organizar o logo, texto e ícones de redes sociais em uma sequência vertical.

## 4. Row

**Descrição**:
Organiza widgets filhos em uma sequência horizontal. Permite controlar o alinhamento e espaçamento entre os elementos.

**Aplicações**:
Criação de barras de navegação, cabeçalhos, linhas de informação e qualquer layout que precise de elementos lado a lado.

**Como usar**:

```dart
Row(
  children: [
    Container(
      width: 40,
      height: 2,
      color: const Color(0xFFD4AF37),
    ),
    SizedBox(width: 16),
    Text(
      'NOSSA HISTÓRIA',
      style: TextStyle(
        color: Color(0xFFD4AF37),
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    ),
  ],
)
```

**Exemplo no projeto**: No componente `AboutSection`, usamos Row para criar um cabeçalho com uma linha decorativa ao lado do título.

## 5. Positioned

**Descrição**:
Usado dentro de um Stack para posicionar widgets com precisão, definindo distâncias em relação às bordas do Stack.

**Aplicações**:
Posicionamento preciso de elementos flutuantes, badges, botões de ação e elementos decorativos em layouts complexos.

**Como usar**:

```dart
Stack(
  children: [
    // Conteúdo principal
    Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFD4AF37),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
        ),
        child: Text(
          '10% OFF',
          style: TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ],
)
```

**Exemplo no projeto**: No componente `MenuItemCard`, usamos Positioned para colocar badges de desconto ou "NOVO" no canto superior direito das imagens dos pratos.

## 6. Expanded

**Descrição**:
Faz com que um widget filho ocupe todo o espaço disponível em um Row ou Column, respeitando a proporção definida pelo flex.

**Aplicações**:
Criação de layouts responsivos onde os elementos precisam se ajustar proporcionalmente ao espaço disponível.

**Como usar**:

```dart
Row(
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Horários'),
          // Mais conteúdo
        ],
      ),
    ),
    SizedBox(width: 24),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Endereço'),
          // Mais conteúdo
        ],
      ),
    ),
  ],
)
```

**Exemplo no projeto**: No componente `LocationHoursSection`, usamos Expanded para dividir o espaço igualmente entre as informações de horário/contato e endereço.

## 7. LayoutBuilder

**Descrição**:
Fornece as restrições de layout do pai e permite construir widgets diferentes com base nessas restrições, facilitando designs responsivos.

**Aplicações**:
Criação de layouts adaptáveis que mudam com base no tamanho da tela, permitindo diferentes estruturas para mobile e desktop.

**Como usar**:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      // Layout para telas maiores
      return Row(
        children: [
          // Conteúdo em colunas
        ],
      );
    } else {
      // Layout para telas menores
      return Column(
        children: [
          // Conteúdo empilhado
        ],
      );
    }
  },
)
```

**Exemplo no projeto**: No componente `AboutSection`, usamos LayoutBuilder para alternar entre um layout de duas colunas em telas maiores e um layout de coluna única em telas menores.

## 8. SingleChildScrollView

**Descrição**:
Cria uma área rolável que contém um único widget filho, geralmente uma Column ou Row com múltiplos elementos.

**Aplicações**:
Criação de telas com conteúdo que pode exceder o tamanho visível, permitindo rolagem para visualizar todo o conteúdo.

**Como usar**:

```dart
SingleChildScrollView(
  controller: _scrollController,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Múltiplos componentes
      HeroSection(),
      AboutSection(),
      FeaturedDishesSection(),
      // Mais seções
    ],
  ),
)
```

**Exemplo no projeto**: Na `HomePage`, usamos SingleChildScrollView para permitir a rolagem vertical através de todas as seções da página inicial.

## 9. ClipRRect

**Descrição**:
Corta seu widget filho usando um retângulo com cantos arredondados, permitindo criar elementos com bordas arredondadas.

**Aplicações**:
Arredondamento de imagens, cards e containers para criar uma interface mais suave e moderna.

**Como usar**:

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: Image.network(
    item.imageUrl,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        color: Colors.grey.shade100,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey.shade400,
          ),
        ),
      );
    },
  ),
)
```

**Exemplo no projeto**: No componente `MenuItemCard`, usamos ClipRRect para criar imagens com cantos arredondados para os pratos do menu.

## 10. Hero

**Descrição**:
Cria uma animação de transição entre telas quando um widget com a mesma tag é encontrado na tela de destino.

**Aplicações**:
Criação de transições suaves entre telas relacionadas, como uma lista de itens e a tela de detalhes de um item.

**Como usar**:

```dart
Hero(
  tag: 'menu-item-${item.name}',
  child: Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        item.imageUrl,
        fit: BoxFit.cover,
      ),
    ),
  ),
)
```

**Exemplo no projeto**: Nos componentes `MenuItemCard` e `MenuDetailView`, usamos Hero para criar uma transição suave da imagem do prato entre a lista de menu e a tela de detalhes.

## 11. AnimatedContainer

**Descrição**:
Versão animada do Container que suaviza automaticamente as mudanças em suas propriedades ao longo do tempo.

**Aplicações**:
Criação de transições suaves em elementos da interface quando seus estados mudam, como botões que mudam de cor ou tamanho.

**Como usar**:

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: selected ? const Color(0xFFD4AF37) : Colors.grey.shade100,
    boxShadow: selected
        ? [
            BoxShadow(
              color: const Color(0xFFD4AF37).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ]
        : [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
  ),
  child: Text(
    label,
    style: TextStyle(
      color: selected ? Colors.black : Colors.grey.shade800,
      fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
    ),
  ),
)
```

**Exemplo no projeto**: No componente `AnimatedFilterChip`, usamos AnimatedContainer para criar uma transição suave quando o chip de filtro é selecionado ou deselecionado.

## 12. FadeTransition

**Descrição**:
Anima a opacidade de seu widget filho com base em uma animação, criando efeitos de aparecimento e desaparecimento.

**Aplicações**:
Criação de animações de entrada e saída suaves para elementos da interface, como carregamento progressivo de conteúdo.

**Como usar**:

```dart
FadeTransition(
  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ),
  ),
  child: SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    ),
    child: Column(
      // Conteúdo
    ),
  ),
)
```

**Exemplo no projeto**: Na `HeroSection`, usamos FadeTransition combinada com SlideTransition para criar uma animação de entrada elegante para os elementos da seção de destaque.

## 13. BoxDecoration

**Descrição**:
Define a aparência visual de um Container, incluindo cor de fundo, bordas, sombras, gradientes e imagens.

**Aplicações**:
Estilização de containers, cards, botões e outros elementos visuais com bordas, sombras e efeitos.

**Como usar**:

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
    border: Border.all(
      color: Colors.grey.shade100,
      width: 1,
    ),
  ),
  child: // Conteúdo
)
```

**Exemplo no projeto**: No componente `MenuItemCard`, usamos BoxDecoration para criar cards com bordas arredondadas, sombras suaves e bordas finas.

## 14. Scaffold

**Descrição**:
Implementa a estrutura básica de layout visual do Material Design, fornecendo APIs para drawer, snack bar, bottom sheets, etc.

**Aplicações**:
Criação da estrutura básica de telas em aplicativos Flutter, incluindo AppBar, corpo principal e elementos de navegação.

**Como usar**:

```dart
Scaffold(
  backgroundColor: Colors.black,
  extendBodyBehindAppBar: true,
  appBar: AppBar(
    backgroundColor: _showAppBarTitle 
        ? Colors.black.withOpacity(0.8) 
        : Colors.transparent,
    elevation: 0,
    centerTitle: true,
    title: AnimatedOpacity(
      opacity: _showAppBarTitle ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: const Text(
        'KAN',
        style: TextStyle(
          color: Color(0xFFD4AF37),
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {},
      ),
    ],
  ),
  body: SingleChildScrollView(
    // Conteúdo
  ),
)
```

**Exemplo no projeto**: Na `HomePage`, usamos Scaffold para criar a estrutura básica da tela com uma AppBar transparente que muda de opacidade durante a rolagem.

## 15. GridView

**Descrição**:
Organiza widgets em uma grade bidimensional, permitindo controle sobre o número de colunas, proporção dos itens e espaçamento.

**Aplicações**:
Exibição de coleções de itens em formato de grade, como galerias de fotos, catálogos de produtos ou dashboards.

**Como usar**:

```dart
GridView.count(
  crossAxisCount: 2,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  mainAxisSpacing: 20,
  crossAxisSpacing: 20,
  childAspectRatio: 0.8,
  children: [
    _buildFeaturedDish(
      'Sushi premium',
      'Combinação especial do chef com peixes selecionados',
      'https://via.placeholder.com/300x400?text=Sushi',
    ),
    // Mais itens
  ],
)
```

**Exemplo no projeto**: No componente `FeaturedDishesSection`, usamos GridView.count para criar uma grade de pratos em destaque com duas colunas.

## 16. Table

**Descrição**:
Organiza widgets em linhas e colunas, similar a uma tabela HTML, permitindo alinhamento preciso de elementos.

**Aplicações**:
Exibição de dados tabulares, como informações nutricionais, preços ou especificações de produtos.

**Como usar**:

```dart
Table(
  border: TableBorder.symmetric(
    inside: BorderSide(color: Colors.grey.shade200),
  ),
  children: [
    TableRow(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
      ),
      children: const [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Nutriente',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Quantidade',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    // Mais linhas
  ],
)
```

**Exemplo no projeto**: No componente `MenuDetailView`, usamos Table para exibir as informações nutricionais dos pratos de forma organizada.

## 17. Wrap

**Descrição**:
Organiza widgets em linhas horizontais e quebra para a próxima linha quando não há espaço suficiente, similar ao flexbox wrap do CSS.

**Aplicações**:
Exibição de coleções de elementos que precisam se adaptar ao espaço disponível, como tags, chips ou botões.

**Como usar**:

```dart
Wrap(
  spacing: 16,
  runSpacing: 16,
  children: [
    _buildGoldButton(
      onPressed: onMenuPressed,
      child: const Text(
        'Ver cardápio',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    ),
    _buildOutlinedGoldButton(
      onPressed: onReservePressed,
      child: const Text(
        'Reservar mesa',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFFD4AF37),
        ),
      ),
    ),
  ],
)
```

**Exemplo no projeto**: Na `HeroSection`, usamos Wrap para organizar os botões de ação, permitindo que eles se organizem em uma ou duas linhas dependendo do espaço disponível.

Estes são os principais componentes de layout utilizados no aplicativo do restaurante japonês Kan. Cada um deles desempenha um papel importante na criação de uma interface elegante, responsiva e funcional.