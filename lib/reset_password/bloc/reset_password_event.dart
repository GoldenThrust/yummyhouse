
part of 'reset_password_bloc.dart';
sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];
}


class ResetPasswordEmailChanged extends ResetPasswordEvent {
  final String email;

  const ResetPasswordEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class ResetPasswordPasswordChanged extends ResetPasswordEvent {
  final String password;

  const ResetPasswordPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class ResetPasswordPasswordConfirmationChanged extends ResetPasswordEvent {
  final String passwordConfirmation;

  const ResetPasswordPasswordConfirmationChanged(this.passwordConfirmation);

  @override
  List<Object?> get props => [passwordConfirmation];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String token;
  const ResetPasswordSubmitted(this.token);

  @override
  List<Object?> get props => [token];
}
