import 'package:flutter/material.dart';

class TopicSettingPage extends StatefulWidget {
  final bool isPublic;
  const TopicSettingPage({super.key, this.isPublic = false});

  @override
  State<TopicSettingPage> createState() => _TopicSettingPageState();
}

class _TopicSettingPageState extends State<TopicSettingPage> {
  late bool isPublic;

  @override
  void initState() {
    super.initState();
    isPublic = widget.isPublic;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: const Text(
        'Cài đặt tùy chọn',
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context, isPublic);
        },
        icon: const Icon(Icons.close),
      ),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quyền riêng tư',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            _buildPrivacySettings(),
            const SizedBox(height: 20),
            _buildDeleteButton(),
          ],
        ),
      ),
    );
  }

  _buildPrivacySettings() {
    return Material(
      elevation: 2,
      child: Container(
        color: Colors.grey.shade50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: _showPrivacySelection,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              title: const Text('Ai có thể xem'),
              trailing: Text(
                isPublic ? 'Mọi người' : 'Chỉ một mình tôi',
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDeleteButton() {
    return TextButton(
      onPressed: _confirmDeletion,
      style: TextButton.styleFrom(
        minimumSize: const Size.fromHeight(55),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.grey,
      ),
      child: const Text(
        'Xóa học phần',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  _showPrivacySelection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Ai có thể xem chủ đề này',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  setState(() => setDialogState(() => isPublic = true));
                  Navigator.pop(context);
                },
                title: const Text('Mọi người'),
                trailing: isPublic ? const Icon(Icons.check) : null,
              ),
              ListTile(
                onTap: () {
                  setState(() => setDialogState(() => isPublic = false));
                  Navigator.pop(context);
                },
                title: const Text('Chỉ mình tôi'),
                trailing: !isPublic ? const Icon(Icons.check) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _confirmDeletion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Bạn có chắc muốn xóa học phần này',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: const Text(
            'Học phần này sẽ bị xóa hoàn toàn và không thể khôi phục lại được.'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Delete')),
        ],
      ),
    );
  }
}
