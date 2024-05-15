import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/core/util/date_time_util.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/topic_item.dart';

class LibTopicTabView extends StatefulWidget {
  const LibTopicTabView({super.key});

  @override
  State<LibTopicTabView> createState() => _LibTopicTabViewState();
}

class _LibTopicTabViewState extends State<LibTopicTabView> {
  List<TopicModel> topics = [];
  final Map<String, List<TopicModel>> groupTopics = {};

  @override
  void initState() {
    super.initState();
    topics = [
      TopicModel(
        topicId: '001',
        topicName: 'Culture',
        words: const [],
        isPublic: false,
        createdBy: 'truongbuu1593@gmail.com',
        lastAccess: DateTime.now(),
        createdAt: DateTime(2024, 5, 12),
      ),
      TopicModel(
        topicId: '002',
        topicName: 'Culture',
        words: const [],
        isPublic: false,
        createdBy: 'test@gmail.com',
        lastAccess: null,
        createdAt: DateTime(2024, 5, 12),
      ),
      TopicModel(
        topicId: '003',
        topicName: 'Culture',
        words: const [],
        isPublic: false,
        createdBy: 'test@gmail.com',
        lastAccess: DateTime.now(),
        createdAt: DateTime(2024, 5, 12),
      ),
      TopicModel(
        topicId: '004',
        topicName: 'Culture',
        words: const [
          WordModel(
              wordId: 'W001',
              terminology: 'Blue Archive',
              meaning: 'Hocsinheptoi'),
          WordModel(
              wordId: 'W002',
              terminology: 'Blue Archive',
              meaning: 'Motdoiliemkhiet'),
          WordModel(
              wordId: 'W003',
              terminology: 'Blue Archive',
              meaning: 'hocsinhngaycangmatday'),
        ],
        isPublic: false,
        createdBy: 'test@gmail.com',
        lastAccess: DateTime.now(),
        createdAt: DateTime(2024, 5, 12),
      ),
      TopicModel(
        topicId: '005',
        topicName: 'Culture 1',
        words: const [],
        isPublic: false,
        createdBy: 'test@gmail.com',
        lastAccess: DateTime(2023, 10, 10),
        createdAt: DateTime(2024, 5, 12),
      ),
    ];
    _topicsByDate(topics);
  }

  @override
  Widget build(BuildContext context) {
    return groupTopics.isEmpty ? _buildNoTopicShowedUI() : _buildTopics();
  }

  _buildNoTopicShowedUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Chưa có chủ đề nào ở đây'),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/topic/create');
          },
          style: TextButton.styleFrom(
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            backgroundColor: Colors.indigo,
            padding: const EdgeInsets.all(20),
          ),
          child: const Text(
            'Hãy cùng tạo ra những chủ đề thật hấp dẫn',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  _buildTopics() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 20),
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                String groupName = groupTopics.keys.toList()[index];
                List<TopicModel> topics = groupTopics[groupName]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groupName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var topic = topics[index];
                        return TopicItem(topic: topic);
                      },
                      itemCount: topics.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: groupTopics.length),
        ],
      ),
    );
  }

  _buildSearchBar() {
    return TextField(
      onChanged: (value) {},
      decoration: const InputDecoration(
        labelText: 'BỘ LỌC',
      ),
    );
  }

  // Handle data
  _topicsByDate(List<TopicModel> allTopics) {
    for (var topic in allTopics) {
      // Need to get user's email
      String email = 'truongbuu@gmail.com';

      DateTime dateToSort = topic.createdBy != email && topic.lastAccess != null
          ? topic.lastAccess!
          : topic.createdAt;

      var groupName = '';

      if (isToday(dateToSort)) {
        groupName = 'Hôm nay';
      } else if (isYesterday(dateToSort)) {
        groupName = 'Hôm qua';
      } else if (isThisWeek(dateToSort)) {
        groupName = 'Tuần này';
      } else if (isLastWeek(dateToSort)) {
        groupName = 'Tuần trước';
      } else if (isLastWeek(dateToSort)) {
        groupName = 'Tháng trước';
      } else {
        groupName = 'Tháng ${dateToSort.month}/${dateToSort.year}';
      }

      if (!groupTopics.containsKey(groupName)) {
        groupTopics[groupName] = [];
      }

      groupTopics[groupName]!.add(topic);
    }
  }
}
