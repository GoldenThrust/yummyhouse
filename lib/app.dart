import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yummyhouse/login/view/login_page.dart';
import 'package:yummyhouse/onboarding/onboarding.dart';
import 'package:yummyhouse/register.dart/view/register_page.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const GettingStarted()),
    GoRoute(path: '/register', builder: (context, state) => const Register()),
    GoRoute(path: '/login', builder: (context, state) => const Login()),
  ],
);

class YummyHouse extends StatelessWidget {
  const YummyHouse({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Yummy House',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      routerConfig: _router,
    );
  }
}
