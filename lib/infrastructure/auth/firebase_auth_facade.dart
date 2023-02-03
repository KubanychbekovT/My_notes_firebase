import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_firebase_ddd/domain/auth/auth_failure.dart';
import 'package:notes_firebase_ddd/domain/auth/i_auth_facade.dart';
import 'package:notes_firebase_ddd/domain/auth/value_objects.dart';

@LazySingleton(as: IAuthFacade)
class FireBaseAuthFacade implements IAuthFacade {
  FireBaseAuthFacade(this._firebaseAuth, this._googleSignIn);

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<Option<User>> getSignedUser() async =>
      optionOf(_firebaseAuth.currentUser?.toDomain());

  @override
  Future<void> signOut() => Future.wait([
    _googleSignIn.signOut(),
    _firebaseAuth.signOut(),
  ]);

  @override
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
}) async {
    final emailAddressString = emailAddress.getOrCash();
    final passwordString = emailAddress.getOrCash();

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: passwordString,
      );
      return right(unit);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use' ||
          e.code == "email-already-in-use".toUpperCase()) {
        return left(const AuthFailure.emailAlreadyInUse());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
}) async {
    final emailAddressString = emailAddress.getOrCash();
    final passwordString = emailAddress.getOrCash();

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: emailAddressString,
        password: passwordString,
      );
      return right(unit);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' ||
          e.code == 'wrong-password'.toUpperCase() ||
          e.code == 'user-not-found' ||
          e.code == 'user-not-found'.toUpperCase()) {
        return left(const AuthFailure.invalidEmailAndPasswordCombination());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return left(const AuthFailure.cancelledByUser());
      }
      final googleAuth = await googleUser.authentication;
      final authCredential = firebase_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      return _firebaseAuth
          .signInWithCredential(authCredential)
          .then((r) => right(unit));
    } on firebase_auth.FirebaseAuthException catch (_) {
      return left(const AuthFailure.serverError());
    }
  }
}