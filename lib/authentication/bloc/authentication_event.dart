part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

class AuthenticationSubscriptionRequested extends AuthenticationEvent {
  const AuthenticationSubscriptionRequested();
}

class AuthenticationLoggedOut extends AuthenticationEvent {
  const AuthenticationLoggedOut();
}