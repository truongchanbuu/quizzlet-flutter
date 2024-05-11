import 'package:dio/dio.dart';
import 'package:quizzlet_fluttter/core/constants/constants.dart';
import 'package:retrofit/http.dart';
part 'topic_api_service.g.dart';

@RestApi(baseUrl: topicUrl)
abstract class TopicApiService {
  factory TopicApiService(Dio dio, {String? baseUrl}) = _TopicApiService;
}