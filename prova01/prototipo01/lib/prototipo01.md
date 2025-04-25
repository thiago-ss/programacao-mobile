## Estrutura de Layout Principal

O aplicativo de catálogo de viagens utiliza uma estrutura de layout hierárquica com vários widgets Flutter-chave trabalhando juntos:

- `Scaffold` como estrutura principal
- `Column` para organização vertical
- `Container` para cabeçalho
- `Expanded` com `ListView` para o conteúdo rolável
- `BottomNavigationBar` como navegação inferior

### 1. Scaffold

O widget `Scaffold` fornece a estrutura visual básica para o aplicativo, incluindo:

- Uma área de corpo para o conteúdo principal  
- Uma barra de navegação inferior  
- Suporte para outros elementos padrão de aplicativos como barras de aplicativos e gavetas (não utilizados neste app)

```dart
Scaffold(
  body: Column(...),
  bottomNavigationBar: BottomNavigationBar(...),
)
```

### 2. Contêineres de Layout Primários

#### Column

O widget `Column` é usado como o contêiner de layout primário, organizando o conteúdo verticalmente:

```dart
Column(
  children: [
    // Container do cabeçalho
    // Área de conteúdo expandida
  ],
)
```

#### Expanded com ListView

O widget `Expanded` combinado com `ListView` permite que o conteúdo role enquanto ocupa todo o espaço disponível:

```dart
Expanded(
  child: ListView(
    children: [
      // Várias seções de conteúdo
    ],
  ),
)
```

## Componentes e Técnicas de Layout

### 1. Container para Estilização e Espaçamento

O widget `Container` é extensivamente utilizado em todo o aplicativo para:

- Adicionar padding e margens  
- Aplicar cores de fundo  
- Adicionar decorações como bordas, raio de borda e sombras  
- Definir dimensões específicas  

Exemplo do cabeçalho:

```dart
Container(
  padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 16),
  color: Colors.teal,
  child: Row(...),
)
```

### 2. Row para Layouts Horizontais

O widget `Row` organiza os filhos horizontalmente e é usado em vários lugares:

- Layout do cabeçalho com título e botões de ação  
- Botões de ação rápida  
- Títulos de seção com botões "Ver Todos"  
- Detalhes do pacote com avaliações  
- Combinações de preço e botão de ação  

Exemplo da linha de ações rápidas:

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    _buildQuickAction(Icons.flight, 'Voos'),
    _buildQuickAction(Icons.hotel, 'Hotéis'),
    // Mais ações rápidas...
  ],
)
```

### 3. Stack e Positioned para Sobreposições

Os widgets `Stack` e `Positioned` são usados juntos para criar elementos de UI em camadas:

- Banner com sobreposição de texto na imagem  
- Cards de destino com sobreposição de preço  
- Pacotes de viagem com badge de duração  

Exemplo do banner:

```dart
Stack(
  children: [
    // Container de imagem de fundo
    Container(
      height: 200,
      width: double.infinity,
      // Decoração da imagem...
    ),
    
    // Sobreposição de gradiente
    Positioned(
      top: 16,
      left: 16,
      right: 16,
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          // Decoração de gradiente...
        ),
      ),
    ),
    
    // Sobreposição de texto
    Positioned(
      bottom: 32,
      left: 32,
      right: 32,
      child: Column(
        // Conteúdo de texto...
      ),
    ),
  ],
)
```

### 4. Wrap para Layouts Responsivos Tipo Grade

O widget `Wrap` cria um layout responsivo tipo grade para cards de destino:

```dart
Wrap(
  spacing: 16,
  runSpacing: 16,
  children: [
    _buildDestinationCard('Bali, Indonésia', 'A partir de R$ 4.899', './assets/images/bali.jpg'),
    _buildDestinationCard('Santorini, Grécia', 'A partir de R$ 6.299', './assets/images/santorini.jpg'),
    // Mais cards de destino...
  ],
)
```

### 5. SizedBox para Espaçamento

O widget `SizedBox` é usado em todo o aplicativo para criar espaçamento consistente entre elementos:

```dart
const SizedBox(height: 8),
const SizedBox(height: 24),
const SizedBox(width: 4),
```

## Componentes de UI Especializados

### 1. ClipRRect para Cantos Arredondados de Imagens

O widget `ClipRRect` recorta seu filho (geralmente uma imagem) com cantos arredondados:

```dart
ClipRRect(
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(12),
    topRight: Radius.circular(12),
  ),
  child: Image.asset(
    imagePath,
    height: 120,
    width: 160,
    fit: BoxFit.cover,
  ),
)
```
