import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yummyhouse/app.dart';
import 'package:yummyhouse/authentication/bloc/authentication_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;
  Hive.registerAdapter(
    'User',
    (json) => User.fromJson(json.cast<String, dynamic>()),
  );
  
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
