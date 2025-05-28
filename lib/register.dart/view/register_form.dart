import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        AppTextField(icon: Icons.person_outline, label: "Enter your full name"),
        const SizedBox(height: 18),
        AppTextField(
          icon: Icons.email_outlined,
          label: "Enter your email address",
        ),
        const SizedBox(height: 18),
        AppTextField(
          icon: Icons.lock_outline_rounded,
          label: "Enter your password",
          obscureText: true,
        ),
        const SizedBox(height: 25),

        // Sign up button
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 60),
            backgroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
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
        ),

        // Terms agreement
        Row(
          children: [
            Checkbox(value: false, onChanged: (val) {}),
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
                              // Handle Terms tap
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
                              // Handle Privacy tap
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
    );
  }
}
