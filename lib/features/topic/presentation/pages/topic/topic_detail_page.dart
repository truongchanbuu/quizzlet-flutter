import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/topic/remote/topic_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/exam/exam_settings_page.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/flashcard/flash_card_page.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/topic/create_topic_page.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/flashcard/flash_card_preview_section.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/topic/learn_feature_item_widget.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/word/word_card_list.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class TopicDetailPage extends StatefulWidget {
  final TopicModel topic;
  const TopicDetailPage({super.key, required this.topic});

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  _buildAppBar(BuildContext ctx) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: _shareTopic,
          icon: const Icon(Icons.share_outlined),
        ),
        IconButton(
          onPressed: () => _showBottomSheetOptions(ctx),
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }

  _showBottomSheetOptions(BuildContext ctx) {
    String email = sl.get<FirebaseAuth>().currentUser!.email!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.folder_outlined),
                title: const Text('Thêm vào thư mục'),
              ),
              ListTile(
                onTap: _shareTopic,
                leading: const Icon(Icons.share_outlined),
                title: const Text('Chia sẻ'),
              ),
              if (email == widget.topic.createdBy)
                ListTile(
                  onTap: _editTopic,
                  leading: const Icon(Icons.edit),
                  title: const Text('Chỉnh sửa'),
                ),
              if (email == widget.topic.createdBy)
                ListTile(
                  onTap: () => _deleteTopic(ctx),
                  leading: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Xóa chủ đề',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _buildBody(context) {
    return BlocConsumer<TopicBloc, TopicState>(
      builder: (context, state) {
        if (state is DeletingTopic) {
          return const LoadingIndicator();
        }

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PreviewFlashCardSection(words: widget.topic.words),
                const SizedBox(height: 10),
                _buildTopicInfoSection(),
                const SizedBox(height: 20),
                _buildLearnFeatureSection(),
                const SizedBox(height: 20),
                const Text(
                  'Thẻ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                WordCardList(words: widget.topic.words),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is DeleteTopicFailed) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            headerAnimationLoop: false,
            title: 'Xóa thất bại',
            desc: 'Hãy thử lại: ${state.message}',
            btnCancelOnPress: () {},
          ).show();
        } else if (state is DeleteTopicSuccess) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      },
    );
  }

  _buildTopicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.topic.topicName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              widget.topic.createdBy,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(width: 20),
            Text(
              '${widget.topic.words.length} thuật ngữ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  _buildLearnFeatureSection() {
    return Column(
      children: [
        LearnFeatureItem(
          onTap: _navigateToFlashCardLearnPage,
          title: 'Thẻ ghi nhớ',
          leading: const Icon(
            Icons.library_add_sharp,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        LearnFeatureItem(
          onTap: _navigateToExamSettings,
          title: 'Kiểm tra',
          leading: const Icon(
            Icons.library_books_sharp,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  // Handle data
  _shareTopic() {}

  _navigateToExamSettings() {
    final currentRoute = ModalRoute.of(context);
    final currentRouteName = currentRoute?.settings.name ?? '';
    const newRouteName = '/exam/settings';
    final fullRouteName = '$currentRouteName$newRouteName';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExamSettingPage(topic: widget.topic),
        settings: RouteSettings(name: fullRouteName),
      ),
    );
  }

  _navigateToFlashCardLearnPage() {
    final currentRoute = ModalRoute.of(context);
    final currentRouteName = currentRoute?.settings.name ?? '';
    const newRouteName = '/flashcards/';
    final fullRouteName = '$currentRouteName$newRouteName';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashCardPage(words: widget.topic.words),
        settings: RouteSettings(name: fullRouteName),
      ),
    );
  }

  _editTopic() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl.get<TopicBloc>(),
            child: CreateTopicPage(
              topic: widget.topic,
            ),
          ),
        ));
  }

  _deleteTopic(BuildContext ctx) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Bạn muốn xóa chủ đề này vĩnh viễn',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ctx.read<TopicBloc>().add(RemoveTopic(widget.topic.topicId));
            },
            child: const Text('Delete'),
          )
        ],
      ),
    );
  }
}
