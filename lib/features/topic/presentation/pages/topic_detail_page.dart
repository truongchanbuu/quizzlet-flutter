import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/flash_card_preview_section.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/learn_feature_item_widget.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/word_card_list.dart';
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

  _buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: _shareTopic,
          icon: const Icon(Icons.share_outlined),
        ),
        IconButton(
          onPressed: () => _showBottomSheetOptions(context),
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }

  _showBottomSheetOptions(BuildContext context) {
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
                  onTap: () {},
                  leading: const Icon(Icons.edit),
                  title: const Text('Chỉnh sửa'),
                ),
              if (email == widget.topic.createdBy)
                ListTile(
                  onTap: () {},
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
    if (widget.topic.words.isEmpty) {
      return const Center(
        child: Text(
          'Hiện tại chưa có từ vựng nào',
          style: TextStyle(fontSize: 25),
        ),
      );
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
            const CircleAvatar(
              radius: 15,
            ),
            const SizedBox(width: 5),
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
          onTap: () {},
          title: 'Thẻ ghi nhớ',
          leading: const Icon(
            Icons.library_add_sharp,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        LearnFeatureItem(
          onTap: () {},
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
}
