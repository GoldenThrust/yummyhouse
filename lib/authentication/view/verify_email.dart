import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yummyhouse/authentication/bloc/authentication_bloc.dart';

class VerifyEmail extends StatelessWidget {
  final int _id;
  final String _hash;
  final String _expires;
  final String _signature;

  const VerifyEmail({super.key, id, hash, expires, signature})
    : _id = id,
      _hash = hash,
      _expires = expires,
      _signature = signature;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          context.read<EmailVericationBloc>().add(
            AuthenticationVerifyEmailRequested(
              id: _id,
              hash: _hash,
              expires: _expires,
              signature: _signature,
            ),
          );
          return BlocListener<EmailVericationBloc, EmailVerificationState>(
            listener: (context, state) {
              if (state == EmailVerificationState.verified) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email verified successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );

                context.read<AuthenticationBloc>().add(AuthenticationUser());
                context.go('/home');
              } else if (state == EmailVerificationState.notVerified) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Email verification failed.'),
                    backgroundColor: Colors.redAccent,
                  ),
                );

                context.go('/register');
              }
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Verifing email...'),
                  const SizedBox(height: 20),
                  CircularProgressIndicator(color: Colors.deepOrange),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
