import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/user_answer.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class ResultPage extends StatefulWidget {
  final String topicId;
  final List<WordModel> words;
  final List<UserAnswerModel?> userAnswers;

  const ResultPage({
    super.key,
    required this.words,
    required this.userAnswers,
    required this.topicId,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  var correctColor = Colors.green;
  var wrongColor = Colors.orange;

  late ValueNotifier<double> valueNotifier;
  int correctAnswersCount = 0;
  int wrongAnswersCount = 0;

  @override
  void initState() {
    super.initState();
    correctAnswersCount = widget.userAnswers
        .where((answer) => answer?.correctAnswer == answer?.userAnswer)
        .length;
    wrongAnswersCount = widget.words.length - correctAnswersCount;

    var percentage = (correctAnswersCount * 100) / widget.words.length;
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
          ModalRoute.withName('/topic/detail/${widget.topicId}'),
        ),
        icon: const Icon(Icons.close),
      ),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: [
          _buildCongratulationSection(),
          const SizedBox(height: 30),
          _buildTitleSection('Kết quả của bạn'),
          const SizedBox(height: 20),
          _buildStatsSection(),
          const SizedBox(height: 30),
          _buildTitleSection('Đáp án của bạn'),
          const SizedBox(height: 20),
          _buildAnswers(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  _buildTitleSection(title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  _buildCongratulationSection() {
    String congratulation = 'Well Done!!!';

    if (correctAnswersCount > widget.words.length / 2) {
      congratulation = 'Bạn đang không ngừng tiến bộ hơn!';
    } else if (correctAnswersCount == widget.words.length) {
      congratulation = 'Hoàn hảo là một từ ngữ dùng để miêu tả bạn đấy';
    } else {
      congratulation =
          'Cõ lẽ một chút may mắn là điều bạn mong lúc này nhưng đứng quên nâng cao kiến thức bản thân nữa nhé';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
        Expanded(flex: 1, child: _buildProgressPie(correctAnswersCount)),
        const SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Đúng',
                    style: TextStyle(
                      color: correctColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$correctAnswersCount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: correctColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sai',
                    style: TextStyle(
                      color: wrongColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$wrongAnswersCount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: wrongColor,
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

  _buildProgressPie(int correctCount) {
    return SimpleCircularProgressBar(
      mergeMode: true,
      valueNotifier: valueNotifier,
      progressColors: [correctColor],
      backColor: wrongColor,
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

  Widget _buildAnswers() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: widget.words.length,
      itemBuilder: _createAnswer,
    );
  }

  Widget _createAnswer(BuildContext context, int index) {
    var word = widget.words[index];

    var userAnswer = widget.userAnswers[index];

    var questionText = word.terminology;
    if (userAnswer?.correctAnswer.toLowerCase() ==
        word.terminology.toLowerCase()) {
      questionText = word.meaning;
    }

    bool isCorrect = userAnswer?.userAnswer?.toLowerCase() ==
        userAnswer?.correctAnswer.toLowerCase();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Câu hỏi: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 10)),
                  TextSpan(text: questionText),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: RichText(
              text: TextSpan(
                children: <InlineSpan>[
                  const TextSpan(
                    text: 'Câu trả lời của bạn: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 10)),
                  TextSpan(
                    text: userAnswer?.userAnswer ?? '[Không có câu trả lời]',
                    style: TextStyle(
                      color: isCorrect ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 5)),
                  WidgetSpan(
                    child: Icon(
                      isCorrect ? Icons.check : Icons.close,
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: RichText(
              text: TextSpan(
                children: <InlineSpan>[
                  const TextSpan(
                    text: 'Câu trả lời đúng: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 10)),
                  TextSpan(
                    text: userAnswer?.correctAnswer,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 5)),
                  const WidgetSpan(
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: isCorrect ? Colors.green : Colors.red,
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(
                  isCorrect ? Icons.check : Icons.close,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  isCorrect ? 'Đúng' : 'Sai',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
