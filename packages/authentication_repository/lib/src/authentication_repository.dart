import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:user_repository/user_repository.dart';

// Create storage

enum AuthenticationStatus { unknown, authenticated, unauthenticated, emailVerified, emailNotVerified }

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

  Future<Either<Register, Message>> signUp({
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

      final firstResponse = response.first;

      await storage.write(key: key, value: firstResponse.token);

      _controller.add(AuthenticationStatus.authenticated);
      return Left(firstResponse);
    } catch (e) {
      _controller.add(AuthenticationStatus.unauthenticated);

      if (e is Map<String, dynamic>) {
        return Right(Message.fromJson(e));
      }

      return Right(Message(message: 'Unexpected error occurred.'));
    }
  }

  Future<Either<Login, Message>> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await postRequest<Login>('/login', {
        'email': email,
        'password': password,
      }, Login.fromJson);

      final firstResponse = response.first;

      await storage.write(key: key, value: firstResponse.token);

      _controller.add(AuthenticationStatus.authenticated);
      return Left(firstResponse);
    } catch (e) {
      _controller.add(AuthenticationStatus.unauthenticated);

      if (e is Map<String, dynamic>) {
        return Right(Message.fromJson(e));
      }

      return Right(Message(message: 'Unexpected error occurred.'));
    }
  }

  Future<Message> verifyEmail({
    required int id,
    required String hash,
    required String expires,
    required String signature,
  }) async {
    try {
      final response = await getRequest<Message>(
        '/email/verify/$id/$hash?expires=$expires&signature=$signature',
        Message.fromJson,
        headers: {'Authorization': 'Bearer ${await storage.read(key: key)}'},
      );

      final firstResponse = response.first;

      if (response.isEmpty) {
        return Message(message: 'No response from server.');
      }

      return Message(message: firstResponse.message);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        return Message.fromJson(e);
      }

      return Message(message: 'Unexpected error occurred.');
    }
  }

  Future<void> logOut() async {
    try {
      await getRequest<Register>(
        '/logout',
        Register.fromJson,
        headers: {'Authorization': 'Bearer ${await storage.read(key: key)}'},
      );
      await storage.delete(key: key);
    } catch (e) {
      return;
    }
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
