part of 'remote_reset_password_bloc.dart';

enum ResetPasswordStatus { success, failed, processing }

class ResetPasswordState extends Equatable {
  final ResetPasswordStatus status;
  final String? error;

  const ResetPasswordState(this.status, {this.error});

  factory ResetPasswordState.success() {
    return const ResetPasswordState(ResetPasswordStatus.success);
  }

  factory ResetPasswordState.failed(String error) {
    return ResetPasswordState(ResetPasswordStatus.failed, error: error);
  }

  factory ResetPasswordState.processing() {
    return const ResetPasswordState(ResetPasswordStatus.processing);
  }

  @override
  List<Object> get props => [];
}
