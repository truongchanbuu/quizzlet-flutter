import 'package:equatable/equatable.dart';

class LoginInfoEntity extends Equatable {
  final String email;
  final DateTime loggedInTime;
  final DateTime? endLoggedInDate;

  const LoginInfoEntity({
    required this.email,
    required this.endLoggedInDate,
    required this.loggedInTime,
  });

  @override
  List<Object?> get props => [
        email,
        endLoggedInDate,
        loggedInTime,
      ];
}
