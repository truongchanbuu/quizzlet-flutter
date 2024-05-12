import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/lib_folder_tabview.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/lib_topic_tabview.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/create_folder_dialog.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  late final List<Widget> _tabs;
  late final List<Widget> _tabBarView;
  late final TabController _tabController;

  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabs = [
      const Tab(
        text: 'Chủ đề',
        // icon: Icon(Icons.filter_none),
      ),
      const Tab(
        text: 'Thư mục',
        // icon: Icon(Icons.folder_outlined),
      ),
      const Tab(
        text: 'Lớp',
        // icon: Icon(Icons.switch_account),
      ),
    ];
    _tabBarView = [
      const LibTopicTabView(),
      const LibFolderTabView(),
      Container(),
    ];
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // Build UI method
  _buildAppBar() {
    return AppBar(
      title: const Text(
        'Thư viện',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(onPressed: _addNewTopicOrFolder, icon: const Icon(Icons.add))
      ],
      bottom: _buildTabBar(),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TabBarView(
        controller: _tabController,
        children: _tabBarView,
      ),
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

  _addNewTopicOrFolder() {
    switch (_currentTabIndex) {
      case 0:
        _addNewTopic();
        break;
      case 1:
        _addNewFolder();
        break;
    }
  }

  _addNewTopic() {
    Navigator.pushNamed(context, '/topic/create');
  }

  _addNewFolder() {
    showDialog(
      context: context,
      builder: (context) => const CreateFolderDialog(),
    );
  }
}
