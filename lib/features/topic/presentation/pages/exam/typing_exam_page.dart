import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';

class TypingExamPage extends StatefulWidget {
  final List<WordModel> words;
  final String mode;
  const TypingExamPage({super.key, required this.words, this.mode = 'en-vie'});

  @override
  State<TypingExamPage> createState() => _TypingExamPageState();
}

class _TypingExamPageState extends State<TypingExamPage> {
  int _currentWordIndex = 0;

  late String questionText;
  late String correctAnswer;

  late WordModel currentWord;

  @override
  void initState() {
    super.initState();
    currentWord = widget.words[_currentWordIndex];
    questionText =
        widget.mode == 'en-vie' ? currentWord.terminology : currentWord.meaning;
    correctAnswer = widget.mode == 'en-vie'
        ? currentWord.meaning.toLowerCase()
        : currentWord.terminology.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    var percentage = _currentWordIndex / widget.words.length;
    return AppBar(
      title: Text(
        '${_currentWordIndex + 1} / ${widget.words.length}',
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: LinearProgressIndicator(
          value: percentage.toDouble(),
          semanticsLabel: 'Your learning progress',
          semanticsValue: 'You learned ${percentage * 100}%',
        ),
      ),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(questionText),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                onSubmitted: (value) {
                  print(value);
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  hintText: 'Nhập đáp án vào đây',
                  suffix: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text(
                      'Không biết',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
