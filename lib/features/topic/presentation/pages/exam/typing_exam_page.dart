import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:quizzlet_fluttter/features/result/data/models/result.dart';
import 'package:quizzlet_fluttter/features/result/presentation/bloc/result/result_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/user_answer.dart';
import 'package:quizzlet_fluttter/features/result/presentation/pages/result_page.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class TypingExamPage extends StatefulWidget {
  final List<WordModel> words;
  final String topicId;
  final String mode;
  final bool isShuffling;

  const TypingExamPage({
    super.key,
    required this.topicId,
    required this.words,
    this.isShuffling = false,
    this.mode = 'en-vie',
  });

  @override
  State<TypingExamPage> createState() => _TypingExamPageState();
}

class _TypingExamPageState extends State<TypingExamPage> {
  final flutterTTS = sl.get<FlutterTts>();
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

  late final TextEditingController _answerController;

  int _currentWordIndex = 0;
  DateTime startTime = DateTime.now();
  late Duration completedTime;

  late List<UserAnswerModel> userAnswers;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    initTTS();
    _answerController = TextEditingController();
    userAnswers = List.empty(growable: true);

    if (widget.isShuffling) {
      widget.words.shuffle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    var percentage = (_currentWordIndex + 1) / widget.words.length;
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
      leading: IconButton(
        onPressed: () => Navigator.popUntil(
            context, ModalRoute.withName('/topic/detail/${widget.topicId}')),
        icon: const Icon(Icons.close),
      ),
    );
  }

  _buildBody() {
    var word = widget.words[_currentWordIndex];

    var questionText =
        widget.mode == 'en-vie' ? word.terminology : word.meaning;

    if (widget.mode == 'en-vie') {
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
                    if (word.illustratorUrl != null) ...[
                      const SizedBox(height: 5),
                      Image.network(
                        word.illustratorUrl!,
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
              child: TextField(
                onSubmitted: _checkAnswer,
                controller: _answerController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  hintText: 'Nhập đáp án vào đây',
                  suffix: TextButton(
                    onPressed: () => _checkAnswer(null),
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

  // Handle data
  String getCorrectAnswer(WordModel word) {
    return widget.mode == 'en-vie' ? word.meaning : word.terminology;
  }

  _checkAnswer(String? answer) {
    var word = widget.words[_currentWordIndex];

    setState(() {
      userAnswers.add(UserAnswerModel(
        topicId: widget.topicId,
        wordId: word.wordId,
        userAnswer: answer,
        correctAnswer: getCorrectAnswer(word),
      ));
    });

    bool isCorrect =
        answer?.toLowerCase() == getCorrectAnswer(word).toLowerCase();

    String title;
    if (isCorrect) {
      title = 'Chính xác';
    } else {
      title = 'Chưa đúng';
    }

    AwesomeDialog(
      context: context,
      title: title,
      headerAnimationLoop: false,
      dialogType: isCorrect ? DialogType.success : DialogType.error,
      btnOkText: title,
      btnOkOnPress: _nextQuestion,
      btnOkColor: isCorrect ? Colors.green : Colors.red,
      dismissOnTouchOutside: false,
    ).show();
  }

  _nextQuestion() {
    setState(() {
      _answerController.text = '';

      if (_currentWordIndex < widget.words.length - 1) {
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

    context.read<ResultBloc>().add(
          StoreResult(
              result: result,
              topicId: widget.topicId,
              email: currentUser.email!,
              examType: 'typing'),
        );
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
