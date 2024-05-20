import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/folder.dart';

class FolderDetailPage extends StatefulWidget {
  final FolderModel folder;
  const FolderDetailPage({super.key, required this.folder});

  @override
  State<FolderDetailPage> createState() => _FolderDetailPageState();
}

class _FolderDetailPageState extends State<FolderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: const Text(
        'Thư mục',
        style: TextStyle(color: Colors.black),
      ),
      elevation: 1,
      actions: [
        IconButton(
            onPressed: _showBottomSheetSelection,
            icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  _showBottomSheetSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ListTile(
                onTap: _editTopic,
                title: const Text('Sửa'),
                leading: const Icon(Icons.edit),
              ),
              ListTile(
                onTap: () {},
                title: const Text('Thêm học phần'),
                leading: const Icon(Icons.add),
              ),
              ListTile(
                onTap: () {},
                title: const Text('Xóa'),
                leading: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildBody() {
    return ListView(
      children: [
        _buildInfoSection(),
        const SizedBox(height: 20),
        _buildTopics(),
      ],
    );
  }

  _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${widget.folder.topics.length} học phần',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const VerticalDivider(
                thickness: 1,
                color: Colors.black,
              ),
              Text(
                widget.folder.creator ?? 'Unknown',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.folder.folderName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }

  _buildTopics() {
    if (widget.folder.topics.isEmpty) {
      return Card(
        margin: const EdgeInsets.all(20),
        elevation: 1,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                'Thư mục này hiện chưa có chủ đề nào',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                  backgroundColor: Colors.indigo,
                ),
                child: const Text(
                  'Thêm chủ đề',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Container(),
      itemCount: widget.folder.topics.length,
    );
  }

  _createTopicItem(topic) {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 1,
      color: Colors.white,
      child: Text(''),
    );
  }

  _editTopic() {}
}
