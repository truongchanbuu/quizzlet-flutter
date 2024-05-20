part of 'folder_bloc.dart';

sealed class FolderState extends Equatable {
  const FolderState();

  @override
  List<Object> get props => [];
}

final class FolderInitial extends FolderState {}

final class FolderLoading extends FolderState {}

final class FolderLoaded extends FolderState {
  final List<FolderModel> folders;
  const FolderLoaded(this.folders);
}

final class FolderLoadFailed extends FolderState {
  final String message;
  const FolderLoadFailed(this.message);
}

final class CreateFolderSuccess extends FolderState {
  const CreateFolderSuccess();
}

final class Creating extends FolderState {}

final class CreateFolderFailed extends FolderState {
  final String? message;
  const CreateFolderFailed(this.message);
}

final class DeleteFolderSuccess extends FolderState {
  const DeleteFolderSuccess();
}

final class Deleting extends FolderState {}

final class DeleteFolderFailed extends FolderState {
  final String? message;
  const DeleteFolderFailed(this.message);
}

final class UpdateFolderSuccess extends FolderState {
  const UpdateFolderSuccess();
}

final class Updating extends FolderState {}

final class UpdateFolderFailed extends FolderState {
  final String? message;
  const UpdateFolderFailed(this.message);
}
