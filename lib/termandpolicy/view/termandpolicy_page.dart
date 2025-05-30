import 'package:flutter/material.dart';

class TermandPolicyPage extends StatelessWidget {
  const TermandPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Policy'),
      ),
      body: const Center(
        child: Text('Terms and Policy content goes here.'),
      ),
    );
  }
}