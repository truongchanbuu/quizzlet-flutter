import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/core/usecases/usecase.dart';
import 'package:quizzlet_fluttter/features/auth/domain/entities/user.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';

class LoginUseCase implements UseCase<DataState<UserEntity>, Map<String, dynamic>> {
  final UserRepository _userRepo;
  LoginUseCase(this._userRepo);
  
  @override
  Future<DataState<UserEntity>> call({Map<String, dynamic>? params}) {
    return _userRepo.signIn(params?['email'] ?? 'test@gmail.com', params?['password'] ?? '123456');
  }
}