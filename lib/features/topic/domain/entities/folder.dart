import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';

class FolderEntity extends Equatable {
  final String folderId;
  final String folderName;
  final List<TopicModel> topics;
  final String? creator;

  const FolderEntity({
    required this.folderId,
    required this.folderName,
    required this.topics,
    required this.creator,
  });

  @override
  List<Object?> get props => [folderId, folderName, topics, creator];
}
