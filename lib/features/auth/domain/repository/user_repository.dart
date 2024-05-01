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
}
