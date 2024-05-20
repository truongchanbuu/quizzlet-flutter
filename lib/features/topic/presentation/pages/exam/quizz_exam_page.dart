import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';

class QuizExamPage extends StatefulWidget {
  final List<WordModel> words;
  final String mode;
  const QuizExamPage({super.key, required this.words, this.mode = 'en-vie'});

  @override
  State<QuizExamPage> createState() => _QuizExamPageState();
}

class _QuizExamPageState extends State<QuizExamPage> {
  int _currentWordIndex = 0;

  List<WordModel> wrongAnswers = [];
  List<WordModel> correctAnswers = [];

  bool _isFinished = false;

  getCorrectAnswer() {
    return widget.mode == 'en-vie'
        ? widget.words[_currentWordIndex].meaning
        : widget.words[_currentWordIndex].terminology;
  }

  List<String> getOptions() {
    var correctAnswer = getCorrectAnswer();
    var incorrectAnswers = widget.words
        .where((word) => word != widget.words[_currentWordIndex])
        .map((word) =>
            widget.mode == 'en-vie' ? word.meaning : word.terminology);

    if (incorrectAnswers.length > 3) {
      incorrectAnswers.take(3);
    }

    return incorrectAnswers.toList()
      ..add(correctAnswer)
      ..shuffle();
  }

  @override
  void initState() {
    super.initState();
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
    var options = getOptions();
    var questionText = widget.mode == 'en-vie'
        ? widget.words[_currentWordIndex].terminology
        : widget.words[_currentWordIndex].meaning;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  questionText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: options.length,
            itemBuilder: (context, index) => _createOptions(
              options[index],
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
        onTap: () => _checkAnswer(option),
        title: Text(option),
      ),
    );
  }

  _checkAnswer(String answer) {
    var currentWord = widget.words[_currentWordIndex];
    bool isCorrect = answer == getCorrectAnswer();

    if (isCorrect) {
      correctAnswers.add(currentWord);
    } else {
      wrongAnswers.add(currentWord);
    }

    _nextQuiz();
  }

  _nextQuiz() {
    Future.delayed(
      const Duration(seconds: 1),
      () => setState(() {
        if (_currentWordIndex < widget.words.length - 1) {
          _currentWordIndex++;
        } else {
          _isFinished = true;
        }
      }),
    );
  }
}
