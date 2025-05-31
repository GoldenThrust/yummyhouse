import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yummyhouse/authentication/bloc/authentication_bloc.dart';
import 'package:yummyhouse/authentication/view/verify_email.dart';
import 'package:yummyhouse/home/view/home_page.dart';
import 'package:yummyhouse/login/view/login_page.dart';
import 'package:yummyhouse/onboarding/onboarding.dart';
import 'package:yummyhouse/register/view/register_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yummyhouse/splash/view/splash.dart';
import 'package:yummyhouse/termandpolicy/view/termandpolicy_page.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

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
      routerConfig: GoRouter(
        initialLocation: '/home',
        redirect: (context, state) {
          final authState = context.read<AuthenticationBloc>().state;

          final loggingIn =
              state.fullPath == '/login' ||
              state.fullPath == '/register' ||
              state.fullPath == '/' ||
              state.fullPath == '/policy/:policy' || state.fullPath == '/verify/:id/:hash';

            print('Location is: ${state.fullPath} AuthenticationStatus: ${authState.status} $loggingIn');

          if (authState.status == AuthenticationStatus.authenticated &&
              loggingIn) {
            return '/home';
          }

          if (authState.status == AuthenticationStatus.unauthenticated &&
              !loggingIn) {
            return '/';
          }

          return null;
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              final authStatus =
                  context.read<AuthenticationBloc>().state.status;
              if (authStatus == AuthenticationStatus.unknown) {
                return const SplashPage();
              }
              return const GettingStarted();
            },
          ),
          GoRoute(
            path: '/register',
            builder: (context, state) => const RegisterPage(),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(path: '/home', builder: (context, state) => const HomePage()),
          GoRoute(
            path: '/policy/:policy',
            builder:
                (context, state) => TermandPolicyPage(
                  policy: state.pathParameters['policy'] ?? 'term',
                ),
          ),
          GoRoute(
            path: '/verify/:id/:hash',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              final hash = state.pathParameters['hash'] ?? '';
              final expires = state.uri.queryParameters['expires'] ?? '';
              final signature = state.uri.queryParameters['signature'] ?? '';

              if (id == null ||
                  hash.isEmpty ||
                  expires.isEmpty ||
                  signature.isEmpty) {
                return const Scaffold(
                  body: Center(child: Text('Invalid verification link')),
                );
              }

              return VerifyEmail(
                id: id,
                hash: hash,
                expires: expires,
                signature: signature,
              );
            },
          ),
        ],
      ),
    );
  }
}
