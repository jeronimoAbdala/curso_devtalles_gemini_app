import 'package:flutter/material.dart';

class WaitlistButton extends StatelessWidget {
  final VoidCallback onPressed;

  const WaitlistButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: Colors.white.withOpacity(0.3), // border-white/30
        ),
        backgroundColor: Colors.white.withOpacity(0.2), // bg-white/20
        foregroundColor: Colors.white, // text color
        minimumSize: const Size.fromHeight(36), // h-9 (aprox 36px)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // rounded-md
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12), // px-3
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      child: const Text('Join to waitlist'),
    );
  }
}
