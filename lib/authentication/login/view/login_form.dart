import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import 'package:yummyhouse/authentication/authentication.dart';
import 'package:yummyhouse/authentication/error/email.dart';
import 'package:yummyhouse/authentication/error/password.dart';
import 'package:yummyhouse/authentication/login/bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage?.message ?? 'Login failed'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.status.isSuccess) {
          context.go('/home');
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Welcome Back!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Get ready to enjoy your favorite meals",
            style: TextStyle(fontSize: 12, color: Colors.grey, height: 2),
          ),
          const SizedBox(height: 30),

          _EmailInput(),
          const SizedBox(height: 18),
          _PasswordInput(),
          const SizedBox(height: 25),
          _SubmitButton(),
          const SizedBox(height: 15),
          Row(
            children: [
              const Spacer(),
              Text.rich(
                TextSpan(text: 'Forgot Password?', style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.deepOrangeAccent,
                  decorationThickness: 2,
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                ..onTap = () {
                  context.go('/forgot-password');
                }
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Sign In button
          Center(
            child: Text(
              "Don't have an account?",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.deepOrangeAccent),
              ),
            ),
            onPressed: () {
              context.go('/register');
            },
            child: const Text(
              'CREATE AN ACCOUNT',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? errorText;
    final displayError = context.select<LoginBloc, EmailValidationError?>(
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
        context.read<LoginBloc>().add(LoginEmailChanged(username));
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? errorText;
    final displayError = context.select<LoginBloc, PasswordValidationError?>(
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
        context.read<LoginBloc>().add(LoginPasswordChanged(password));
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inProgress = context.select<LoginBloc, bool>(
      (bloc) => bloc.state.status.isInProgress,
    );

    if (inProgress) {
      return const Center(child: CircularProgressIndicator());
    }

    final isValid = context.select<LoginBloc, bool>(
      (bloc) => bloc.state.isValid,
    );

    return DefaultButton(onPressed:  isValid
              ? () {
                context.read<LoginBloc>().add(const LoginSubmitted());
              }
              : null, text: "SIGN IN");
  }
}
