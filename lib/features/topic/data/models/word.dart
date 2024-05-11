import 'package:json_annotation/json_annotation.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/learn_state.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/word.dart';

part 'word.g.dart';

@JsonSerializable()
class WordModel extends WordEntity {
  const WordModel({
    required super.wordId,
    required super.english,
    required super.vietnamese,
    super.phonetic,
    super.illustratorUrl,
    super.learnState,
    super.starred,
  });

  WordEntity toEntity() {
    return WordEntity(
      wordId: wordId,
      english: english,
      vietnamese: vietnamese,
      phonetic: phonetic,
      illustratorUrl: illustratorUrl,
      learnState: learnState,
      starred: starred,
    );
  }

  factory WordModel.fromEntity(WordEntity entity) {
    return WordModel(
      wordId: entity.wordId,
      english: entity.english,
      vietnamese: entity.vietnamese,
      phonetic: entity.phonetic,
      illustratorUrl: entity.illustratorUrl,
      learnState: entity.learnState,
      starred: entity.starred,
    );
  }

  WordModel copyWith({
    String? wordId,
    String? english,
    String? vietnamese,
    String? phonetic,
    String? illustratorUrl,
    LearnState? learnState,
    bool? starred,
  }) {
    return WordModel(
      wordId: wordId ?? this.wordId,
      english: english ?? this.english,
      vietnamese: vietnamese ?? this.vietnamese,
      phonetic: phonetic ?? this.phonetic,
      illustratorUrl: illustratorUrl ?? this.illustratorUrl,
      learnState: learnState ?? this.learnState,
      starred: starred ?? this.starred,
    );
  }

  factory WordModel.fromJson(Map<String, dynamic> json) =>
      _$WordModelFromJson(json);

  Map<String, dynamic> toJson() => _$WordModelToJson(this);
}
