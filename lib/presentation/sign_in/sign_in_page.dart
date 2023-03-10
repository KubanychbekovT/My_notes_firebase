import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_firebase_ddd/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:notes_firebase_ddd/injection.dart';

class SignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: BlocProvider<SignInFormBloc>(
        create: (context) =>
        getIt<SignInFormBloc>(),
        child: SignInForm(),
      ),
    );
  }
}
