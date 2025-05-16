import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class NameInputDialog extends StatefulWidget {
  final int score;
  final int level;

  const NameInputDialog({super.key, required this.score, required this.level});

  @override
  State<NameInputDialog> createState() => _NameInputDialogState();
}

class _NameInputDialogState extends State<NameInputDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFFF00FF), width: 3),
        ),
        title: Text(
          'novo recorde!',
          style: GoogleFonts.pressStart2p(color: Colors.amber, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'pontuacao: ${widget.score}',
              style: GoogleFonts.pressStart2p(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'nivel: ${widget.level}',
              style: GoogleFonts.pressStart2p(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'digite seu nome:',
              style: GoogleFonts.pressStart2p(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF00FFFF), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FFFF).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                style: GoogleFonts.pressStart2p(
                  color: Colors.white,
                  fontSize: 12,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: InputBorder.none,
                  hintText: 'jogador',
                  hintStyle: GoogleFonts.pressStart2p(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 12,
                  ),
                ),
                maxLength: 10,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                textCapitalization: TextCapitalization.characters,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  // Converter para maiúsculas
                  final upperCaseText = value.toUpperCase();
                  if (value != upperCaseText) {
                    _controller.value = _controller.value.copyWith(
                      text: upperCaseText,
                      selection: TextSelection.collapsed(
                        offset: upperCaseText.length,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).pop();
            },
            child: Text(
              'cancelar',
              style: GoogleFonts.pressStart2p(color: Colors.grey, fontSize: 10),
            ),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              final name =
                  _controller.text.trim().isEmpty
                      ? 'JOGADOR'
                      : _controller.text.trim();
              Navigator.of(context).pop(name);
            },
            child: Text(
              'salvar',
              style: GoogleFonts.pressStart2p(
                color: const Color(0xFF00FFFF),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _animController.forward();
  }
}
