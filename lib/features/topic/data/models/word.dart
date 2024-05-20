import 'package:json_annotation/json_annotation.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/learn_state.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/word.dart';

part 'word.g.dart';

@JsonSerializable(anyMap: true)
class WordModel extends WordEntity {
  WordModel({
    required super.wordId,
    required super.terminology,
    required super.meaning,
    super.wordDesc,
    super.phonetic,
    super.illustratorUrl,
    super.learnState,
    super.starred,
  });

  WordEntity toEntity() {
    return WordEntity(
      wordId: wordId,
      terminology: terminology,
      meaning: meaning,
      wordDesc: wordDesc,
      phonetic: phonetic,
      illustratorUrl: illustratorUrl,
      learnState: learnState,
      starred: starred,
    );
  }

  factory WordModel.fromEntity(WordEntity entity) {
    return WordModel(
      wordId: entity.wordId,
      terminology: entity.terminology,
      meaning: entity.meaning,
      wordDesc: entity.wordDesc,
      phonetic: entity.phonetic,
      illustratorUrl: entity.illustratorUrl,
      learnState: entity.learnState,
      starred: entity.starred,
    );
  }

  WordModel copyWith({
    String? wordId,
    String? terminology,
    String? meaning,
    String? wordDesc,
    String? phonetic,
    String? illustratorUrl,
    LearnState? learnState,
    bool? starred,
  }) {
    return WordModel(
      wordId: wordId ?? this.wordId,
      terminology: terminology ?? this.terminology,
      meaning: meaning ?? this.meaning,
      wordDesc: wordDesc ?? this.wordDesc,
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
