import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/folder.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/folder/remote/folder_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/topic/remote/topic_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/topic_item.dart';

class AddTopicFolderPage extends StatefulWidget {
  final FolderModel folder;
  const AddTopicFolderPage({super.key, required this.folder});

  @override
  State<AddTopicFolderPage> createState() => _AddTopicFolderPageState();
}

class _AddTopicFolderPageState extends State<AddTopicFolderPage>
    with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;
  late Set<String> selectedTopicIds;

  final List<Tab> _tabs = [
    const Tab(
      text: 'ĐÃ TẠO',
    ),
    const Tab(
      text: 'ĐÃ HỌC',
    ),
  ];

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    selectedTopicIds =
        widget.folder.topics.map((topic) => topic.topicId).toSet();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    context.read<TopicBloc>().add(GetTopicsByUser(widget.folder.creator!));
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
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
      actions: [
        IconButton(onPressed: _addTopicsToFolder, icon: const Icon(Icons.check))
      ],
      bottom: _buildTabBar(),
    );
  }

  _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildCreatedTopicsTab(),
        const Center(
            child: Text(
          'Chức năng hiện đang trong quá trình phát triển',
          style: TextStyle(color: Colors.grey, fontSize: 20),
        )),
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
        if (state is TopicLoading || state is AllTopicsLoaded) {
          return const LoadingIndicator();
        } else if (state is TopicsLoaded) {
          if (state.topics.isEmpty) {
            return _buildNoItemUI();
          }

          return ListView.builder(
            itemCount: state.topics.length,
            itemBuilder: (context, index) {
              final topic = state.topics[index];
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: _buildTopicItem(topic),
              );
            },
          );
        }

        return _buildNoItemUI();
      },
    );
  }

  _buildNoItemUI() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_copy,
            color: Colors.grey,
            size: 60,
          ),
          Text(
            'Chưa tạo thư mục nào',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  _buildTopicItem(TopicModel topic) {
    bool isSelected = selectedTopicIds.contains(topic.topicId);
    return TopicItem(
      topic: topic,
      borderColor: isSelected ? Colors.orange : Colors.transparent,
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedTopicIds.remove(topic.topicId);
          } else {
            selectedTopicIds.add(topic.topicId);
          }
        });
      },
    );
  }

  // Handle data
  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          context
              .read<TopicBloc>()
              .add(GetTopicsByUser(widget.folder.creator!));
          break;
      }
    }
  }

  _addTopicsToFolder() {
    context.read<FolderBloc>().add(AddTopicsToFolder(
        folderId: widget.folder.folderId, topicIds: selectedTopicIds.toList()));
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
