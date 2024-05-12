// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FolderModel _$FolderModelFromJson(Map<String, dynamic> json) => FolderModel(
      folderId: json['folderId'] as String,
      folderName: json['folderName'] as String,
      topics: (json['topics'] as List<dynamic>)
          .map((e) => TopicModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      creator: json['creator'] as String?,
    );

Map<String, dynamic> _$FolderModelToJson(FolderModel instance) =>
    <String, dynamic>{
      'folderId': instance.folderId,
      'folderName': instance.folderName,
      'topics': instance.topics,
      'creator': instance.creator,
    };
