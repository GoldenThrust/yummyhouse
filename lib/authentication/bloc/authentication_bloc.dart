import 'package:authentication_repository/authentication_repository.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationrepository;
  final UserRepository _userRepository;

  AuthenticationBloc({
    required AuthenticationRepository authenticationrepository,
    required UserRepository userRepository,
  }) : _authenticationrepository = authenticationrepository,
       _userRepository = userRepository,
       super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationUser>(_onGetUser);
    on<AuthenticationLoggedOut>(_onLoggedOut);
  }

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    return emit.onEach(
      _authenticationrepository.status,
      onData: (status) async {
        switch (status) {
          case AuthenticationStatus.unauthenticated:
            return emit(const AuthenticationState.unauthenticated());
          case AuthenticationStatus.authenticated:
            final token = await storage.read(key: key);
            final user = await _userRepository.getUser(token);
            return emit(
              user != null
                  ? AuthenticationState.authenticated(user)
                  : const AuthenticationState.unauthenticated(),
            );
          case AuthenticationStatus.unknown:
            return emit(const AuthenticationState.unknown());
        }
      },
      onError: addError,
    );
  }

  Future<void> _onGetUser(
    AuthenticationUser event,
    Emitter<AuthenticationState> emit,
  ) async {
    final token = await storage.read(key: key);
    final user = await _userRepository.getUser(token);

    return emit(
      user != null
          ? AuthenticationState.authenticated(user)
          : const AuthenticationState.unauthenticated(),
    );
  }

  Future<void> _onLoggedOut(
    AuthenticationLoggedOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    yummyHouseHive.delete('user');
    try {
      await _authenticationrepository.logOut();
      emit(const AuthenticationState.unauthenticated());
    } catch (e, stackTrace) {
      print('Error is $e, Trace $stackTrace');
      emit(const AuthenticationState.unauthenticated());
    }
  }
}

class EmailVericationBloc
    extends Bloc<AuthenticationVerifyEmailRequested, EmailVerificationState> {
  final AuthenticationRepository _authenticationRepository;

  EmailVericationBloc({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository,
       super(EmailVerificationState.notVerified) {
    on<AuthenticationVerifyEmailRequested>(_onVerifyEmailRequested);
  }

  Future<void> _onVerifyEmailRequested(
    AuthenticationVerifyEmailRequested event,
    Emitter<EmailVerificationState> emit,
  ) async {
    try {
      await _authenticationRepository.verifyEmail(
        id: event.id,
        hash: event.hash,
        expires: event.expires,
        signature: event.signature,
      );
      emit(EmailVerificationState.verified);
    } catch (e) {
      emit(EmailVerificationState.notVerified);
    }
  }
}
