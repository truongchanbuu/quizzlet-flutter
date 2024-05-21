import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/exam/result_page.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class QuizExamPage extends StatefulWidget {
  final TopicModel topic;
  final String mode;
  const QuizExamPage({super.key, required this.topic, this.mode = 'en-vie'});

  @override
  State<QuizExamPage> createState() => _QuizExamPageState();
}

class _QuizExamPageState extends State<QuizExamPage> {
  final flutterTTS = sl.get<FlutterTts>();
  Map? _currentVoice;
  int _currentWordIndex = 0;

  List<WordModel> wrongAnswers = List.empty(growable: true);
  List<WordModel> correctAnswers = List.empty(growable: true);
  String? selectedAnswer;
  late List<String?> userAnswers;

  bool _isFinished = false;

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
    userAnswers = List.filled(widget.topic.words.length, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    var percentage = (_currentWordIndex + 1) / widget.topic.words.length;
    return AppBar(
      title: Text(
        '${_currentWordIndex + 1} / ${widget.topic.words.length}',
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
        onPressed: () => Navigator.popUntil(context,
            ModalRoute.withName('/topic/detail/${widget.topic.topicId}')),
        icon: const Icon(Icons.close),
      ),
    );
  }

  List<String>? currentOptions;
  _buildBody() {
    List<String> options;
    if (selectedAnswer != null && currentOptions != null) {
      options = currentOptions!;
    } else {
      options = getOptions();
      currentOptions = options;
    }

    var questionText = widget.mode == 'en-vie'
        ? widget.topic.words[_currentWordIndex].terminology
        : widget.topic.words[_currentWordIndex].meaning;

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
                    if (widget.topic.words[_currentWordIndex].illustratorUrl !=
                        null) ...[
                      const SizedBox(height: 5),
                      Image.network(
                        widget.topic.words[_currentWordIndex].illustratorUrl!,
                        width: 100,
                        height: 100,
                      )
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
                itemBuilder: (context, index) => _createOptions(
                  options[index],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createOptions(String option) {
    final isCorrectAnswer = (selectedAnswer != null &&
        selectedAnswer == option &&
        selectedAnswer ==
            (widget.mode == 'en-vie'
                ? widget.topic.words[_currentWordIndex].meaning
                : widget.topic.words[_currentWordIndex].terminology));
    final isSelected = selectedAnswer == option;

    Color tileColor;
    if (selectedAnswer == null) {
      tileColor = Colors.white;
    } else if (isSelected) {
      tileColor = isCorrectAnswer ? Colors.green : Colors.red;
    } else if (isCorrectAnswer) {
      tileColor = Colors.green;
    } else {
      tileColor = Colors.white;
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
        title: Text(option),
      ),
    );
  }

  // Handle data
  getCorrectAnswer() {
    return widget.mode == 'en-vie'
        ? widget.topic.words[_currentWordIndex].meaning
        : widget.topic.words[_currentWordIndex].terminology;
  }

  List<String> getOptions() {
    var correctAnswer = getCorrectAnswer();
    var incorrectAnswers = widget.topic.words
        .where((word) => word != widget.topic.words[_currentWordIndex])
        .map((word) =>
            widget.mode == 'en-vie' ? word.meaning : word.terminology);

    if (incorrectAnswers.length > 3) {
      incorrectAnswers.take(3);
    }

    return incorrectAnswers.toList()
      ..add(correctAnswer)
      ..shuffle();
  }

  _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      userAnswers[_currentWordIndex] = answer;
    });

    var currentWord = widget.topic.words[_currentWordIndex];
    bool isCorrect = answer == getCorrectAnswer();

    if (isCorrect) {
      correctAnswers.add(currentWord);
    } else {
      wrongAnswers.add(currentWord);
    }

    Future.delayed(const Duration(seconds: 1), () => _nextQuiz());
  }

  _nextQuiz() {
    setState(() {
      selectedAnswer = null;
      if (_currentWordIndex < widget.topic.words.length - 1) {
        _currentWordIndex++;
      } else {
        _isFinished = true;
      }
    });

    if (_isFinished) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            topic: widget.topic,
            mode: widget.mode,
            correctAnswers: correctAnswers,
            wrongAnswers: wrongAnswers,
            userAnswers: userAnswers,
          ),
        ),
      );
    }
  }
}
