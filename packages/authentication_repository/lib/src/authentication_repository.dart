import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:user_repository/user_repository.dart';

// Create storage

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    final token = await storage.read(key: key);
    final user = await UserRepository().getUser(token);

    if (user != null) {
      yield AuthenticationStatus.authenticated;
    } else {
      yield AuthenticationStatus.unauthenticated;
    }
    yield* _controller.stream;
  }

  Future<Either<Register, ErrorMessage>> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await postRequest<Register>('/register', {
        'email': email,
        'name': username,
        'password': password,
      }, Register.fromJson);


      await storage.write(key: key, value: response.token);

      _controller.add(AuthenticationStatus.authenticated);
      return Left(response);
    } catch (e) {
      _controller.add(AuthenticationStatus.unauthenticated);

      if (e is Map<String, dynamic>) {
        return Right(ErrorMessage.fromJson(e));
      }

      return Right(ErrorMessage(message: 'Unexpected error occurred.'));
    }
  }

  Future<Either<Login, ErrorMessage>> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await postRequest<Login>('/login', {
        'email': email,
        'password': password,
      }, Login.fromJson);

      await storage.write(key: key, value: response.token);

      _controller.add(AuthenticationStatus.authenticated);
      return Left(response);
    } catch (e) {
      _controller.add(AuthenticationStatus.unauthenticated);
  
      if (e is Map<String, dynamic>) {
        return Right(ErrorMessage.fromJson(e));
      }

      return Right(ErrorMessage(message: 'Unexpected error occurred.'));
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
