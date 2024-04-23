part of 'remote_reset_password_bloc.dart';

enum ResetPasswordStatus { success, failed, processing }

class ResetPasswordState extends Equatable {
  final ResetPasswordStatus status;

  const ResetPasswordState(this.status);
  
  factory ResetPasswordState.success() {
    return const ResetPasswordState(ResetPasswordStatus.success);
  }
  
  factory ResetPasswordState.failed() {
    return const ResetPasswordState(ResetPasswordStatus.failed);
  }

  factory ResetPasswordState.processing() {
    return const ResetPasswordState(ResetPasswordStatus.processing);
  }

  @override
  List<Object> get props => [];
}

