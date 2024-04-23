import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/auth/data/models/user.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<DataState<UserModel>> signIn(String email, String password);
  Future<DataState<void>> signInWithGoogle();
  Future<DataState<UserModel>> signUp(UserModel signUpData);
  Future<DataState<void>> logOut();
  Future<DataState<void>> resetPassword(String email);
  Future<DataState<void>> setUserData(UserModel user);
}
