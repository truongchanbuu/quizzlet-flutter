// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordModel _$WordModelFromJson(Map<String, dynamic> json) => WordModel(
      wordId: json['wordId'] as String,
      english: json['english'] as String,
      vietnamese: json['vietnamese'] as String,
      phonetic: json['phonetic'] as String?,
      illustratorUrl: json['illustratorUrl'] as String?,
      learnState:
          $enumDecodeNullable(_$LearnStateEnumMap, json['learnState']) ??
              LearnState.notLearn,
      starred: json['starred'] as bool? ?? false,
    );

Map<String, dynamic> _$WordModelToJson(WordModel instance) => <String, dynamic>{
      'wordId': instance.wordId,
      'english': instance.english,
      'vietnamese': instance.vietnamese,
      'phonetic': instance.phonetic,
      'illustratorUrl': instance.illustratorUrl,
      'learnState': _$LearnStateEnumMap[instance.learnState]!,
      'starred': instance.starred,
    };

const _$LearnStateEnumMap = {
  LearnState.notLearn: 'notLearn',
  LearnState.learned: 'learned',
  LearnState.learning: 'learning',
  LearnState.mastered: 'mastered',
};
