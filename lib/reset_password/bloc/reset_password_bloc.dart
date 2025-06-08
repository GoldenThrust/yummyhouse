import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:yummyhouse/authentication/models/email.dart';
import 'package:yummyhouse/authentication/models/password.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:yummyhouse/authentication/models/term.dart';
import 'package:yummyhouse/authentication/models/username.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({required AuthenticationRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository,
      super(const ResetPasswordState()) {
    on<ResetPasswordEmailChanged>(_onEmailChanged);
    on<ResetPasswordPasswordChanged>(_onPasswordChanged);
    on<ResetPasswordPasswordConfirmationChanged>(_onPasswordComfirmationChanged);
    on<ResetPasswordSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onEmailChanged(
    ResetPasswordEmailChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([
          email,
          state.password,
          state.passwordConfirmation,
        ]),
      ),
    );
  }

  void _onPasswordChanged(
    ResetPasswordPasswordChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([
          state.email,
          password,
          state.passwordConfirmation,
        ]),
      ),
    );
  }

  void _onPasswordComfirmationChanged(
    ResetPasswordPasswordConfirmationChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    final passwordConfirmation = Password.dirty(event.passwordConfirmation);
    emit(
      state.copyWith(
        passwordConfirmation: passwordConfirmation,
        isValid: Formz.validate([
          state.email,
          state.password,
          passwordConfirmation,
        ]),
      ),
    );
  }

  Future<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final Either response = await _authenticationRepository.resetPassword(
        email: state.email.value,
        password: state.password.value,
        passwordConfirmation: state.passwordConfirmation.value,
        token: event.token,
      );

      response.fold(
        (response) {
          emit(state.copyWith(responseMessage: response, status: FormzSubmissionStatus.success));
        },
        (error) {
          // Handle ResetPassword error
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage:
                  error is Message
                      ? error
                      : Message(message: 'ResetPassword failed'),
            ),
          );
        },
      );
    } else {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: Message(message: 'Invalid credentials'),
        ),
      );
    }
  }
}
