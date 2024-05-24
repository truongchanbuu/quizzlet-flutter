import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/word/remote/word_bloc.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class WordCardList extends StatefulWidget {
  final TopicModel topic;
  const WordCardList({super.key, required this.topic});

  @override
  State<WordCardList> createState() => _WordCardListState();
}

class _WordCardListState extends State<WordCardList> {
  final flutterTTS = sl.get<FlutterTts>();
  Map? _currentVoice;
  int? _speakingIndex;

  final currentUser = sl.get<FirebaseAuth>().currentUser!;

  List<WordModel>? _starredWords;

  void initTTS() {
    flutterTTS.getVoices.then((data) {
      try {
        List<Map> voices = List.from(data);
        voices = voices.where((voice) => voice['name'].contains('en')).toList();
        setState(() {
          _currentVoice = voices.first;
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initTTS();
    context
        .read<WordBloc>()
        .add(GetStarredWords(currentUser.email!, widget.topic.topicId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WordBloc, WordState>(
      builder: (context, state) {
        if (state is GettingStarredWords) {
          return const LoadingIndicator();
        } else if (state is GetStarredWordsSuccess) {
          _starredWords = state.starredWords;
        } else {
          _starredWords = [];
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: _buildWordCardItem,
          itemCount: widget.topic.words.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
        );
      },
      listener: (context, state) {
        if (state is WordStarred || state is UnStarred) {
          context
              .read<WordBloc>()
              .add(GetStarredWords(currentUser.email!, widget.topic.topicId));
        }
      },
    );
  }

  Widget _buildWordCardItem(BuildContext context, int index) {
    var word = widget.topic.words[index];
    bool isSpeaking = _speakingIndex == index;

    return GestureDetector(
      onTap: () => _speakText(word.terminology, index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSpeaking ? Colors.orange : Colors.transparent,
          ),
        ),
        child: Material(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _speakText(word.terminology, index),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        word.terminology,
                        style: const TextStyle(fontSize: 15),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () =>
                                _speakText(word.terminology, index),
                            icon: const Icon(Icons.volume_up),
                            tooltip: 'Phát âm',
                          ),
                          IconButton(
                            onPressed: () {
                              if (_starredWords?.contains(word) ?? false) {
                                context.read<WordBloc>().add(UnStarWord(
                                    email: currentUser.email!,
                                    topicId: widget.topic.topicId,
                                    word: word));
                              } else {
                                context.read<WordBloc>().add(StarWord(
                                    email: currentUser.email!,
                                    topicId: widget.topic.topicId,
                                    word: word));
                              }
                            },
                            icon: _starredWords?.contains(word) ?? false
                                ? const Icon(Icons.star)
                                : const Icon(Icons.star_border),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _speakText(word.meaning, index),
                  child: Text(word.meaning),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _speakText(String text, int index) {
    setState(() {
      _speakingIndex = index;
    });
    flutterTTS.speak(text).then((value) {
      Future.delayed(
        const Duration(seconds: 1),
        () => setState(() => _speakingIndex = null),
      );
    });
  }
}
