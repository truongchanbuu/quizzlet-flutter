import 'package:flutter/material.dart';

class TopicSettingPage extends StatefulWidget {
  const TopicSettingPage({super.key});

  @override
  State<TopicSettingPage> createState() => _TopicSettingPageState();
}

class _TopicSettingPageState extends State<TopicSettingPage> {
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
        'Cài đặt tùy chọn',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPrivacySettings(),
          const SizedBox(height: 20),
          _buildDeleteButton(),
        ],
      ),
    );
  }

  _buildPrivacySettings() {
    return Material(
      elevation: 1,
      child: Container(
        color: Colors.grey.shade50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Quyền riêng tư'),
            ),
            ListTile(
              onTap: () {},
              contentPadding: const EdgeInsets.all(10),
              title: const Text('Ai có thể xem'),
              trailing: const Text(
                'Chỉ một mình tôi',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDeleteButton() {
    return Material(
      elevation: 1,
      child: Container(
        color: Colors.grey.shade50,
        child: ListTile(
          onTap: () {},
          title: const Text(
            'Xóa học phần',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
