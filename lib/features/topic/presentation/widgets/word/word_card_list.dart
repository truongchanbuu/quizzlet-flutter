import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class WordCardList extends StatefulWidget {
  final List<WordModel> words;
  const WordCardList({super.key, required this.words});

  @override
  State<WordCardList> createState() => _WordCardListState();
}

class _WordCardListState extends State<WordCardList> {
  final flutterTTS = sl.get<FlutterTts>();

  Map? _currentVoice;

  bool _isStarred = false;
  int? _termPronouncingIndex;
  int? _meanPronouncingIndex;

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
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: _buildWordCardItem,
      itemCount: widget.words.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }

  Widget _buildWordCardItem(BuildContext context, int index) {
    var word = widget.words[index];

    return Material(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                flutterTTS.speak(word.terminology);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    word.terminology,
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          _termPronouncingIndex == index ? Colors.yellow : null,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.volume_up),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isStarred = !_isStarred;
                          });
                        },
                        icon: _isStarred
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
              onTap: () {
                flutterTTS.speak(word.meaning);
              },
              child: Text(
                word.meaning,
                style: TextStyle(
                    fontSize: 15,
                    color:
                        _meanPronouncingIndex == index ? Colors.yellow : null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
