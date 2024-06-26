import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/core/util/date_time_util.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/topic/remote/topic_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/topic/topic_detail_page.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/topic/topic_item.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class LibTopicTabView extends StatefulWidget {
  const LibTopicTabView({super.key});

  @override
  State<LibTopicTabView> createState() => _LibTopicTabViewState();
}

class _LibTopicTabViewState extends State<LibTopicTabView> {
  final currentUser = sl.get<FirebaseAuth>().currentUser!;

  Timer? debounce;

  Map<String, List<TopicModel>> groupTopics = {};

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopicBloc, TopicState>(
      builder: (context, state) {
        if (state is AllTopicsLoaded) {
          groupTopics = _topicsByDate(state.topics
              .where((topic) =>
                  topic.createdBy == currentUser.email || topic.isPublic)
              .toList());
          return groupTopics.isEmpty ? _buildNoTopicShowedUI() : _buildTopics();
        } else if (state is TopicsLoaded) {
          groupTopics = _topicsByDate(state.topics
              .where((topic) =>
                  topic.createdBy == currentUser.email || topic.isPublic)
              .toList());
          return _buildTopics();
        }

        return const LoadingIndicator();
      },
    );
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
                        return TopicItem(
                          topic: topic,
                          onTap: () async {
                            var removedTopic = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => sl.get<TopicBloc>(),
                                  child: TopicDetailPage(topic: topic),
                                ),
                                settings: RouteSettings(
                                  name: '/topic/detail/${topic.topicId}',
                                ),
                              ),
                            );

                            // if (removedTopic != null) {
                            //   if (context.mounted) {
                            //     context.read<TopicBloc>().add(
                            //           GetTopics(groupTopics.values
                            //               .expand((topics) => topics.where(
                            //                   (topic) => topic != removedTopic))
                            //               .toList()),
                            //         );
                            //   }
                            // }
                          },
                        );
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
      onChanged: _search,
      decoration: const InputDecoration(
        labelText: 'FILTER',
      ),
    );
  }

  // Handle data
  Map<String, List<TopicModel>> _topicsByDate(List<TopicModel> allTopics) {
    Map<String, List<TopicModel>> groupTopics = {};

    for (var topic in allTopics) {
      DateTime dateToSort = topic.lastAccess ?? topic.createdAt;

      var groupName = '';

      if (isToday(dateToSort)) {
        groupName = 'Hôm nay';
      } else if (isYesterday(dateToSort)) {
        groupName = 'Hôm qua';
      } else if (isThisWeek(dateToSort)) {
        groupName = 'Tuần này';
      } else if (isLastWeek(dateToSort)) {
        groupName = 'Tuần trước';
      } else if (isLastMonth(dateToSort)) {
        groupName = 'Tháng trước';
      } else {
        groupName = 'Tháng ${dateToSort.month}/${dateToSort.year}';
      }

      if (!groupTopics.containsKey(groupName)) {
        groupTopics[groupName] = [];
      }

      groupTopics[groupName]!.add(topic);
    }

    return _sortTopicsByDate(groupTopics);
  }

  Map<String, List<TopicModel>> _sortTopicsByDate(
      Map<String, List<TopicModel>> groupTopics) {
    List<String> priorityOrder = [
      'Hôm nay',
      'Hôm qua',
      'Tuần này',
      'Tuần trước',
      'Tháng trước'
    ];

    Map<String, List<TopicModel>> sortedGroupTopics = {};

    for (var groupName in priorityOrder) {
      if (groupTopics.containsKey(groupName)) {
        sortedGroupTopics[groupName] = groupTopics[groupName]!;
        groupTopics.remove(groupName);
      }
    }

    for (var entry in groupTopics.entries) {
      sortedGroupTopics[entry.key] = entry.value;
    }

    return sortedGroupTopics;
  }

  _search(String value) {
    value = value.trim().toLowerCase();

    if (value.isEmpty) {
      context.read<TopicBloc>().add(const GetTopicsByName(''));
    }

    if (value.length >= 2) {
      if (debounce?.isActive ?? false) debounce?.cancel();

      debounce = Timer(
        const Duration(milliseconds: 500),
        () {
          context.read<TopicBloc>().add(GetTopicsByName(value));
        },
      );
    }
  }
}
