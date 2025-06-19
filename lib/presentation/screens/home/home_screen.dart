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
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.history_outlined),
            ),
            title: const Text('Chat conversacional'),
            subtitle: const Text('Mantener el contexto de mensajes'),
            onTap: () => context.push('/history-chat'),
          ),

          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.image_outlined),
            ),
            title: const Text('Generación de imágenes'),
            subtitle: const Text('Crea y edita imágenes con AI'),
            onTap: () => context.push('/image-playground'),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.file_copy_sharp),
            ),
            title: const Text('Fishing Calculator'),
            subtitle: const Text('Calcula y mostra los detalles de tu pesca '),
            onTap: () => context.push('/fishingCalculator'),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.personal_injury),
            ),
            title: const Text('Cuenta personal'),
            subtitle: const Text('Calcula y mostra los detalles de tu pesca '),
            onTap: () => context.push('/ProfileScreen'),
          ),
        ],
      ),
    );
  }
}
