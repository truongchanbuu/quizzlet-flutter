import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:quizzlet_fluttter/features/result/data/models/result.dart';
import 'package:quizzlet_fluttter/features/result/presentation/bloc/result/result_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/user_answer.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/result/presentation/pages/result_page.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class QuizExamPage extends StatefulWidget {
  final String topicId;
  final List<WordModel> words;
  final String mode;

  const QuizExamPage({
    super.key,
    required this.topicId,
    required this.words,
    this.mode = 'en-vie',
  });

  @override
  State<QuizExamPage> createState() => _QuizExamPageState();
}

class _QuizExamPageState extends State<QuizExamPage> {
  final flutterTTS = sl.get<FlutterTts>();
  int _currentWordIndex = 0;

  String? selectedAnswer;
  late List<UserAnswerModel> userAnswers;

  DateTime startTime = DateTime.now();
  late Duration completedTime;
  bool _isFinished = false;

  void initTTS() {
    flutterTTS.getVoices.then((data) {
      try {
        List<Map> voices = List.from(data);
        voices = voices.where((voice) => voice['name'].contains('en')).toList();
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initTTS();
    userAnswers = List.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.words;

    return Scaffold(
      appBar: _buildAppBar(words),
      body: _buildBody(words),
    );
  }

  _buildAppBar(List<WordModel> words) {
    double percentage = 0;
    if (words.isNotEmpty) {
      percentage = (_currentWordIndex + 1) / words.length;
    }

    return AppBar(
      title: Text(
        words.isEmpty
            ? '0 / 0'
            : '${_currentWordIndex + 1} / ${widget.words.length}',
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
      leading: IconButton(
        onPressed: () => Navigator.popUntil(
            context, ModalRoute.withName('/topic/detail/${widget.topicId}')),
        icon: const Icon(Icons.close),
      ),
    );
  }

  List<String>? currentOptions;
  _buildBody(List<WordModel> words) {
    if (words.isEmpty) {
      return const Center(
        child: Text(
          'Bạn hiện đang không đánh sao bất kỳ từ vựng nào. Hãy đánh sao từ vựng cần thiết để học nhé',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      );
    }

    List<String> options;
    if (selectedAnswer != null && currentOptions != null) {
      options = currentOptions!;
    } else {
      options = getOptions();
      currentOptions = options;
    }

    var questionText = widget.mode == 'en-vie'
        ? words[_currentWordIndex].terminology
        : words[_currentWordIndex].meaning;

    if (widget.mode == 'en-vie' && selectedAnswer == null && !_isFinished) {
      flutterTTS.speak(questionText);
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      questionText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    if (words[_currentWordIndex].illustratorUrl != null) ...[
                      const SizedBox(height: 5),
                      Image.network(
                        words[_currentWordIndex].illustratorUrl!,
                        width: 100,
                        height: 100,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.error,
                          semanticLabel: 'Cannot get the image',
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: options.length,
                itemBuilder: (context, index) =>
                    _createOptions(words, options[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createOptions(List<WordModel> words, String option) {
    final isCorrectAnswer =
        option == getCorrectAnswer(words[_currentWordIndex]);

    final isSelected = selectedAnswer == option;

    Color tileColor = Colors.white;
    Color textColor = Colors.black;

    if (selectedAnswer != null) {
      if (isSelected) {
        tileColor = isCorrectAnswer ? Colors.green : Colors.red;
        textColor = Colors.white;
      } else if (isCorrectAnswer) {
        tileColor = Colors.green;
        textColor = Colors.white;
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo, width: 2),
        color: tileColor,
      ),
      child: ListTile(
        onTap: selectedAnswer == null && !_isFinished
            ? () {
                if (widget.mode == 'vie-en') {
                  flutterTTS.speak(option);
                }

                _checkAnswer(option);
              }
            : null,
        title: Text(
          option,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  // Handle data
  getCorrectAnswer(WordModel word) {
    return widget.mode == 'en-vie' ? word.meaning : word.terminology;
  }

  List<String> getOptions() {
    var words = widget.words;
    var correctAnswer = getCorrectAnswer(words[_currentWordIndex]);
    var incorrectAnswers = words
        .where((word) => word != words[_currentWordIndex])
        .map(
            (word) => widget.mode == 'en-vie' ? word.meaning : word.terminology)
        .toList()
      ..shuffle();

    if (incorrectAnswers.length > 3) {
      incorrectAnswers = incorrectAnswers.take(3).toList();
    }

    return incorrectAnswers.toList()
      ..add(correctAnswer)
      ..shuffle();
  }

  _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      userAnswers.add(UserAnswerModel(
        topicId: widget.topicId,
        wordId: widget.words[_currentWordIndex].wordId,
        userAnswer: selectedAnswer,
        correctAnswer: getCorrectAnswer(widget.words[_currentWordIndex]),
      ));
    });

    Future.delayed(const Duration(seconds: 1), () => _nextQuiz());
  }

  _nextQuiz() {
    var words = widget.words;
    setState(() {
      selectedAnswer = null;

      if (_currentWordIndex < words.length - 1) {
        _currentWordIndex++;
      } else {
        _isFinished = true;
      }
    });

    if (_isFinished) {
      completedTime = DateTime.now().difference(startTime);
      _finishExam();
    }
  }

  _finishExam() {
    _storeResult();
    _navigateToResultPage();
  }

  _storeResult() {
    var currentUser = sl.get<FirebaseAuth>().currentUser!;
    var result = ResultModel(
      email: currentUser.email!,
      topicId: widget.topicId,
      userAnswers: userAnswers,
      totalQuestions: widget.words.length,
      completionTime: completedTime,
      score: calculateScore(),
    );

    context.read<ResultBloc>().add(StoreResult(
        result: result,
        topicId: widget.topicId,
        email: currentUser.email!,
        examType: 'quiz'));
  }

  double calculateScore() {
    int correctAnswers = 0;
    for (var answer in userAnswers) {
      if (answer.userAnswer == answer.correctAnswer) {
        correctAnswers++;
      }
    }

    return (correctAnswers / widget.words.length) * 100;
  }

  _navigateToResultPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          topicId: widget.topicId,
          words: widget.words,
          userAnswers: userAnswers,
        ),
      ),
    );
  }
}
