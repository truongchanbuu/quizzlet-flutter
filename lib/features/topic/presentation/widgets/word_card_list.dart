import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/core/util/text_to_speech_util.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';

class WordCardList extends StatefulWidget {
  final List<WordModel> words;
  const WordCardList({super.key, required this.words});

  @override
  State<WordCardList> createState() => _WordCardListState();
}

class _WordCardListState extends State<WordCardList> {
  bool _isStarred = false;
  int? _termPronouncingIndex;
  int? _meanPronouncingIndex;

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
    return Material(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                setState(() {
                  _termPronouncingIndex = index;
                });
                await pronounce(widget.words[index].terminology);
                setState(() {
                  _termPronouncingIndex = null;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.words[index].terminology,
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
              onTap: () async {
                setState(() {
                  _meanPronouncingIndex = index;
                });
                await pronounce(widget.words[index].meaning);
              },
              child: Text(
                widget.words[index].meaning,
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
