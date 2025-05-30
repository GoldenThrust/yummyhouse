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

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required AuthenticationRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository,
      super(const RegisterState()) {
    on<RegisterUsernameChanged>(_onUsernameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterTermChanged>(_onTermChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onUsernameChanged(RegisterUsernameChanged event, Emitter<RegisterState> emit) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([username, state.email, state.password, state.acceptTerm]),
      )
    );
  }

  void _onEmailChanged(RegisterEmailChanged event, Emitter<RegisterState> emit) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([state.username, email, state.password, state.acceptTerm]),
      ),
    );
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.username, state.email, password, state.acceptTerm]),
      ),
    );
  }

  void _onTermChanged(RegisterTermChanged event, Emitter<RegisterState> emit) {
    final acceptTerm = Term.dirty(event.acceptTerm);
  
    emit(
      state.copyWith(
        acceptTerm: acceptTerm,
        isValid: Formz.validate([state.username, state.email, state.password, acceptTerm]),
      ),
    );
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        final Either response = await _authenticationRepository.signUp(
          username: state.username.value,
          email: state.email.value,
          password: state.password.value,
        );

        response.fold(
          (response) {
            emit(state.copyWith(status: FormzSubmissionStatus.success));
          },
          (error) {
            // Handle Register error
            emit(
              state.copyWith(
                status: FormzSubmissionStatus.failure,
                errorMessage: error is ErrorMessage
                    ? error
                    : ErrorMessage(message: 'Register failed'),
              ),
            );
          },
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: ErrorMessage(message: e.toString()),
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: ErrorMessage(message: 'Invalid credentials'),
        ),
      );
    }
  }
}
