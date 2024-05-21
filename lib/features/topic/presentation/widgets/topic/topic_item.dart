import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';

class TopicItem extends StatelessWidget {
  final TopicModel topic;
  final Function() onTap;
  final Color? borderColor;
  const TopicItem({
    super.key,
    required this.topic,
    required this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Material(
        elevation: 2,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: borderColor ?? Colors.transparent,
            ),
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
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            contentPadding: const EdgeInsets.all(20),
            subtitle: Row(
              children: [
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
