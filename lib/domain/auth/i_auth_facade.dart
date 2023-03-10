import 'package:dartz/dartz.dart';
import 'package:notes_firebase_ddd/domain/auth/auth_failure.dart';
import 'package:notes_firebase_ddd/domain/auth/value_objects.dart';
import 'package:fpdart/fpdart.dart';

abstract class IAuthFacade {
  Future<Option<User>> getSignedInUser();

  Future<void> signOut();

  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithGoogle();
}