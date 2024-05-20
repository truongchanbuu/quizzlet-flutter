import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';

class FolderEntity extends Equatable {
  final String folderId;
  final String folderName;
  final String? folderDesc;
  final List<TopicModel> topics;
  final String? creator;

  const FolderEntity({
    required this.folderId,
    required this.folderName,
    this.folderDesc,
    required this.topics,
    required this.creator,
  });

  @override
  List<Object?> get props =>
      [folderId, folderName, folderDesc, topics, creator];
}
