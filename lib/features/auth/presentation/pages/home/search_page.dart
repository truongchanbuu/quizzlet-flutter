import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/search_box.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/folder.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/folder/remote/folder_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/topic/remote/topic_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/folder/folder_detail_page.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/topic/topic_detail_page.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List results = [];
  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: SearchBox(
        isAutoFocus: true,
        onChanged: _search,
      ),
    );
  }

  _buildBody() {
    return Builder(
      builder: (context) {
        final topicState = context.watch<TopicBloc>().state;
        final folderState = context.watch<FolderBloc>().state;

        results.clear();

        if (topicState is TopicsLoaded) {
          if (topicState.topics.isNotEmpty) {
            results.add(topicState.topics);
          }
        }

        if (folderState is FolderLoaded) {
          if (folderState.folders.isNotEmpty) {
            results.add(folderState.folders);
          }
        }

        if (results.isEmpty) {
          const textStyle = TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          );

          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nhập một chủ để hoặc từ khóa',
                  style: textStyle,
                ),
                SizedBox(height: 15),
                Text(
                  'Mẹo: Càng cụ thể càng tốt',
                  style: textStyle,
                ),
              ],
            ),
          );
        }

        return _buildListResults(results);
      },
    );
  }

  _buildListResults(List results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => _createResultItem(results[index]),
    );
  }

  _createResultItem(item) {
    String title = '';
    String trailing = '';
    bool isTopic = false;

    if (item[0] is FolderModel) {
      isTopic = false;
      title = item[0].folderName;
      trailing = 'Folder';
    } else if (item[0] is TopicModel) {
      isTopic = true;
      title = item[0].topicName;
      trailing = 'Topic';
    }

    return ListTile(
      onTap: isTopic
          ? () => _navigateToTopic(item[0])
          : () => _navigateToFolder(item[0]),
      leading: const Icon(Icons.search),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      trailing: Text(
        trailing,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  _search(String value) {
    value = value.trim().toLowerCase();

    if (value.length >= 2) {
      if (debounce?.isActive ?? false) debounce?.cancel();

      debounce = Timer(
        const Duration(milliseconds: 500),
        () {
          context.read<TopicBloc>().add(GetTopicsByName(value));
          context.read<FolderBloc>().add(GetFoldersByName(value));
        },
      );
    }
  }

  _navigateToTopic(TopicModel topic) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => sl.get<TopicBloc>(),
                child: TopicDetailPage(topic: topic)),
            settings: RouteSettings(name: '/topic/detail/${topic.topicId}')));
  }

  _navigateToFolder(FolderModel folder) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => sl.get<FolderBloc>(),
              child: FolderDetailPage(folder: folder)),
          settings: RouteSettings(name: '/folder/detail/${folder.folderId}'),
        ));
  }
}
