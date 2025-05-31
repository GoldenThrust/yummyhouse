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
       super(const AuthenticationState.unauthenticated()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationVerifyEmailRequested>(_onVerifyEmailRequested);
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
          case AuthenticationStatus.emailVerified:
            return emit(const AuthenticationState.emailVerified());
          case AuthenticationStatus.emailNotVerified:
            return emit(const AuthenticationState.emailNotVerified());
          case AuthenticationStatus.unknown:
            return emit(const AuthenticationState.unknown());
        }
      },
      onError: addError,
    );
  }

  Future<void> _onVerifyEmailRequested(
    AuthenticationVerifyEmailRequested event,
    Emitter<AuthenticationState> emit
  ) async {
    try {
      await _authenticationrepository.verifyEmail(
        id: event.id,
        hash: event.hash,
        expires: event.expires,
        signature: event.signature,
      );

      emit(const AuthenticationState.emailVerified());
    } catch (e) {
      emit(const AuthenticationState.unauthenticated());
      return;
    }
  } 

  Future<void> _onLoggedOut(
    AuthenticationLoggedOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      await _authenticationrepository.logOut();
      emit(const AuthenticationState.unauthenticated());
    } catch (e) {
      emit(const AuthenticationState.unauthenticated());
    }
  }
}
