import 'package:json_annotation/json_annotation.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/folder.dart';

part 'folder.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class FolderModel extends FolderEntity {
  const FolderModel({
    required super.folderId,
    required super.folderName,
    super.folderDesc,
    required super.topics,
    required super.creator,
  });

  FolderEntity toEntity() {
    return FolderEntity(
      folderId: folderId,
      folderName: folderName,
      folderDesc: folderDesc,
      topics: topics,
      creator: creator,
    );
  }

  factory FolderModel.fromEntity(FolderEntity entity) {
    return FolderModel(
      folderId: entity.folderId,
      folderName: entity.folderName,
      folderDesc: entity.folderDesc,
      topics: entity.topics,
      creator: entity.creator,
    );
  }

  FolderModel copyWith({
    String? folderId,
    String? folderName,
    String? folderDesc,
    List<TopicModel>? topics,
    String? creator,
  }) {
    return FolderModel(
      folderId: folderId ?? this.folderId,
      folderName: folderName ?? this.folderName,
      folderDesc: folderDesc ?? this.folderDesc,
      topics: topics ?? this.topics,
      creator: creator ?? this.creator,
    );
  }

  factory FolderModel.fromJson(Map<String, dynamic> json) =>
      _$FolderModelFromJson(json);

  Map<String, dynamic> toJson() => _$FolderModelToJson(this);
}
