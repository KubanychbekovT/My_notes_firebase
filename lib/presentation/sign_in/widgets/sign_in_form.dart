import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_firebase_ddd/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:another_flushbar/flushbar_helper.dart';

class SignInForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc,
    SignInFormState>(
        listener: (context, state) {
          state.authFailureOrSuccessOption.fold(
              () {},
                (either) => either.fold(
              (failure) {
                FlushbarHelper.createError(
                  message: failure.map(
                    cancelledByUser: (_) => 'Cancelled',
                    serverError: (_) => 'Server error',
                    emailAlreadyInUse: (_) => 'Email already in use',
                    invalidEmailAndPasswordCombination: (_) => 'Invalid email and password combination',
                  ),
                ).show(context);
          },
                    (_) {
                    },
          ),
          );
  },
    builder: (context, state) {
      return Form(
      autovalidateMode: state.showErrorMesages,
      child: ListView(
          padding: EdgeInsets.all(8),
          children: [
              Text('📝',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 50),
    ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'Email',
              ),
              autocorrect: false,
              onChanged: (value) =>
              context.read<SignInFormBloc>().add(
                SignInFormEvent.emailChanged(emailStr: value),
              ),
              validator: (_) => context
              .read<SignInFormBloc>()
                  .state
                  .emailAddress
                  .value
                  .fold(
                  (f) => f.maybeMap(
                    invalidEmail: (_) =>
                        'Invalid Email',
                    orElse: () => null,
                  ),
                  (_) => null,
              ),
    ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password',
              ),
              autocorrect: false,
              obscureText: true,
              onChanged: (value) =>
              context.read<SignInFormBloc>().add(
                SignInFormEvent.passwordChanged(passwordStr: value),
              ),
              validator: (_) =>
              context.read<SignInFormBloc>
                ().state.password.value.fold(
                  (f) => f.maybeMap(
                    shortPassword: (_) => 'Short Password',
                    orElse: () =>
                        null,
                  ),
                  (_) => null,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                    child: TextButton(
                      onPressed: () {
                        context.read<SignInFormBloc>().add(
                          SignInFormEvent
                                .signInWithEmailAndPasswordPressed(),
                        );
                      },
                      child: Text('SIGN IN'),
                    ),
                ),
                Expanded(
                    child: TextButton(
                      onPressed: () {
                        context.read<SignInFormBloc>().add(
                          SignInFormEvent
                                .registerWithEmailAndPasswordPressed(),
                        );
                      },
                      child: Text('REGISTER'),
                    ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  context.read<SignInFormBloc>().add(
                    SignInFormEvent.signInWithGooglePressed(),
                  );
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.lightBlue),
                ),
                child: Text(
                  'SIGN IN WITH GOOGLE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                      FontWeight.bold,
                  ),
                ),
            ),
            if (state.isSubmitting) ...[
              SizedBox(height: 8),
              LinearProgressIndicator(),
            ]
    ],
      ),
    );
    },
      );
    }
}
