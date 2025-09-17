import 'package:flutter/material.dart';

class TVHomePage extends StatefulWidget {
  const TVHomePage({super.key});

  @override
  State<TVHomePage> createState() => _TVHomePageState();
}

class _TVHomePageState extends State<TVHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TV Home Page')),
      body: const Center(child: Text('Welcome to the TV Home Page!')),
    );
  }
}
