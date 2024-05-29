import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/flashcard/flash_card_page.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class ConclusionPage extends StatefulWidget {
  final TopicModel topic;
  final List<WordModel> studyingWords;
  final List<WordModel> learnedWords;

  const ConclusionPage({
    super.key,
    required this.studyingWords,
    required this.learnedWords,
    required this.topic,
  });

  @override
  State<ConclusionPage> createState() => _ConclusionPageState();
}

class _ConclusionPageState extends State<ConclusionPage> {
  var learnedColor = Colors.green;
  var studyingColor = Colors.orange;

  late ValueNotifier<double> valueNotifier;
  int learnedWordsCount = 0;
  int studyingWordsCount = 0;
  int remainCount = 0;

  @override
  void initState() {
    super.initState();
    learnedWordsCount = widget.learnedWords.length;
    studyingWordsCount = widget.studyingWords.length;
    remainCount =
        widget.topic.words.length - learnedWordsCount - studyingWordsCount;

    var percentage =
        (learnedWordsCount * 100) / (learnedWordsCount + studyingWordsCount);

    valueNotifier = ValueNotifier(percentage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.popUntil(
          context,
          ModalRoute.withName('/topic/detail/${widget.topic.topicId}'),
        ),
        icon: const Icon(Icons.close),
      ),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Expanded(child: _buildCongratulationSection()),
          Expanded(child: _buildStatsSection()),
          const SizedBox(height: 30),
          Column(
            children: [
              Opacity(
                opacity: studyingWordsCount > 0 ? 1 : 0.5,
                child: TextButton(
                  onPressed:
                      studyingWordsCount > 0 ? _continueToPractice : null,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: const RoundedRectangleBorder(),
                    minimumSize: const Size.fromHeight(55),
                  ),
                  child: const Text(
                    'Tiếp tục ôn thuật ngữ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _resetFlashCards,
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(55),
                  shape: const RoundedRectangleBorder(),
                ),
                child: const Text(
                  'Đặt lại thẻ ghi nhớ',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  _buildCongratulationSection() {
    String congratulation =
        'Bạn đang làm rất tuyệt! Hãy tiếp tục vào những thuật ngữ khó';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                congratulation,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                  'Hãy tiếp tục ôn luyện cho đến khi nắm chắc được kiến thức.'),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Image.asset('assets/images/congratulation.png')),
      ],
    );
  }

  _buildStatsSection() {
    return Row(
      children: [
        Expanded(flex: 1, child: _buildProgressPie()),
        const SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Biết',
                    style: TextStyle(
                      color: learnedColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$learnedWordsCount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: learnedColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Đang học',
                    style: TextStyle(
                      color: studyingColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$studyingWordsCount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: studyingColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Còn lại',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$remainCount',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildProgressPie() {
    return SimpleCircularProgressBar(
      mergeMode: true,
      valueNotifier: valueNotifier,
      progressColors: [learnedColor],
      backColor: studyingColor,
      onGetText: (double value) {
        return Text(
          '${value.toInt()}%',
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  _continueToPractice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashCardPage(
          topic: widget.topic,
          words: widget.studyingWords,
        ),
      ),
    );
  }

  _resetFlashCards() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FlashCardPage(
          topic: widget.topic,
        ),
      ),
    );
  }
}
