import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermandPolicyPage extends StatelessWidget {
  final String policy;

  const TermandPolicyPage({super.key, this.policy = 'term'});

  static const Map<String, String> policies = {
    'term': 'Terms of Service',
    'privacy': 'Privacy Policy',
  };

  @override
  Widget build(BuildContext context) {
    final String title = policies[policy] ?? 'Terms and Policy';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/register');
          },
        ),
        title: Text(title),
      ),
      body: Center(child: Text('$title content goes here.')),
    );
  }
}
