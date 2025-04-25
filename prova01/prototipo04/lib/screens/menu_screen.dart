import 'package:flutter/material.dart';

import '../components/menu_detail_view.dart';
import '../models/menu_item.dart';

class RestaurantMenuScreen extends StatefulWidget {
  final String title;

  const RestaurantMenuScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen>
    with TickerProviderStateMixin {
  String selectedCategory = 'Todos';
  MenuItem? selectedMenuItem;
  late AnimationController _staggeredController;
  late AnimationController _fadeController;

  final List<String> categories = [
    'Todos',
    'Sushi',
    'Sashimi',
    'Ramen',
    'Tempura',
    'Sobremesas',
    'Bebidas',
  ];

  final List<MenuItem> menuItems = [
    MenuItem(
      name: 'Sushi especial',
      category: 'Sushi',
      description: 'Combinação de 8 peças de sushi variado com peixe fresco.',
      price: 45.90,
      imageUrl: 'https://via.placeholder.com/120x120?',
      discount: 10,
      nutritionalInfo: {
        'Calorias': '320 kcal',
        'Proteínas': '18g',
        'Carboidratos': '40g',
        'Gorduras': '8g',
      },
    ),
    MenuItem(
      name: 'Ramen tradicional',
      category: 'Ramen',
      description: 'Macarrão em caldo quente com carne suína, ovo e legumes.',
      price: 38.50,
      imageUrl: 'https://via.placeholder.com/120x120',
      isNew: true,
      nutritionalInfo: {
        'Calorias': '480 kcal',
        'Proteínas': '22g',
        'Carboidratos': '65g',
        'Gorduras': '12g',
      },
    ),
    MenuItem(
      name: 'Sashimi de salmão',
      category: 'Sashimi',
      description: 'Fatias finas de salmão fresco. Porção com 10 fatias.',
      price: 42.00,
      imageUrl: 'https://via.placeholder.com/120x120',
      nutritionalInfo: {
        'Calorias': '220 kcal',
        'Proteínas': '26g',
        'Carboidratos': '0g',
        'Gorduras': '12g',
      },
    ),
    MenuItem(
      name: 'Tempura misto',
      category: 'Tempura',
      description: 'Legumes e camarões empanados e fritos. Acompanha molho.',
      price: 36.90,
      imageUrl: 'https://via.placeholder.com/120x120',
      nutritionalInfo: {
        'Calorias': '380 kcal',
        'Proteínas': '14g',
        'Carboidratos': '32g',
        'Gorduras': '22g',
      },
    ),
    MenuItem(
      name: 'Mochi de matcha',
      category: 'Sobremesas',
      description:
          'Doce japonês feito de arroz com recheio de sorvete de chá verde.',
      price: 18.90,
      imageUrl: 'https://via.placeholder.com/120x120',
      discount: 15,
      nutritionalInfo: {
        'Calorias': '180 kcal',
        'Proteínas': '2g',
        'Carboidratos': '36g',
        'Gorduras': '4g',
      },
    ),
    MenuItem(
      name: 'Sake tradicional',
      category: 'Bebidas',
      description:
          'Bebida alcoólica japonesa feita de arroz fermentado. 180ml.',
      price: 32.00,
      imageUrl: 'https://via.placeholder.com/120x120',
      isNew: true,
      nutritionalInfo: {
        'Calorias': '240 kcal',
        'Proteínas': '0g',
        'Carboidratos': '5g',
        'Gorduras': '0g',
        'Álcool': '15-16%',
      },
    ),
  ];

  List<MenuItem> get filteredItems {
    if (selectedCategory == 'Todos') {
      return menuItems;
    }
    return menuItems
        .where((item) => item.category == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF121212),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF121212)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Categories with horizontal scroll
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children:
                      categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: selectedCategory == category,
                            onSelected: (selected) {
                              setState(() {
                                selectedCategory = category;
                                selectedMenuItem = null;
                                _fadeController.reset();
                                _fadeController.forward();
                              });
                            },
                            backgroundColor: Colors.grey.shade100,
                            selectedColor: const Color(0xFFD4AF37),
                            checkmarkColor: Colors.black,
                            labelStyle: TextStyle(
                              color:
                                  selectedCategory == category
                                      ? Colors.black
                                      : Colors.grey.shade800,
                              fontWeight:
                                  selectedCategory == category
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),

            // Menu items with staggered animation
            Expanded(
              child:
                  selectedMenuItem == null
                      ? FadeTransition(
                        opacity: _fadeController,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredItems.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedMenuItem = item;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
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
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Image with gold accent
                                      Stack(
                                        children: [
                                          Hero(
                                            tag: 'menu-item-${item.name}',
                                            child: Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  item.imageUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return Container(
                                                      color:
                                                          Colors.grey.shade100,
                                                      child: Center(
                                                        child: Icon(
                                                          Icons
                                                              .image_not_supported_outlined,
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade400,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (item.discount != null ||
                                              item.isNew)
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      item.discount != null
                                                          ? const Color(
                                                            0xFFD4AF37,
                                                          )
                                                          : Colors.black,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(8),
                                                        bottomLeft:
                                                            Radius.circular(8),
                                                      ),
                                                ),
                                                child: Text(
                                                  item.discount != null
                                                      ? '${item.discount}% OFF'
                                                      : 'NOVO',
                                                  style: TextStyle(
                                                    color:
                                                        item.discount != null
                                                            ? Colors.black
                                                            : Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(width: 12),
                                      // Description and button
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF121212),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item.description,
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 14,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'R\$ ${item.price.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFFD4AF37),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    'Pedir',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      : MenuDetailView(
                        item: selectedMenuItem!,
                        onBack: () {
                          setState(() {
                            selectedMenuItem = null;
                          });
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _staggeredController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _staggeredController.forward();
    _fadeController.forward();
  }
}
