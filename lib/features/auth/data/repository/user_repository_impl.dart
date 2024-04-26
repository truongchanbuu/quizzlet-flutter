import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/auth/data/models/user.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth firebaseAuth;
  final userCollection = FirebaseFirestore.instance.collection('users');

  UserRepositoryImpl(this.firebaseAuth);

  @override
  Future<DataState<UserModel>> signIn(String email, String password) async {
    try {
      final UserCredential credential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return DataFailed(
          error: DioException(
            requestOptions: RequestOptions(),
            message: 'There is something wrong',
          ),
        );
      }

      final user = UserModel(
        email: email,
        password: password,
      );

      return DataSuccess(data: user);
    } catch (e) {
      log(e.toString());
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e,
        ),
      );
    }
  }

  @override
  Future<DataState<void>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return DataFailed(
          error: DioException(
            requestOptions: RequestOptions(),
            message: 'There is something wrong',
          ),
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await firebaseAuth.signInWithCredential(credential);
      return const DataSuccess();
    } catch (e) {
      log(e.toString());
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e,
        ),
      );
    }
  }

  @override
  Future<DataState<UserModel>> signUp(UserModel signUpData) async {
    try {
      final UserCredential credential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: signUpData.email,
        password: signUpData.password,
      );

      if (credential.user == null) {
        return DataFailed(
          error: DioException(
            requestOptions: RequestOptions(),
            message: 'There is something wrong',
          ),
        );
      }

      final user = signUpData.copyWith(
        id: credential.user!.uid,
      );

      return DataSuccess(data: user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }

      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e,
        ),
      );
    } catch (e) {
      log(e.toString());
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e,
        ),
      );
    }
  }

  @override
  Future<DataState<void>> logOut() async {
    try {
      await firebaseAuth.signOut();
      return const DataSuccess();
    } catch (e) {
      log(e.toString());
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e,
        ),
      );
    }
  }

  @override
  Future<DataState<void>> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return const DataSuccess();
    } catch (e) {
      log(e.toString());
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e,
        ),
      );
    }
  }

  @override
  Stream<User?> get user => firebaseAuth.authStateChanges();

  @override
  Future<DataState<void>> setUserData(UserModel user) async {
    try {
      await userCollection.doc(user.email).set(user.toJson());
      return const DataSuccess();
    } catch (e) {
      log(e.toString());
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e,
        ),
      );
    }
  }

  @override
  Future<DataState<UserModel>> getUserData(String email) async {
    try {
      var docSnapshot = await userCollection.doc(email).get();
      if (docSnapshot.exists) {
        UserModel user = UserModel.fromJson(docSnapshot.data()!);
        return DataSuccess(data: user);
      }
      
      return const DataSuccess(data: null);
    } catch (e) {
      log('There is something wrong: ${e.toString()}');
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e,
        ),
      );
    }
  }
}
