import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yummyhouse/app.dart';
import 'package:yummyhouse/authentication/bloc/authentication_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider(
          create: (_) => AuthenticationRepository(),
          dispose: (repository) => repository.dispose(),
        ),
        RepositoryProvider(create: (_) => UserRepository()),
      ],
      child: BlocProvider(
        lazy: false,
        create:
            (context) => AuthenticationBloc(
              authenticationrepository:
                  context.read<AuthenticationRepository>(),
              userRepository: context.read<UserRepository>(),
            )..add(AuthenticationSubscriptionRequested()),
        child: const YummyHouse(title: 'Yummy House'),
      ),
    );
  }
}
