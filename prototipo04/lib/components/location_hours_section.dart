import 'package:flutter/material.dart';

import 'info_row.dart';

class LocationHoursSection extends StatelessWidget {
  final VoidCallback onReservePressed;

  const LocationHoursSection({Key? key, required this.onReservePressed})
    : super(key: key);

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
                'VISITE-NOS',
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
            'Horários e localização',
            style: TextStyle(
              color: Color(0xFF121212),
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 40),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Horários',
                              style: TextStyle(
                                color: Color(0xFF121212),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const InfoRow(
                              icon: Icons.access_time,
                              text: 'Seg - Sex: 11:30 - 22:00',
                            ),
                            const InfoRow(
                              icon: Icons.access_time,
                              text: 'Sáb - Dom: 12:00 - 23:00',
                            ),
                            const SizedBox(height: 32),
                            const Text(
                              'Contato',
                              style: TextStyle(
                                color: Color(0xFF121212),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const InfoRow(
                              icon: Icons.phone,
                              text: '+55 (41) 99999-9999',
                            ),
                            const InfoRow(
                              icon: Icons.email,
                              text: 'contato@kan.com',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Endereço',
                              style: TextStyle(
                                color: Color(0xFF121212),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const InfoRow(
                              icon: Icons.location_on,
                              text:
                                  'Rua Mateus Leme, 123 - Centro, Curitiba, PR',
                            ),
                            const SizedBox(height: 16),
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
                      const Text(
                        'Horários',
                        style: TextStyle(
                          color: Color(0xFF121212),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const InfoRow(
                        icon: Icons.access_time,
                        text: 'Seg - Sex: 11:30 - 22:00',
                      ),
                      const InfoRow(
                        icon: Icons.access_time,
                        text: 'Sáb - Dom: 12:00 - 23:00',
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Contato',
                        style: TextStyle(
                          color: Color(0xFF121212),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const InfoRow(
                        icon: Icons.phone,
                        text: '+55 (41) 99999-9999',
                      ),
                      const InfoRow(icon: Icons.email, text: 'contato@kan.com'),
                      const SizedBox(height: 32),
                      const Text(
                        'Endereço',
                        style: TextStyle(
                          color: Color(0xFF121212),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const InfoRow(
                        icon: Icons.location_on,
                        text: 'Rua Mateus Leme, 123 - Centro, Curitiba, PR',
                      ),
                      const SizedBox(height: 16),
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
                      ),
                    ],
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 40),

          Center(
            child: _buildOutlinedGoldButton(
              onPressed: onReservePressed,
              child: const Text(
                'Fazer reserva',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedGoldButton({
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
          border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
        ),
        child: Center(child: child),
      ),
    );
  }
}
