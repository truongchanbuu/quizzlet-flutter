import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/auth/data/models/user.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<DataState<UserCredential>> signIn(String email, String password);
  Future<DataState<UserCredential>> signInWithGoogle();
  Future<DataState<UserCredential>> signInWithFacebook();
  Future<DataState<UserModel>> signUp(UserModel signUpData);
  Future<DataState<void>> logOut();
  Future<DataState<void>> resetPassword(String email);
  Future<DataState<UserModel>> getUserData(String email);
  Future<DataState<void>> setUserData(UserModel user);
  Future<DataState<UserCredential>> reAuthenticateGoogleUser();
  Future<DataState<UserCredential>> reAuthenticateFacebookUser();
  Future<DataState<UserCredential>> reAuthenticatePasswordUser(
      String email, String password);
  Future<DataState<String>> uploadAvatar(String emailAsId, String imgPath);
  Future<DataState<void>> updateUsername(String username);
  Future<DataState<void>> updateEmail(String email);
  Future<DataState<void>> updatePassword(String password);
  Future<DataState<void>> updateAvatar(String photoURL);
}
