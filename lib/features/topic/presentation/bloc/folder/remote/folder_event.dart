part of 'folder_bloc.dart';

sealed class FolderEvent extends Equatable {
  const FolderEvent();

  @override
  List<Object> get props => [];
}

final class GetFolders extends FolderEvent {
  final List<FolderModel> folders;

  const GetFolders(this.folders);
}

final class GetFoldersByEmail extends FolderEvent {
  final String email;

  const GetFoldersByEmail(this.email);
}

final class CreateFolder extends FolderEvent {
  final FolderModel folder;
  const CreateFolder(this.folder);
}

final class DeleteFolder extends FolderEvent {
  final String folderId;
  const DeleteFolder(this.folderId);
}

final class EditFolder extends FolderEvent {
  final FolderModel editedFolder;
  const EditFolder(this.editedFolder);
}

final class AddTopicsToFolder extends FolderEvent {
  final String folderId;
  final List<String> topicIds;

  const AddTopicsToFolder({required this.folderId, required this.topicIds});
}

final class RemoveTopicsFromFolder extends FolderEvent {
  final String folderId;
  final List<String> topicIds;

  const RemoveTopicsFromFolder(this.folderId, this.topicIds);
}

final class GetFoldersByName extends FolderEvent {
  final String name;

  const GetFoldersByName(this.name);
}
