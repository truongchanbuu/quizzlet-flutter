part of 'remote_signin_bloc.dart';

enum SignInStatus {
  loading,
  success,
  failed,
  wrongPassword,
  emailNotFound,
  disabled,
}

class SignInState {
  final SignInStatus status;
  final String? error;
  final String? token;

  SignInState(this.status, {this.token, this.error});

  factory SignInState.init() {
    return SignInState(SignInStatus.loading);
  }

  factory SignInState.loading() {
    return SignInState(SignInStatus.loading);
  }

  factory SignInState.success(String token) {
    return SignInState(SignInStatus.success, token: token);
  }

  factory SignInState.failed(String error) {
    return SignInState(SignInStatus.failed, error: error);
  }

  factory SignInState.wrongPassword() {
    return SignInState(SignInStatus.wrongPassword,
        error: 'Mật khẩu không chính xác');
  }

  factory SignInState.emailNotFound() {
    return SignInState(SignInStatus.emailNotFound,
        error: 'Email không tồn tại');
  }

  factory SignInState.disabled() {
    return SignInState(SignInStatus.disabled, error: 'Email đã bị vô hiệu hóa');
  }
}
