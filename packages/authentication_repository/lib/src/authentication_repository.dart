import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:core/core.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Create storage
final storage = FlutterSecureStorage();
final key = 'secure_token';

enum AuthenticationStatus { authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    final user = await UserRepository().getUser();

    if (user != null) {
      yield AuthenticationStatus.authenticated;
    } else {
      yield AuthenticationStatus.unauthenticated;
    }
    yield* _controller.stream;
  }

  Future<void> signUp({
    required String username,
    required String password,
  }) async {
    try {
      await postRequest<Register>('/signup', {
        'username': username,
        'password': password,
      }, Register.fromJson);

      _controller.add(AuthenticationStatus.authenticated);
    } catch (e) {
      print('Sign up failed: $e');
      _controller.add(AuthenticationStatus.unauthenticated);
    }
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    try {
      final response = await postRequest<Register>('/login', {
        'username': username,
        'password': password,
      }, Register.fromJson);

      await storage.write(key: key, value: response.token);

      _controller.add(AuthenticationStatus.authenticated);
    } catch (e) {
      _controller.add(AuthenticationStatus.unauthenticated);
    }
  }

  Future<void> logOut() async {
    try {
      await getRequest<Register>('/logout', Register.fromJson);
      await storage.delete(key: key);
    } catch (e) {
      return;
    }
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
