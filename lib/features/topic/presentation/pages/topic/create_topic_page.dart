import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/core/util/image_util.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/topic/remote/topic_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/topic/topic_detail_page.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/topic/topic_setting_page.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/word_info_section.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class CreateTopicPage extends StatefulWidget {
  final TopicModel? topic;
  const CreateTopicPage({super.key, this.topic});

  @override
  State<CreateTopicPage> createState() => _CreateTopicPageState();
}

class _CreateTopicPageState extends State<CreateTopicPage> {
  late final GlobalKey<FormState> _mainFormKey;

  late final List<WordInfoSection> wordSections;

  late TopicModel topic;

  String? topicName;
  String? topicDesc;
  dynamic isPublic = false;

  final currentUser = sl.get<FirebaseAuth>().currentUser!;

  @override
  void initState() {
    super.initState();
    _mainFormKey = GlobalKey();
    wordSections = List.empty(growable: true);

    if (widget.topic != null) {
      topic = widget.topic!;
      topicName = topic.topicName;
      topicDesc = topic.topicDesc;
      isPublic = topic.isPublic;
      for (var word in topic.words) {
        wordSections.add(WordInfoSection(
          index: wordSections.length - 1,
          word: word,
          onDelete: () => _deleteWordForm(word),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // Build UI methods
  _buildAppBar() {
    return AppBar(
      title: Text(
        widget.topic != null
            ? 'Chỉnh sửa học phần'
            : wordSections.length <= 2
                ? 'Tạo học phần'
                : '${wordSections.length} / ${wordSections.length}',
        style: const TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            isPublic = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TopicSettingPage(
                  isPublic: isPublic,
                ),
              ),
            );
          },
          icon: const Icon(Icons.settings_outlined),
        ),
        IconButton(
          onPressed: () => _validateMainForm(context),
          icon: const Icon(Icons.check),
        ),
      ],
    );
  }

  _buildBody() {
    return BlocConsumer<TopicBloc, TopicState>(
      listener: (context, state) {
        if (state is CreateTopicFailed || state is UpdateTopicFailed) {
          String title =
              state is CreateTopicFailed ? 'Tạo thất bại' : 'Cập nhật thất bại';

          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            headerAnimationLoop: false,
            title: title,
            desc: 'Hãy thử lại sau',
            btnCancelOnPress: () {},
          ).show();
        } else if (state is CreateTopicSuccess || state is UpdateTopicSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => sl.get<TopicBloc>(),
                child: TopicDetailPage(topic: topic),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is Creating || state is Updating) {
          return const LoadingIndicator();
        }

        return SingleChildScrollView(
          child: Form(
            key: _mainFormKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    validator: (name) {
                      if (name?.isEmpty ?? true) {
                        return 'HÃY NHẬP TÊN CỦA CHỦ ĐỀ CẦN TẠO';
                      }

                      return null;
                    },
                    onSaved: (newValue) => topicName = newValue,
                    initialValue: topicName,
                    decoration: const InputDecoration(
                      hintText: 'Chủ đề',
                      border: UnderlineInputBorder(),
                      focusColor: Colors.indigo,
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'CHỦ ĐỀ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onSaved: (newValue) => topicDesc = newValue,
                    initialValue: topicDesc,
                    decoration: const InputDecoration(
                      hintText: 'Mô tả',
                      border: UnderlineInputBorder(),
                      focusColor: Colors.indigo,
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'MÔ TẢ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => wordSections[index],
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: wordSections.length,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          WordModel word = WordModel(
              wordId: '${wordSections.length}', terminology: '', meaning: '');
          wordSections.add(WordInfoSection(
            index: wordSections.length - 1,
            word: word,
            onDelete: () => _deleteWordForm(word),
          ));
        });
      },
      shape: const CircleBorder(side: BorderSide.none),
      backgroundColor: Colors.indigo,
      tooltip: 'Thêm từ mới',
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  _showAlertAboutNotEnoughWord() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Cần điền ít nhất 2 thuật ngữ và định nghĩa',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK')),
        ],
      ),
    );
  }

  // Handle data
  bool validateAllForm() {
    bool isValidated = true;

    if (wordSections.length < 2) {
      _showAlertAboutNotEnoughWord();
      isValidated = false;
    }

    for (var form in wordSections) {
      isValidated = isValidated && form.isValidated();
    }

    return isValidated;
  }

  _validateMainForm(BuildContext context) async {
    if (_mainFormKey.currentState?.validate() ?? false) {
      _mainFormKey.currentState?.save();

      bool isAllValidated = validateAllForm();

      if (isAllValidated) {
        topic = await createTopic();
        if (context.mounted) {
          if (widget.topic != null) {
            context.read<TopicBloc>().add(EditTopic(topic));
          } else {
            context.read<TopicBloc>().add(CreateTopic(topic));
          }
        }
      }
    }
  }

  Future<List<WordModel>> createWords(
      BuildContext context, String topicId) async {
    List<WordModel> words = List.empty(growable: true);

    for (var wordSection in wordSections) {
      WordModel word = wordSection.word;

      if (word.illustratorUrl != null &&
          (!word.illustratorUrl!.startsWith('https://') &&
              !word.illustratorUrl!.startsWith('http://'))) {
        String illustrator =
            await uploadIllustrator(topicId, word.wordId, word.illustratorUrl!);
        word.illustratorUrl = illustrator;
      }
      words.add(word);
    }

    return words;
  }

  String generateTopicId() {
    return '${topicName!.trim().toLowerCase().replaceAll(' ', '')}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<TopicModel> createTopic() async {
    String topicId =
        widget.topic != null ? widget.topic!.topicId : generateTopicId();
    List<WordModel> words = await createWords(context, topicId);
    return TopicModel(
      topicId: topicId,
      topicName: topicName!,
      words: words,
      topicDesc: topicDesc,
      isPublic: isPublic,
      createdBy: currentUser.email ?? 'Unknown',
      lastAccess: null,
      createdAt: DateTime.now(),
    );
  }

  _deleteWordForm(WordModel word) {
    setState(() {
      var index = wordSections
          .indexWhere((wordSection) => wordSection.word.wordId == word.wordId);

      wordSections.removeAt(index);
    });
  }
}
