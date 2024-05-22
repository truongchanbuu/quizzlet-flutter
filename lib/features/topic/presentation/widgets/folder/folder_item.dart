import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/folder.dart';

class FolderItem extends StatelessWidget {
  final FolderModel folder;
  final VoidCallback onTap;
  final Color? borderColor;

  const FolderItem({
    super.key,
    this.borderColor,
    required this.folder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Material(
        elevation: 3,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: borderColor ?? Colors.transparent,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.folder_outlined),
                  Text(
                    folder.folderName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            contentPadding: const EdgeInsets.all(20),
            subtitle: Row(
              children: [
                Text(
                  folder.creator ?? 'Unknown',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
