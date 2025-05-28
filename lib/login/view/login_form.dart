import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Welcome Back!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Get ready to enjoy your favorite meals",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            height: 2,
          ),
        ),
        const SizedBox(height: 30),
    
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
            minimumSize: const Size(
              double.infinity,
              60,
            ),
            backgroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "SIGN IN",
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
            Checkbox(
              value: false,
              onChanged: (val) {},
            ),
            const Text(
              'Keep me signed in',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              'Forgot Password?',
              style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Colors.deepOrangeAccent,
                decorationThickness: 2,
                color: Colors.deepOrangeAccent,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
              // recognizer: TapGestureRecognizer()
              //   ..onTap = () {
              //     context.go('/forgot-password');
              //   }
            ),
          ],
        ),
        const SizedBox(height: 25),
    
        // Sign In button
        Center(
          child: Text(
            "Don't have an account?",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          style: TextButton.styleFrom(
            minimumSize: const Size(
              double.infinity,
              60,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Colors.deepOrangeAccent,
              ),
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
    );
  }
}
