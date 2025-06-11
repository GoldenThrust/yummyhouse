import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import 'package:yummyhouse/authentication/error/email.dart';
import 'package:yummyhouse/authentication/models/models.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  Email formData = Email.pure();
  FormzSubmissionStatus status = FormzSubmissionStatus.initial;
  bool isValid = false;
  String? errorText;
  String responseMessage = '';

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (status.isSuccess) {
        yummyHouseDialog(
          context: context,
          text: responseMessage,
          onPressed: () {
            context.pop();
            context.go('/login');
          },
        );
      } else if (status.isFailure) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorText ?? 'Forgot Password failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Forgot Password?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text(
          "Enter your email address to reset your password",
          style: TextStyle(fontSize: 12, color: Colors.grey, height: 2),
        ),
        const SizedBox(height: 30),

        AppTextField(
          icon: Icons.email_outlined,
          label: "Enter your email address",
          displayError: errorText,
          onChanged: (username) {
            setState(() {
              formData = Email.dirty(username);
              isValid = Formz.validate([formData]);
              errorText =
                  formData.displayError != null
                      ? emailError(
                        formData.displayError as EmailValidationError,
                      )
                      : null;
            });
          },
        ),
        const SizedBox(height: 25),
  
        DefaultButton(onPressed: isValid && status.isInitial ? _forgotPasswordRequest : null, text: 'Submit')
      ],
    );
  }

  _forgotPasswordRequest() async {
    setState(() {
      status = FormzSubmissionStatus.inProgress;
      responseMessage = '';
      errorText = null;
    });

    try {
      final response = await postRequest<Message>('/forgot-password', {
        'email': formData.value,
      }, Message.fromJson);
      setState(() {
        responseMessage = response.first.message;
        status = FormzSubmissionStatus.success;
      });
    } catch (e, stackTrace) {
      setState(() {
        status = FormzSubmissionStatus.failure;
        errorText = e is Message ? e.message : 'Forgot Password failed';
      });
      print('Error: $e Stack Trace: $stackTrace');
    }
  }
}
