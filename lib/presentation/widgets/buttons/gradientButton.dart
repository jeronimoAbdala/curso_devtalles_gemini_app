import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GradientButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF00BCD4), // ocean start
              Color(0xFF26C6DA), // wave end
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18), // rounded-xl
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.flash_on, // similar al "zap" icon
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Analizar con IA',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
