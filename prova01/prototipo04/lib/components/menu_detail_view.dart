import 'package:flutter/material.dart';

import '../models/menu_item.dart';

class MenuDetailView extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onBack;

  const MenuDetailView({Key? key, required this.item, required this.onBack})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          GestureDetector(
            onTap: onBack,
            child: Row(
              children: [
                const Icon(Icons.arrow_back, color: Color(0xFFD4AF37)),
                const SizedBox(width: 8),
                const Text(
                  'Voltar ao cardápio',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Item image with gradient overlay
          Hero(
            tag: 'menu-item-${item.name}',
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      item.imageUrl.replaceAll('120x120', '400x300'),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade100,
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (item.discount != null || item.isNew)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              item.discount != null
                                  ? const Color(0xFFD4AF37)
                                  : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
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
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                  // Gold accent line
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      width: 40,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4AF37),
                        borderRadius: BorderRadius.all(Radius.circular(1.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Item name and details
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF121212),
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.category,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'R\$ ${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD4AF37),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text(
            item.description,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // Nutritional information with Table
          const Text(
            'Informações nutricionais',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF121212),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(color: Colors.grey.shade200),
                ),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFF121212)),
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
                  ...item.nutritionalInfo.entries.map((entry) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            entry.key,
                            style: TextStyle(color: Colors.grey.shade800),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            entry.value,
                            style: TextStyle(color: Colors.grey.shade800),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Order button with gold color
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Adicionar ao pedido',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
