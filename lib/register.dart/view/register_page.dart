import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/register_bg.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                // Top branding
                const Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Yummy House",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(1, 1),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Restaurant of Bliss",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(1, 1),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Scrollable form
                Expanded(
                  flex: 15,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(245),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Create Your Account",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "Please fill in the details below to create your account.",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      height: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 25),

                                  // Input fields
                                  _buildTextField(
                                    icon: Icons.person_outline,
                                    label: "Enter your full name",
                                  ),
                                  const SizedBox(height: 18),
                                  _buildTextField(
                                    icon: Icons.email_outlined,
                                    label: "Enter your email address",
                                  ),
                                  const SizedBox(height: 18),
                                  _buildTextField(
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
                                      Checkbox(
                                        value: false,
                                        onChanged: (val) {},
                                      ),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            text: "I agree to the ",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
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
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String label,
    bool obscureText = false,
  }) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepOrange),
        labelText: label,
        filled: true,
        fillColor: Colors.blueGrey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
