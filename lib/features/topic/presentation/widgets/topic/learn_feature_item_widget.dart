import 'package:flutter/material.dart';

class LearnFeatureItem extends StatelessWidget {
  final Function() onTap;
  final String title;
  final Icon leading;
  const LearnFeatureItem({
    super.key,
    required this.onTap,
    required this.title,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: ListTile(
          title: Text(title),
          leading: leading,
          contentPadding: const EdgeInsets.all(10),
          horizontalTitleGap: 22,
        ),
      ),
    );
  }
}
