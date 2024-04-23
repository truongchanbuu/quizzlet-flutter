import 'package:dio/dio.dart';
import 'package:quizzlet_fluttter/core/constants/constants.dart';
import 'package:retrofit/http.dart';
part 'user_api_service.g.dart';

@RestApi(baseUrl: accountUrl)
abstract class UserApiService {
  factory UserApiService(Dio dio, {String? baseUrl}) = _UserApiService;
}