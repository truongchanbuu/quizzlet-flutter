import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/folder.dart';
import 'package:quizzlet_fluttter/features/topic/domain/repository/topic_repository.dart';

part 'folder_event.dart';
part 'folder_state.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  final TopicRepository _topicRepository;
  late final StreamSubscription<List<FolderModel>> _folderSubscription;

  FolderBloc(this._topicRepository) : super(FolderInitial()) {
    _folderSubscription = _topicRepository.folders().listen((folders) {
      add(GetFolders(folders));
    });

    on<GetFolders>((event, emit) {
      emit(FolderLoaded(event.folders));
    });

    on<CreateFolder>((event, emit) async {
      try {
        var dataState = await _topicRepository.createFolder(event.folder);

        if (dataState is CreateFolderFailed) {
          emit(CreateFolderFailed(
              dataState.error?.message ?? 'There is something wrong'));
        } else if (dataState is CreateFolderSuccess) {
          emit(const CreateFolderSuccess());
        } else {
          emit(Creating());
        }
      } catch (e) {
        emit(CreateFolderFailed(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _folderSubscription.cancel();
    return super.close();
  }
}
