import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/folder.dart';
import 'package:quizzlet_fluttter/features/topic/domain/repository/topic_repository.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/topic/remote/topic_bloc.dart';

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

    on<DeleteFolder>((event, emit) async {
      try {
        var dataState = await _topicRepository.deleteFolder(event.folderId);

        if (dataState is DataFailed) {
          emit(DeleteFolderFailed(
              dataState.error!.message ?? 'There is something wrong'));
        } else if (dataState is DataSuccess) {
          emit(const DeleteFolderSuccess());
        } else {
          emit(Deleting());
        }
      } catch (e) {
        emit(DeleteFolderFailed(e.toString()));
      }
    });

    on<EditFolder>((event, emit) async {
      try {
        var dataState = await _topicRepository.editFolder(event.editedFolder);

        if (dataState is DataFailed) {
          emit(UpdateFolderFailed(
              dataState.error!.message ?? 'There is something wrong'));
        } else if (dataState is DataSuccess) {
          emit(const UpdateFolderSuccess());
        } else {
          emit(Updating());
        }
      } catch (e) {
        emit(UpdateFolderFailed(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _folderSubscription.cancel();
    return super.close();
  }
}
