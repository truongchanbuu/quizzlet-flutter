import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/core/util/date_time_util.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';

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
    // topics = [
    //   TopicModel(
    //     topicId: '001',
    //     topicName: 'Culture',
    //     words: const [],
    //     isPublic: false,
    //     createdBy: 'truongbuu1593@gmail.com',
    //     lastAccess: DateTime.now(),
    //     createdAt: DateTime(2024, 5, 12),
    //   ),
    //   TopicModel(
    //     topicId: '002',
    //     topicName: 'Culture',
    //     words: const [],
    //     isPublic: false,
    //     createdBy: 'test@gmail.com',
    //     lastAccess: null,
    //     createdAt: DateTime(2024, 5, 12),
    //   ),
    //   TopicModel(
    //     topicId: '003',
    //     topicName: 'Culture',
    //     words: const [],
    //     isPublic: false,
    //     createdBy: 'test@gmail.com',
    //     lastAccess: DateTime.now(),
    //     createdAt: DateTime(2024, 5, 12),
    //   ),
    //   TopicModel(
    //     topicId: '004',
    //     topicName: 'Culture',
    //     words: const [],
    //     isPublic: false,
    //     createdBy: 'test@gmail.com',
    //     lastAccess: DateTime.now(),
    //     createdAt: DateTime(2024, 5, 12),
    //   ),
    // ];
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
    return ListView.separated(
        itemBuilder: (context, index) {
          String groupName = groupTopics.keys.toList()[index];
          List<TopicModel> topics = groupTopics[groupName]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(groupName),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var topic = topics[index];
                  return _createTopicItem(topic);
                },
                itemCount: topics.length,
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: groupTopics.length);
  }

  Widget _createTopicItem(TopicModel topic) {
    return InkWell(
      onTap: () {},
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Material(
        elevation: 1,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: ListTile(
            title: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.topicName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${topic.words.length} thuật ngữ',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                )),
            contentPadding: const EdgeInsets.all(20),
            subtitle: Row(
              children: [
                const CircleAvatar(
                  radius: 15,
                ),
                const SizedBox(width: 10),
                Text(
                  topic.createdBy,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
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
