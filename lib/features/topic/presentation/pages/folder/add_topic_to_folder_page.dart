import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/topic/remote/topic_bloc.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class AddTopicFolderPage extends StatefulWidget {
  const AddTopicFolderPage({super.key});

  @override
  State<AddTopicFolderPage> createState() => _AddTopicFolderPageState();
}

class _AddTopicFolderPageState extends State<AddTopicFolderPage>
    with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;
  final currentUser = sl.get<FirebaseAuth>().currentUser!;

  final List<Tab> _tabs = [
    const Tab(
      text: 'ĐÃ TẠO',
    ),
    const Tab(
      text: 'ĐÃ HỌC',
    ),
  ];

  late final TabController _tabController;
  final List<TopicModel> _topics = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      title: const Text(
        'Thêm chủ đề',
        style: TextStyle(color: Colors.black),
      ),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.check))],
      bottom: _buildTabBar(),
    );
  }

  _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildCreatedTopicsTab(),
        const Text('LEARNED'),
      ],
    );
  }

  _buildTabBar() {
    return TabBar(
      controller: _tabController,
      onTap: (value) => setState(() {
        _currentTabIndex = value;
      }),
      tabs: _tabs,
    );
  }

  Widget _buildCreatedTopicsTab() {
    return BlocConsumer<TopicBloc, TopicState>(
      listener: (context, state) {
        if (state is TopicsLoadFailure) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            headerAnimationLoop: false,
            title: 'Đã có lỗi xảy ra trong quá trình lấy dữ liệu',
            desc: 'Hãy thử lại sau',
            padding: const EdgeInsets.all(10),
            btnCancelOnPress: () {},
          ).show();
        }
      },
      builder: (context, state) {
        if (state is TopicLoading) {
          return const LoadingIndicator();
        } else if (state is TopicsLoaded) {
          if (state.topics.isEmpty) {
            return const Center(
              child: Text('Chưa tạo thư mục nào'),
            );
          }
          return ListView.builder(
            itemCount: state.topics.length,
            itemBuilder: (context, index) {
              final topic = state.topics[index];
              return ListTile(
                title: Text(topic.topicName),
                subtitle: Text(topic.topicDesc ?? 'No description'),
                onTap: () {},
              );
            },
          );
        } else {
          return const Center(child: Text('No data'));
        }
      },
    );
  }
}
