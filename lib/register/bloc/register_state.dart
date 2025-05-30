part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final FormzSubmissionStatus status;
  final Username username;
  final Email email;
  final Password password;
  final Term acceptTerm;
  final bool isValid;
  final ErrorMessage? errorMessage;

  const RegisterState({
    this.status = FormzSubmissionStatus.initial,
    this.username = const Username.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.acceptTerm = const Term.pure(),
    this.isValid = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    FormzSubmissionStatus? status,
    Username? username,
    Email? email,
    Password? password,
    Term? acceptTerm,
    bool? isValid,
    ErrorMessage? errorMessage,
  }) {
    return RegisterState(
      status: status ?? this.status,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      acceptTerm: acceptTerm ?? this.acceptTerm,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, username, email, password];
}