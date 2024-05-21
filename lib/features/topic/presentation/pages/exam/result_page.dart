import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class ResultPage extends StatefulWidget {
  final TopicModel topic;
  final List<WordModel> correctAnswers;
  final List<WordModel> wrongAnswers;
  final String mode;
  final List<String?> userAnswers;

  const ResultPage({
    super.key,
    required this.mode,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.userAnswers,
    required this.topic,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  var correctColor = Colors.green;
  var wrongColor = Colors.orange;

  late ValueNotifier<double> valueNotifier;

  @override
  void initState() {
    super.initState();
    var percentage =
        (widget.correctAnswers.length * 100) / widget.topic.words.length;
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
      padding: const EdgeInsets.all(20.0),
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

    if (widget.correctAnswers.length > widget.wrongAnswers.length) {
      congratulation = 'Bạn đang không ngừng tiến bộ hơn!';
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
        Expanded(flex: 1, child: _buildProgressPie()),
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
                    '${widget.correctAnswers.length}',
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
                    '${widget.wrongAnswers.length}',
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

  _buildProgressPie() {
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
      itemCount: widget.topic.words.length,
      itemBuilder: _createAnswer,
    );
  }

  Widget _createAnswer(BuildContext context, int index) {
    var word = widget.topic.words[index];
    var questionText =
        widget.mode == 'en-vie' ? word.terminology : word.meaning;
    var correctAnswer =
        widget.mode == 'en-vie' ? word.meaning : word.terminology;

    var userAnswer = widget.userAnswers[index];

    bool isCorrect = correctAnswer.toLowerCase() == userAnswer?.toLowerCase();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Câu hỏi: $questionText'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
                'Câu trả lời của bạn: ${userAnswer ?? '[Không có câu trả lời]'}'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: Text('Câu trả lời đúng: $correctAnswer'),
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
