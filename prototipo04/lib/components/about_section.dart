import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 40, height: 2, color: const Color(0xFFD4AF37)),
              const SizedBox(width: 16),
              const Text(
                'NOSSA HISTÓRIA',
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
            'Tradição e elegância em cada detalhe',
            style: TextStyle(
              color: Color(0xFF121212),
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Fundado em 2020, o Kan nasceu da paixão pela culinária japonesa e do desejo de oferecer uma experiência gastronômica autêntica. Nossa equipe de chefs especializados prepara cada prato com ingredientes frescos e técnicas tradicionais, trazendo o verdadeiro sabor do Japão para sua mesa.',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nosso ambiente foi cuidadosamente projetado para proporcionar uma atmosfera elegante e acolhedora, onde cada detalhe reflete a estética e a filosofia japonesa.',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),

          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: const Color(0xFFD4AF37),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: const Text(
                                  'Ingredientes premium',
                                  style: TextStyle(
                                    color: Color(0xFF121212),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Selecionamos apenas os melhores e mais frescos ingredientes',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.restaurant,
                                color: const Color(0xFFD4AF37),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: const Text(
                                  'Chefs especializados',
                                  style: TextStyle(
                                    color: Color(0xFF121212),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Nossa equipe é treinada nas mais tradicionais técnicas japonesas',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: const Color(0xFFD4AF37),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: const Text(
                            'Ingredientes premium',
                            style: TextStyle(
                              color: Color(0xFF121212),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Selecionamos apenas os melhores e mais frescos ingredientes',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(
                          Icons.restaurant,
                          color: const Color(0xFFD4AF37),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: const Text(
                            'Chefs especializados',
                            style: TextStyle(
                              color: Color(0xFF121212),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Nossa equipe é treinada nas mais tradicionais técnicas japonesas',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
