import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/images/logo.png'),
            width: 300,
            height: 300,
          ),
          SizedBox(height: 10),
          CircularProgressIndicator(color: Colors.deepOrange),
        ],
      )),
    );
  }
}