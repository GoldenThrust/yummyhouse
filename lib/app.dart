import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:yummyhouse/authentication/authentication.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yummyhouse/main/checkout/view/checkout_page.dart';
import 'package:yummyhouse/main/home/view/home_page.dart';
import 'package:yummyhouse/home_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yummyhouse/main/like_items/view/like_items_page.dart';
import 'package:yummyhouse/main/ongoing_delivery/view/ongoing_delivery_page.dart';
import 'package:yummyhouse/main/profile/view/profile_page.dart';
import 'package:yummyhouse/splash/view/splash.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'RootNavigator',
);
// final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
//   debugLabel: 'ShellNavigator',
// );

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
        navigatorKey: _rootNavigatorKey,
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
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
          ShellRoute(
            // navigatorKey: _shellNavigatorKey,
            builder: (context, state, child) {
              return HomeNavigationBar(
                location: state.uri.toString(),
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
              GoRoute(
                path: '/ongoing-delivery',
                builder: (context, state) => const OngoingDeliveryPage(),
              ),
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CheckoutPage(),
              ),
              GoRoute(
                path: '/favorite',
                builder: (context, state) => const LikeItemsPage(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChecKOutPage {
  const ChecKOutPage();
}
