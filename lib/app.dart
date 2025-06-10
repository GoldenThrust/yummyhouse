import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yummyhouse/authentication/bloc/authentication_bloc.dart';
import 'package:yummyhouse/authentication/view/verify_email.dart';
import 'package:yummyhouse/forgot_password/view/forgot_password_page.dart';
import 'package:yummyhouse/home/view/home_page.dart';
import 'package:yummyhouse/login/view/login_page.dart';
import 'package:yummyhouse/onboarding/onboarding.dart';
import 'package:yummyhouse/register/view/register_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yummyhouse/reset_password/reset_password.dart';
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
        initialLocation: '/',
        refreshListenable: GoRouterRefreshStream(
          context.read<AuthenticationBloc>().stream,
        ),
        redirect: (context, state) {
          final user = yummyHouseHive.get('user');
          final authState = context.read<AuthenticationBloc>().state;
          final location = state.matchedLocation;

          final isPublicRoute =
              location == '/' ||
              location == '/login' ||
              location == '/register' ||
              location == '/reset-password' ||
              location == '/forgot-password' ||
              location.startsWith('/policy') ||
              location.startsWith('/verify');

          final isAuthenticated =
              (authState.status == AuthenticationStatus.authenticated) ||
              user != null;
          final isUnauthenticated =
              (authState.status == AuthenticationStatus.unauthenticated) ||
              user == null;

          if (isAuthenticated && isPublicRoute) return '/home';
          if (isUnauthenticated && !isPublicRoute) return '/';

          return null;
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, authState) {
                  if (authState.status == AuthenticationStatus.unknown) {
                    return const SplashPage();
                  }
                  return const GettingStarted();
                },
              );
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
          GoRoute(
            path: '/forgot-password',
            builder: (context, state) => const ForgotPasswordPage(),
          ),
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

              return BlocProvider(
                create: (context) {
                  return EmailVericationBloc(
                    authenticationRepository:
                        context.read<AuthenticationRepository>(),
                  );
                },
                child: VerifyEmail(
                  id: id,
                  hash: hash,
                  expires: expires,
                  signature: signature,
                ),
              );
            },
          ),
          GoRoute(path: '/home', builder: (context, state) => const HomePage()),
          GoRoute(
            path: '/reset-password',
            builder: (context, state) {
              final token = state.uri.queryParameters['token'] ?? '';

              if (token.isEmpty) {
                return const Scaffold(
                  body: Center(child: Text('Invalid token')),
                );
              }

              return ResetPasswordPage(token: token);
            },
          ),
        ],
      ),
    );
  }
}
