import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/quiz_learning/remote/quiz_learning_bloc.dart';

class QuizExamPage extends StatefulWidget {
  final TopicModel topic;
  final String mode;

  const QuizExamPage({super.key, required this.topic, this.mode = 'en-vie'});

  @override
  State<QuizExamPage> createState() => _QuizExamPageState();
}

class _QuizExamPageState extends State<QuizExamPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<QuizLearningBloc>(context).add(StartQuiz());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<QuizLearningBloc, QuizLearningState>(
        builder: (context, state) {
          if (state is QuizInProgress) {
            return Text(
              '${state.currentWordIndex + 1} / ${widget.topic.words.length}',
              style: const TextStyle(
                color: Colors.black,
              ),
            );
          }
          return const Text('Quiz');
        },
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.popUntil(context,
              ModalRoute.withName('/topic/detail/${widget.topic.topicId}'));
        },
        icon: const Icon(Icons.close),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: BlocBuilder<QuizLearningBloc, QuizLearningState>(
          builder: (context, state) {
            if (state is QuizInProgress) {
              var percentage =
                  state.currentWordIndex / widget.topic.words.length;
              return LinearProgressIndicator(
                value: percentage.toDouble(),
                semanticsLabel: 'Your learning progress',
                semanticsValue: 'You learned ${percentage * 100}%',
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<QuizLearningBloc, QuizLearningState>(
      builder: (context, state) {
        if (state is QuizInProgress) {
          var options = getOptions(state.currentWordIndex);
          var questionText = widget.mode == 'en-vie'
              ? widget.topic.words[state.currentWordIndex].terminology
              : widget.topic.words[state.currentWordIndex].meaning;
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
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: options.length,
                  itemBuilder: (context, index) =>
                      _createOptions(context, options[index]),
                ),
              ),
            ],
          );
        } else if (state is QuizCompleted) {
          return const Center(
            child: Text('Quiz Completed!'),
          );
        } else if (state is QuizError) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  List<String> getOptions(int currentWordIndex) {
    var correctAnswer = widget.mode == 'en-vie'
        ? widget.topic.words[currentWordIndex].meaning
        : widget.topic.words[currentWordIndex].terminology;
    var incorrectAnswers = widget.topic.words
        .where((word) => word != widget.topic.words[currentWordIndex])
        .map((word) =>
            widget.mode == 'en-vie' ? word.meaning : word.terminology);

    if (incorrectAnswers.length > 3) {
      incorrectAnswers = incorrectAnswers.take(3);
    }

    return incorrectAnswers.toList()
      ..add(correctAnswer)
      ..shuffle();
  }

  Widget _createOptions(BuildContext context, String option) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo),
      ),
      child: ListTile(
        onTap: () {
          BlocProvider.of<QuizLearningBloc>(context)
              .add(CheckAnswerEvent(option));
        },
        title: Text(option),
      ),
    );
  }
}
