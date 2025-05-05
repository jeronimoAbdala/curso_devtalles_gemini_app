import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Gemini')),
      body: ListView(
      
        children: [
          ListTile(
        
            leading: const CircleAvatar(
              backgroundColor: Colors.pink,
              child: Icon(Icons.person_outline),
            ),
            title: const Text('Prompt básico a Gemini'),
            subtitle: const Text('Usando un modelo flash'),
            onTap: () => context.push('/basic-prompt'),
          ),
          ListTile(
        
            leading: const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 30, 40, 233),
              child: Icon(Icons.person_outline),
            ),
            title: const Text('Chat conversacional'),
            subtitle: const Text('Mantener el contexto del mensaje'),
            onTap: () => context.push('/history-chat'),
          ),
        ],
      ),
    );
  }
}