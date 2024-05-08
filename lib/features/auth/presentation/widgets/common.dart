import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quizzlet_fluttter/core/util/shared_preference_util.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signin/remote/remote_signin_bloc.dart';
import 'package:sign_in_button/sign_in_button.dart';

buildPolicyAlertText() {
  return RichText(
    textAlign: TextAlign.center,
    text: const TextSpan(
      children: [
        TextSpan(
          text: 'Bằng việc đăng ký, tôi chấp thuận ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: 'Điều khoản dịch vụ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: ' và ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: 'Chính sách quyền riêng tư',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: ' của Quizzlet',
          style: TextStyle(
            color: Colors.black,
          ),
        )
      ],
    ),
  );
}

buildSignInMethodsWidget(UserRepository userRepository,
    {Future<void> Function(BuildContext context) navigateToSuccessPage =
        signInSuccess}) {
  return BlocProvider(
    create: (context) => SignInBloc(userRepository),
    child: BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        if (state.status == SignInStatus.success && state.token != null) {
          navigateToSuccessPage(context);
        }
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: SignInButton(
                Buttons.google,
                onPressed: () => _signInWithGoogle(context),
                elevation: 0,
                text: 'Google',
                padding: const EdgeInsets.all(20),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: SignInButton(
                Buttons.facebook,
                onPressed: () => _signInWithFacebook(context),
                elevation: 0,
                text: 'Facebook',
                padding: const EdgeInsets.all(20),
              ),
            ),
          ],
        );
      },
    ),
  );
}

_signInWithGoogle(BuildContext context) {
  context.read<SignInBloc>().add(const SignInWithGoogle());
}

_signInWithFacebook(BuildContext context) {
  context.read<SignInBloc>().add(const SignInWithFacebook());
}

// Success
Future<void> signInSuccess(BuildContext context) async {
  var token =
      await GetIt.instance.get<FirebaseAuth>().currentUser!.getIdToken();
  await saveToSharedPref('token', token);
  if (context.mounted) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
