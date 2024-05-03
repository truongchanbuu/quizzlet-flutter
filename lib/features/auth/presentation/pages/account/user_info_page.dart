import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/account/detail_info_page.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/streak_section.dart';

class InfoPage extends StatelessWidget {
  final User user;
  const InfoPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  // Build UI methods
  _buildAppBar() {
    return AppBar();
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: user.photoURL != null
                    ? NetworkImage(user.photoURL!)
                    : Image.asset('/images/user.jpg').image,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user.displayName ?? 'User',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                onTap: () {},
                contentPadding: const EdgeInsets.all(10),
                tileColor: Colors.white,
                title: const Text('Thêm khóa học'),
                leading: const Icon(Icons.book),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                onTap: () => _navigateToDetailInfo(context),
                contentPadding: const EdgeInsets.all(10),
                tileColor: Colors.white,
                title: const Text('Cài đặt của bạn'),
                leading: const Icon(Icons.settings),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            const StreakDaySection(streakDays: 2),
          ],
        ),
      ),
    );
  }

  // Navigation
  _navigateToDetailInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailInfoPage(user: user),
          settings: const RouteSettings(name: 'account/detail-page')),
    );
  }
}
