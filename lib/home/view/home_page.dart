import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.restaurant_menu),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Action for shopping cart
            },
          ),
        ],
        title: Text('Yummy House'),
      ),
      body: Text('Welcome to Homepage'),
    );
  }
}