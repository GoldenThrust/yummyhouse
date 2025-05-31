import 'package:core/core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import 'package:yummyhouse/authentication/authentication.dart';
import 'package:yummyhouse/authentication/error/email.dart';
import 'package:yummyhouse/authentication/error/password.dart';
import 'package:yummyhouse/authentication/error/username.dart';
import 'package:yummyhouse/register/bloc/register_bloc.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        ScaffoldMessenger.of(context).clearSnackBars();
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage?.message ?? 'Sign up failed'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.status.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.responseMessage?.message ?? 'Registration successful. Please verify your email.',
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
            "Create Your Account",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Please fill in the details below to create your account.",
            style: TextStyle(fontSize: 12, color: Colors.grey, height: 2),
          ),
          const SizedBox(height: 25),

          // Input fields
          _UsernameInput(),
          const SizedBox(height: 18),
          _EmailInput(),
          const SizedBox(height: 18),
          _PasswordInput(),
          const SizedBox(height: 25),

          // Sign up button
          _SubmitButton(),

          // Terms agreement
          Row(
            children: [
              _AcceptTerm(),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: "I agree to the ",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    children: [
                      TextSpan(
                        text: "Terms of Service",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                context.go('/policy/term');
                              },
                      ),
                      const TextSpan(text: " and "),
                      TextSpan(
                        text: "Privacy Policy",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                context.go('/policy/privacy');
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Sign In button
          Center(
            child: Text(
              "Already have an account?",
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
              context.go('/login');
            },
            child: const Text(
              'SIGN IN',
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

class _AcceptTerm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final acceptTerm = context.select<RegisterBloc, bool>(
      (bloc) => bloc.state.acceptTerm.value,
    );

    return Checkbox(
      value: acceptTerm,
      onChanged: (val) {
        if (val != null) {
          context.read<RegisterBloc>().add(RegisterTermChanged(val));
        }
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? errorText;
    final displayError = context.select<RegisterBloc, UsernameValidationError?>(
      (bloc) => bloc.state.username.displayError,
    );

    if (displayError != null) {
      errorText = usernameError(displayError);
    }

    return AppTextField(
      icon: Icons.person_outline,
      label: "Enter your full name",
      displayError: errorText,
      onChanged: (username) {
        context.read<RegisterBloc>().add(RegisterUsernameChanged(username));
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? errorText;
    final displayError = context.select<RegisterBloc, EmailValidationError?>(
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
        context.read<RegisterBloc>().add(RegisterEmailChanged(username));
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? errorText;
    final displayError = context.select<RegisterBloc, PasswordValidationError?>(
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
        context.read<RegisterBloc>().add(RegisterPasswordChanged(password));
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inProgress = context.select<RegisterBloc, bool>(
      (bloc) => bloc.state.status.isInProgress,
    );

    if (inProgress) {
      return const Center(child: CircularProgressIndicator());
    }

    final isValid = context.select<RegisterBloc, bool>(
      (bloc) => bloc.state.isValid,
    );

    return ElevatedButton(
      key: const Key('registerForm_submit_raisedButton'),
      onPressed:
          isValid
              ? () {
                context.read<RegisterBloc>().add(const RegisterSubmitted());
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
        "SIGN UP",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
