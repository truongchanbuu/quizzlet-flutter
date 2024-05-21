import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/exam/result_page.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class TypingExamPage extends StatefulWidget {
  final TopicModel topic;
  final String mode;
  const TypingExamPage({super.key, required this.topic, this.mode = 'en-vie'});

  @override
  State<TypingExamPage> createState() => _TypingExamPageState();
}

class _TypingExamPageState extends State<TypingExamPage> {
  final flutterTTS = sl.get<FlutterTts>();
  Map? _currentVoice;
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

  late final TextEditingController _answerController;

  int _currentWordIndex = 0;
  List<WordModel> wrongAnswers = List.empty(growable: true);
  List<WordModel> correctAnswers = List.empty(growable: true);
  late List<String?> userAnswers;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    initTTS();
    userAnswers = List.filled(widget.topic.words.length, null);
    _answerController = TextEditingController();
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

  _buildBody() {
    var questionText = widget.mode == 'en-vie'
        ? widget.topic.words[_currentWordIndex].terminology
        : widget.topic.words[_currentWordIndex].meaning;

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
              child: TextField(
                onSubmitted: _checkAnswer,
                controller: _answerController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  hintText: 'Nhập đáp án vào đây',
                  suffix: TextButton(
                    onPressed: _nextQuestion,
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
  String getCorrectAnswer() {
    return widget.mode == 'en-vie'
        ? widget.topic.words[_currentWordIndex].meaning
        : widget.topic.words[_currentWordIndex].terminology;
  }

  _checkAnswer(String answer) {
    setState(() {
      userAnswers[_currentWordIndex] = answer;
    });

    var currentWord = widget.topic.words[_currentWordIndex];
    bool isCorrect = answer.toLowerCase() == getCorrectAnswer().toLowerCase();

    String title;
    if (isCorrect) {
      correctAnswers.add(currentWord);
      title = 'Chính xác';
    } else {
      wrongAnswers.add(currentWord);
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
