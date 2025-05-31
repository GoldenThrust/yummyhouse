part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

class AuthenticationSubscriptionRequested extends AuthenticationEvent {
  const AuthenticationSubscriptionRequested();
}

class AuthenticationVerifyEmailRequested extends AuthenticationEvent {
  int id;
  String hash;
  String expires;
  String signature;
  AuthenticationVerifyEmailRequested({
    required this.id,
    required this.hash,
    required this.expires,
    required this.signature,
  });
}

class AuthenticationUser extends AuthenticationEvent {
  const AuthenticationUser();
}

class AuthenticationLoggedOut extends AuthenticationEvent {
  const AuthenticationLoggedOut();
}