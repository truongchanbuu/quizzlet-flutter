import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/features/result/presentation/bloc/result/result_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/exam/quiz_exam_page.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/exam/typing_exam_page.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class ExamSettingPage extends StatefulWidget {
  final TopicModel topic;
  const ExamSettingPage({super.key, required this.topic});

  @override
  State<ExamSettingPage> createState() => _ExamSettingPageState();
}

class _ExamSettingPageState extends State<ExamSettingPage> {
  final _qnALang = const ['en-vie', 'vie-en'];
  final _examTypes = const ['quiz', 'typing'];

  int _qnALangUserChosen = 0;
  int _examChosen = 0;
  int _isShuffling = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar();
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.topic.topicName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const Text(
              'Thiết lập kiểm tra',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              onTap: _showQnALangSetting,
              title: const Text(
                'Hỏi và trả lời:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_qnALangUserChosen == 0
                  ? 'Tiếng Anh - Tiếng Việt'
                  : 'Tiếng Việt - Tiếng Anh'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const SizedBox(height: 20),
            ListTile(
              onTap: _showExamTypeSetting,
              title: const Text(
                'Dạng câu hỏi:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_examChosen == 0 ? 'Nhiều lựa chọn' : 'Tự luận'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const SizedBox(height: 20),
            _shufflingSelection(),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _doExam,
              style: TextButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                minimumSize: const Size.fromHeight(55),
              ),
              child: const Text(
                'Làm bài kiểm tra',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showQnALangSetting() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Tùy chọn câu hỏi và câu trả lời',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    setState(
                        () => setDialogState(() => _qnALangUserChosen = 0));
                    Navigator.pop(context);
                  },
                  title: const Text('Tiếng Anh - Tiếng Việt'),
                  trailing: _qnALang[_qnALangUserChosen] == 'en-vie'
                      ? const Icon(
                          Icons.check,
                          color: Colors.blue,
                        )
                      : null,
                ),
                ListTile(
                  onTap: () {
                    setState(
                        () => setDialogState(() => _qnALangUserChosen = 1));
                    Navigator.pop(context);
                  },
                  title: const Text('Tiếng Việt - Tiếng Anh'),
                  trailing: _qnALang[_qnALangUserChosen] == 'vie-en'
                      ? const Icon(
                          Icons.check,
                          color: Colors.blue,
                        )
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _showExamTypeSetting() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Tùy chọn câu hỏi và câu trả lời',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    setState(() => setDialogState(() => _examChosen = 0));
                    Navigator.pop(context);
                  },
                  title: const Text('Nhiều lựa chọn'),
                  trailing: _examTypes[_examChosen] == 'quiz'
                      ? const Icon(
                          Icons.check,
                          color: Colors.blue,
                        )
                      : null,
                ),
                ListTile(
                  onTap: () {
                    setState(() => setDialogState(() => _examChosen = 1));
                    Navigator.pop(context);
                  },
                  title: const Text('Tự luận'),
                  trailing: _examTypes[_examChosen] == 'typing'
                      ? const Icon(
                          Icons.check,
                          color: Colors.blue,
                        )
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _shufflingSelection() {
    return SizedBox(
      width: double.infinity,
      child: ToggleSwitch(
        onToggle: (index) => setState(() => _isShuffling = index ?? 0),
        initialLabelIndex: _isShuffling,
        totalSwitches: 2,
        labels: const ['Sắp xếp theo thứ tự', 'Trộn các thẻ'],
        activeBgColor: const [Colors.indigo],
        inactiveBgColor: Colors.white,
        activeFgColor: Colors.white,
        inactiveFgColor: Colors.indigo,
        customWidths: const [double.infinity, double.infinity],
        customTextStyles: const [
          TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ],
        centerText: true,
        borderColor: const [Colors.indigo],
      ),
    );
  }

  _doExam() {
    String type = _examTypes[_examChosen];
    var currentRoute = ModalRoute.of(context);
    var currentRouteName = currentRoute?.settings.name ?? '';
    var segments = currentRouteName.split('/')
      ..removeLast()
      ..add('quiz');
    String fullRouteName = segments.join('/');

    if (type == 'quiz') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl.get<ResultBloc>(),
            child: QuizExamPage(
              topicId: widget.topic.topicId,
              words: widget.topic.words,
              mode: _qnALang[_qnALangUserChosen],
              isShuffling: _isShuffling == 1,
            ),
          ),
          settings: RouteSettings(name: fullRouteName),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl.get<ResultBloc>(),
            child: TypingExamPage(
              words: widget.topic.words,
              topicId: widget.topic.topicId,
              mode: _qnALang[_qnALangUserChosen],
              isShuffling: _isShuffling == 1,
            ),
          ),
        ),
      );
    }
  }
}
