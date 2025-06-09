import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yummyhouse/reset_password/bloc/reset_password_bloc.dart';
import 'package:yummyhouse/reset_password/view/reset_password_form.dart';

class ResetPasswordPage extends StatelessWidget {
  final String _token;
  const ResetPasswordPage({super.key, token}): _token = token;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                // iconSize: 20,
                onPressed: () {
                  context.go('/login');
                },
              ),
              const SizedBox(width: 8),
              const Text(
                'Login',
                style: TextStyle(fontSize: 16,
                 ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Top branding
              Padding(
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
                          child: IntrinsicHeight(child: ResetPasswordForm(token: _token,)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
