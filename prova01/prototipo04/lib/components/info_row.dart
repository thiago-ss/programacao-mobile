import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoRow({Key? key, required this.icon, required this.text})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFFD4AF37)),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
