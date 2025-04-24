import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('data'),

      ),

      
      body:ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Icon(Icons.person_2_outlined),
            ),
            title: const Text('data'),
            subtitle: const Text('data'),
            onTap: () => context.push('/basic-prompt')),
          
        ],
      ),
    );
  }
}