part of 'reset_password_bloc.dart';

class ResetPasswordState extends Equatable {
  final FormzSubmissionStatus status;
  final Username username;
  final Email email;
  final Password password;
  final Password passwordConfirmation;
  final Term acceptTerm;
  final bool isValid;
  final Message? responseMessage;
  final Message? errorMessage;

  const ResetPasswordState({
    this.status = FormzSubmissionStatus.initial,
    this.username = const Username.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.passwordConfirmation = const Password.pure(),
    this.acceptTerm = const Term.pure(),
    this.isValid = false,
    this.responseMessage,
    this.errorMessage,
  });

  ResetPasswordState copyWith({
    FormzSubmissionStatus? status,
    Username? username,
    Email? email,
    Password? password,
    Password? passwordConfirmation,
    Term? acceptTerm,
    bool? isValid,
    Message? responseMessage,
    Message? errorMessage,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      acceptTerm: acceptTerm ?? this.acceptTerm,
      isValid: isValid ?? this.isValid,
      responseMessage: responseMessage ?? this.responseMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, username, email, password, passwordConfirmation, acceptTerm];
}