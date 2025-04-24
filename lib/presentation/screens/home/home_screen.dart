import 'package:flutter/material.dart';

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
          )
        ],
      ),
    );
  }
}