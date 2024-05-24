import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/result/data/models/result.dart';
import 'package:quizzlet_fluttter/features/result/domain/repositories/result_repository.dart';

part 'result_event.dart';
part 'result_state.dart';

class ResultBloc extends Bloc<ResultEvent, ResultState> {
  final ResultRepository _resultRepository;

  ResultBloc(this._resultRepository) : super(ResultInitial()) {
    on<StoreResult>((event, emit) async {
      try {
        var dataState = await _resultRepository.storeResult(
            event.email, event.topicId, event.examType, event.result);

        if (dataState is DataFailed) {
          emit(ResultStoreFailed());
        } else if (dataState is DataSuccess) {
          emit(ResultStored());
        } else {
          emit(ResultStoring());
        }
      } catch (e) {
        emit(ResultStoreFailed());
      }
    });
  }
}
