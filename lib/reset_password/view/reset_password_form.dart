import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import 'package:yummyhouse/authentication/authentication.dart';
import 'package:yummyhouse/authentication/error/email.dart';
import 'package:yummyhouse/authentication/error/password.dart';
import 'package:yummyhouse/reset_password/bloc/reset_password_bloc.dart';

class ResetPasswordForm extends StatelessWidget {
  final String _token;
  const ResetPasswordForm({super.key, token}) : _token = token;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        ScaffoldMessenger.of(context).clearSnackBars();
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage?.message ?? 'Password reset failed',
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.status.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.responseMessage?.message ?? 'Password reset successful',
              ),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/login');
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Reset Password",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Please fill in the details below to reset your account password",
            style: TextStyle(fontSize: 12, color: Colors.grey, height: 2),
          ),
          const SizedBox(height: 25),

          // Input fields
          _EmailInput(),
          const SizedBox(height: 18),
          _PasswordInput(),
          const SizedBox(height: 25),
          _PasswordComfirmationInput(),
          const SizedBox(height: 25),

          // Sign up button
          _SubmitButton(token: _token),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? errorText;
    final displayError = context
        .select<ResetPasswordBloc, EmailValidationError?>(
          (bloc) => bloc.state.email.displayError,
        );

    if (displayError != null) {
      errorText = emailError(displayError);
    }

    return AppTextField(
      icon: Icons.email_outlined,
      label: "Enter your email address",
      displayError: errorText,
      onChanged: (username) {
        context.read<ResetPasswordBloc>().add(
          ResetPasswordEmailChanged(username),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? errorText;
    final displayError = context
        .select<ResetPasswordBloc, PasswordValidationError?>(
          (bloc) => bloc.state.password.displayError,
        );

    if (displayError != null) {
      errorText = passwordError(displayError);
    }
    return AppTextField(
      icon: Icons.lock_outline_rounded,
      label: "Enter your password",
      obscureText: true,
      displayError: errorText,
      onChanged: (password) {
        context.read<ResetPasswordBloc>().add(
          ResetPasswordPasswordChanged(password),
        );
      },
    );
  }
}

class _PasswordComfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? errorText;
    final displayError = context
        .select<ResetPasswordBloc, PasswordValidationError?>(
          (bloc) => bloc.state.passwordConfirmation.displayError,
        );

    if (displayError != null) {
      errorText = passwordError(displayError);
    }
    return AppTextField(
      icon: Icons.lock_outline_rounded,
      label: "Confirm your password",
      obscureText: true,
      displayError: errorText,
      onChanged: (password) {
        context.read<ResetPasswordBloc>().add(
          ResetPasswordPasswordConfirmationChanged(password),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final String _token;
  const _SubmitButton({token}) : _token = token;

  @override
  Widget build(BuildContext context) {
    final inProgress = context.select<ResetPasswordBloc, bool>(
      (bloc) => bloc.state.status.isInProgress,
    );

    if (inProgress) {
      return const Center(child: CircularProgressIndicator());
    }

    final isValid = context.select<ResetPasswordBloc, bool>(
      (bloc) => bloc.state.isValid,
    );
    print("isValid: $isValid");

    return ElevatedButton(
      key: const Key('reset_passwordForm_submit_raisedButton'),
      onPressed:
          isValid && !inProgress
              ? () {
                context.read<ResetPasswordBloc>().add(
                  ResetPasswordSubmitted(_token),
                );
              }
              : null,
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(double.infinity, 60)),
        backgroundColor: WidgetStateProperty.resolveWith(
          submitButtonWidgetState,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      child: const Text(
        "SUBMIT",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
