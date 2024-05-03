import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailInfoPage extends StatelessWidget {
  final User user;
  const DetailInfoPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
    );
  }

  // Build UI methods
  _buildAppBar() {
    return AppBar(
      title: const Text(
        'Cài đặt',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text('Thông tin cá nhân'),
          ListTile(
            title: const Text('Tên người dùng'),
            subtitle: Text(user.displayName ?? 'User'),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text('Tên người dùng'),
            subtitle: Text(user.displayName ?? 'User'),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text('Tên người dùng'),
            subtitle: Text(user.displayName ?? 'User'),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
