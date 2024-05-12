import 'package:json_annotation/json_annotation.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/folder.dart';

part 'folder.g.dart';

@JsonSerializable()
class FolderModel extends FolderEntity {
  const FolderModel({
    required super.folderId,
    required super.folderName,
    required super.topics,
    required super.creator,
  });

  FolderEntity toEntity() {
    return FolderEntity(
      folderId: folderId,
      folderName: folderName,
      topics: topics,
      creator: creator,
    );
  }

  factory FolderModel.fromEntity(FolderEntity entity) {
    return FolderModel(
      folderId: entity.folderId,
      folderName: entity.folderName,
      topics: entity.topics,
      creator: entity.creator,
    );
  }

  FolderModel copyWith({
    String? folderId,
    String? folderName,
    List<TopicModel>? topics,
    String? creator,
  }) {
    return FolderModel(
      folderId: folderId ?? this.folderId,
      folderName: folderName ?? this.folderName,
      topics: topics ?? this.topics,
      creator: creator ?? this.creator,
    );
  }

  factory FolderModel.fromJson(Map<String, dynamic> json) =>
      _$FolderModelFromJson(json);

  Map<String, dynamic> toJson() => _$FolderModelToJson(this);
}
