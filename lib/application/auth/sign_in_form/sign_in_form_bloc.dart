import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_firebase_ddd/domain/auth/auth_failure.dart';
import 'package:notes_firebase_ddd/domain/auth/i_auth_facade.dart';
import 'package:notes_firebase_ddd/domain/auth/value_objects.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<SignInWithEmailAndPasswordPressed>(
          (event, emit) => signInWithEmailAndPassword(event, emit),
    );
    on<RegisterWithEmailAndPasswordPressed>(
          (event, emit) => registerWithEmailAndPassword(event, emit),
    );
    on<SignInWithGooglePressed>(
          (event, emit) => signInWithGoogle(event, emit),
    );
    on<EmailChanged>(
          (event, emit) => changeEmailAddress(event, emit),
    );
    on<PasswordChanged>(
          (event, emit) => changePassword(event, emit),
    );
  }

  final IAuthFacade _authFacade;

  void changeEmailAddress(EmailChanged event, Emitter<SignInFormState> emit) {
    emit(
      state.copyWith(
        emailAddress: EmailAddress(event.email),
        authFailureOrSuccessOption: none(),
      ),
    );
  }

  void changePassword(PasswordChanged event, Emitter<SignInFormState> emit) {
    emit(
      state.copyWith(
        password: Password(event.password),
        authFailureOrSuccessOption: none(),
      ),
    );
  }

  Future<void> registerWithEmailAndPassword(
      RegisterWithEmailAndPasswordPressed event,
      Emitter<SignInFormState> emit,
      ) async {
    Either<AuthFailure, Unit>? failureOrSuccess;

    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(
        state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ),
      );

      failureOrSuccess = await _authFacade.registerWithEmailAndPassword(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }

    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: AutovalidateMode.onUserInteraction,
        authFailureOrSuccessOption: optionOf(failureOrSuccess),
      ),
    );
  }

  Future<void> signInWithEmailAndPassword(
      SignInWithEmailAndPasswordPressed event,
      Emitter<SignInFormState> emit,
      ) async {
    Either<AuthFailure, Unit>? failureOrSuccess;

    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(
        state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ),
      );

      failureOrSuccess = await _authFacade.signInWithEmailAndPassword(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }

    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: AutovalidateMode.onUserInteraction,
        authFailureOrSuccessOption: optionOf(failureOrSuccess),
      ),
    );
  }

  Future<void> signInWithGoogle(
      SignInWithGooglePressed event,
      Emitter<SignInFormState> emit,
      ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      ),
    );

    final failureOrSuccess = await _authFacade.signInWithGoogle();

    emit(
      state.copyWith(
        isSubmitting: false,
        authFailureOrSuccessOption: some(failureOrSuccess),
      ),
    );
  }
}