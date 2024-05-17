import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';

class QuizExam extends StatefulWidget {
  final List<WordModel> words;
  final String mode;
  const QuizExam({super.key, required this.words, this.mode = 'en-vie'});

  @override
  State<QuizExam> createState() => _QuizExamState();
}

class _QuizExamState extends State<QuizExam> {
  int _currentWordIndex = 0;

  double percentage = 0;

  late String questionText;
  late List<String> options;

  late WordModel currentWord;

  getCorrectAnswer() {
    return widget.mode == 'en-vie'
        ? currentWord.meaning
        : currentWord.terminology;
  }

  List<String> getOptions() {
    var correctAnswer = getCorrectAnswer();
    var incorrectAnswers = widget.words
        .where((word) => word != currentWord)
        .map((word) =>
            widget.mode == 'en-vie' ? word.meaning : word.terminology);

    if (incorrectAnswers.length > 3) {
      incorrectAnswers.take(3);
    }

    var options = incorrectAnswers.toList()..add(correctAnswer);

    return options;
  }

  @override
  void initState() {
    super.initState();
    currentWord = widget.words[_currentWordIndex];
    percentage = _currentWordIndex / widget.words.length;
    questionText =
        widget.mode == 'en-vie' ? currentWord.terminology : currentWord.meaning;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Center(
            child: Text(
              questionText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: getOptions().length,
            itemBuilder: (context, index) => _createOptions(
              getOptions()[index],
            ),
          ),
        ),
      ],
    );
  }

  Widget _createOptions(String option) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo),
      ),
      child: ListTile(
        onTap: () {},
        title: Text(option),
      ),
    );
  }
}
