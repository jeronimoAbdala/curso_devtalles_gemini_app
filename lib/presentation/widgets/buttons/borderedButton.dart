import 'package:flutter/material.dart';

class BorderedButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BorderedButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF006064), // text-ocean-700
        side: const BorderSide(color: Color(0xFFB2E3F5)), // border-ocean-300
        backgroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // rounded-md
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      child: const Text('Ver análisis detallado'),
    );
  }
}
