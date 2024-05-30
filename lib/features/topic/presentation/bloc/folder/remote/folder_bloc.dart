import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/folder.dart';
import 'package:quizzlet_fluttter/features/topic/domain/repository/topic_repository.dart';

part 'folder_event.dart';
part 'folder_state.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  final TopicRepository _topicRepository;
  // late final StreamSubscription<List<FolderModel>> _folderSubscription;

  FolderBloc(this._topicRepository) : super(FolderInitial()) {
    // _folderSubscription = _topicRepository.folders().listen((folders) {
    //   add(GetFolders(folders));
    // });

    on<GetFolders>((event, emit) {
      emit(FolderLoaded(event.folders));
    });

    on<GetFoldersByEmail>((event, emit) async {
      try {
        var dataState = await _topicRepository.getFoldersByEmail(event.email);

        if (dataState is DataFailed) {
          emit(FolderLoadFailed(
              dataState.error?.message ?? 'There is something wrong'));
        } else if (dataState is DataSuccess && dataState.data != null) {
          emit(FolderLoaded(dataState.data!));
        } else {
          emit(FolderLoading());
        }
      } catch (e) {
        emit(FolderLoadFailed(e.toString()));
      }
    });

    on<GetFoldersByName>((event, emit) async {
      try {
        var dataState = await _topicRepository.getFoldersByName(event.name);

        if (dataState is DataFailed) {
          emit(FolderLoadFailed(
              dataState.error?.message ?? 'There is something wrong'));
        } else if (dataState is DataSuccess) {
          emit(FolderLoaded(dataState.data!));
        } else {
          emit(FolderLoading());
        }
      } catch (e) {
        emit(FolderLoadFailed(e.toString()));
      }
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
          emit(CreatingFolder());
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
          emit(DeletingFolder());
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
          emit(UpdatingFolder());
        }
      } catch (e) {
        emit(UpdateFolderFailed(e.toString()));
      }
    });

    on<AddTopicsToFolder>((event, emit) async {
      try {
        var dataState = await _topicRepository.addTopicsToFolder(
            event.folderId, event.topicIds);

        if (dataState is DataFailed) {
          emit(AddTopicsFailed());
        } else if (dataState is DataSuccess) {
          emit(AddTopicsSuccess());
        } else {
          emit(AddingTopics());
        }
      } catch (e) {
        emit(AddTopicsFailed());
      }
    });

    on<RemoveTopicsFromFolder>((event, emit) async {
      try {
        var dataState = await _topicRepository.removeTopicsFromFolder(
            event.folderId, event.topicIds);

        if (dataState is DataFailed) {
          emit(RemoveTopicsFailed(
              dataState.error?.message ?? 'There is something wrong'));
        } else if (dataState is DataSuccess) {
          emit(RemoveTopicsSuccess());
        } else {
          emit(RemovingTopics());
        }
      } catch (e) {
        emit(RemoveTopicsFailed(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    // _folderSubscription.cancel();
    return super.close();
  }
}
