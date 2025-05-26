import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
                          padding: EdgeInsets.only(left: 20, right: 20),
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
}
