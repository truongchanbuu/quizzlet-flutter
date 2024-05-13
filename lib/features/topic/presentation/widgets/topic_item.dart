import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/topic_detail_page.dart';

class TopicItem extends StatelessWidget {
  final TopicModel topic;
  const TopicItem({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TopicDetailPage(topic: topic),
            settings: RouteSettings(
              name: '/topic/detail/${topic.topicId}',
            ),
          ),
        );
      },
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
}
