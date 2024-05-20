// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FolderModel _$FolderModelFromJson(Map json) => FolderModel(
      folderId: json['folderId'] as String,
      folderName: json['folderName'] as String,
      folderDesc: json['folderDesc'] as String?,
      topics: (json['topics'] as List<dynamic>)
          .map((e) => TopicModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      creator: json['creator'] as String?,
    );

Map<String, dynamic> _$FolderModelToJson(FolderModel instance) =>
    <String, dynamic>{
      'folderId': instance.folderId,
      'folderName': instance.folderName,
      'folderDesc': instance.folderDesc,
      'topics': instance.topics.map((e) => e.toJson()).toList(),
      'creator': instance.creator,
    };
