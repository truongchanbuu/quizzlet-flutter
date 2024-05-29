import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/auth/data/models/user.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final userCollection = sl.get<FirebaseFirestore>().collection('users');
  final storage = sl.get<FirebaseStorage>();

  UserRepositoryImpl(this.firebaseAuth, this.googleSignIn);

  @override
  Future<DataState<UserCredential>> signIn(
      String email, String password) async {
    try {
      final UserCredential credential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return DataSuccess(data: credential);
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      return DataFailed(
          error: DioException(
        requestOptions: RequestOptions(),
        error: e.code,
        message: e.message,
      ));
    }
  }

  @override
  Future<DataState<UserCredential>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

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

      var userCredential = await firebaseAuth.signInWithCredential(credential);

      setUserData(UserModel(
        email: userCredential.user!.email!,
        password:
            userCredential.user!.email!, // Generate random password (encrypted)
        avatarUrl: userCredential.user!.photoURL,
        username: userCredential.user!.displayName,
      ));

      return DataSuccess(data: userCredential);
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e.code,
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<DataState<UserCredential>> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: [
          'public_profile',
          'email',
          'pages_show_list',
          'pages_messaging',
          'pages_manage_metadata'
        ],
      );

      switch (loginResult.status) {
        case LoginStatus.success:
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(
                  loginResult.accessToken!.tokenString);
          var userCredential =
              await firebaseAuth.signInWithCredential(facebookAuthCredential);

          setUserData((UserModel(
            email: userCredential.user!.email!,
            password: userCredential
                .user!.email!, // Generate random password (encrypted)
            avatarUrl: userCredential.user!.photoURL,
            username: userCredential.user!.displayName,
          )));
          return DataSuccess(data: userCredential);
        case LoginStatus.cancelled:
          return DataFailed(
            error: DioException(
              requestOptions: RequestOptions(),
              message: loginResult.message,
              error: loginResult.message,
            ),
          );
        case LoginStatus.failed:
          return DataFailed(
            error: DioException(
              requestOptions: RequestOptions(),
              message: loginResult.message,
              error: loginResult.message,
            ),
          );
        case LoginStatus.operationInProgress:
          return const DataSuccess(data: null);
      }
    } catch (e) {
      log('There is something wrong: ${e.toString()}');
      return DataFailed(
          error: DioException(
        requestOptions: RequestOptions(),
        error: e,
      ));
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

      await firebaseAuth.currentUser!.updateDisplayName(signUpData.username);
      await firebaseAuth.currentUser!.updatePhotoURL(signUpData.avatarUrl);

      final user = signUpData.copyWith(
        id: credential.user!.uid,
      );

      return DataSuccess(data: user);
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      return DataFailed(
          error: DioException(
        requestOptions: RequestOptions(),
        error: e.code,
        message: e.message,
      ));
    }
  }

  @override
  Future<DataState<void>> logOut() async {
    try {
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
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
    } on FirebaseAuthException catch (e) {
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

  @override
  Future<DataState<UserCredential>> reAuthenticateGoogleUser() async {
    try {
      var reAuthCredential = await firebaseAuth.currentUser!
          .reauthenticateWithPopup(GoogleAuthProvider());

      return DataSuccess(data: reAuthCredential);
    } on FirebaseAuthException catch (e) {
      log("Error re-authenticating with Google: ${e.message}");
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e.code,
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<DataState<UserCredential>> reAuthenticatePasswordUser(
      String email, String password) async {
    try {
      var credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      var reAuthCredential = await firebaseAuth.currentUser!
          .reauthenticateWithCredential(credential);

      return DataSuccess(data: reAuthCredential);
    } on FirebaseAuthException catch (e) {
      log("Error re-authenticating with Google: ${e.message}");
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e.code,
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<DataState<UserCredential>> reAuthenticateFacebookUser() async {
    try {
      var reAuthCredential = await firebaseAuth.currentUser!
          .reauthenticateWithPopup(FacebookAuthProvider());

      return DataSuccess(data: reAuthCredential);
    } on FirebaseAuthException catch (e) {
      log("Error re-authenticating with Google: ${e.message}");
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e.code,
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<DataState<void>> updateUsername(String username) async {
    try {
      await firebaseAuth.currentUser!.updateDisplayName(username);
      return const DataSuccess();
    } on FirebaseAuthException catch (e) {
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> updateEmail(String email) async {
    try {
      await firebaseAuth.currentUser!.verifyBeforeUpdateEmail(email);

      return const DataSuccess();
    } on FirebaseAuthException catch (e) {
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DataState<void>> updatePassword(String password) async {
    try {
      await firebaseAuth.currentUser!.updatePassword(password);

      return const DataSuccess();
    } on FirebaseAuthException catch (e) {
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e.code,
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<DataState<void>> updateAvatar(String photoURL) async {
    try {
      await firebaseAuth.currentUser!.updatePhotoURL(photoURL);

      return const DataSuccess();
    } on FirebaseAuthException catch (e) {
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e.code,
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<DataState<String>> uploadAvatar(
      String emailAsID, String imagePath) async {
    Reference refRoot = storage.ref();
    Reference refAvatars = refRoot.child('/avatars');

    try {
      Reference refUploadFile = refAvatars.child(emailAsID);
      await refUploadFile.putFile(File(imagePath));

      String photoURL = await refUploadFile.getDownloadURL();

      return DataSuccess(data: photoURL);
    } on FirebaseException catch (e) {
      log('Upload Failed: ${e.toString()}');
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          message: e.message,
          error: e.code,
        ),
      );
    }
  }
}
