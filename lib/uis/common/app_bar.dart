import 'package:flutter/material.dart';

class QuizzletAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? centerTitle;
  const QuizzletAppBar({super.key, required this.title, this.centerTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      centerTitle: centerTitle ?? true,
      backgroundColor: Colors.indigo,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
