import 'package:flutter/material.dart';

class FeaturedDishesSection extends StatelessWidget {
  final VoidCallback onViewMenuPressed;

  const FeaturedDishesSection({Key? key, required this.onViewMenuPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 40, height: 2, color: const Color(0xFFD4AF37)),
              const SizedBox(width: 16),
              const Text(
                'ESPECIALIDADES',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Nossos pratos em destaque',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 40),

          // Featured dishes grid
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
                'https://via.placeholder.com/300x400',
              ),
              _buildFeaturedDish(
                'Ramen tradicional',
                'Macarrão em caldo rico com carne suína e legumes',
                'https://via.placeholder.com/300x400',
              ),
              _buildFeaturedDish(
                'Sashimi fresco',
                'Fatias de peixe premium servidas com wasabi e gengibre',
                'https://via.placeholder.com/300x400',
              ),
              _buildFeaturedDish(
                'Tempura misto',
                'Legumes e camarões empanados e fritos com molho especial',
                'https://via.placeholder.com/300x400',
              ),
            ],
          ),

          const SizedBox(height: 40),

          // CTA button
          Center(
            child: _buildGoldButton(
              onPressed: onViewMenuPressed,
              child: const Text(
                'Ver cardápio completo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedDish(String title, String description, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade900,
                child: Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 32,
                    color: Colors.grey.shade700,
                  ),
                ),
              );
            },
          ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Gold accent
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              width: 30,
              height: 3,
              decoration: const BoxDecoration(
                color: Color(0xFFD4AF37),
                borderRadius: BorderRadius.all(Radius.circular(1.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoldButton({
    required VoidCallback onPressed,
    required Widget child,
    double height = 50,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFD4AF37),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4AF37).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
