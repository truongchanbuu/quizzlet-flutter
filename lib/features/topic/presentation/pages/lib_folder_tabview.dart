import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/folder.dart';

class LibFolderTabView extends StatefulWidget {
  const LibFolderTabView({super.key});

  @override
  State<LibFolderTabView> createState() => _LibFolderTabViewState();
}

class _LibFolderTabViewState extends State<LibFolderTabView> {
  late final List<FolderModel> _folders;

  @override
  void initState() {
    super.initState();
    _folders = [
      const FolderModel(
          folderId: '001', folderName: 'Folder 1', topics: [], creator: null),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: _createItem,
      itemCount: _folders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }

  Widget _createItem(BuildContext context, int index) {
    return InkWell(
      onTap: () {},
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Material(
        elevation: 1,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.5),
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
                      _folders[index].folderName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            contentPadding: const EdgeInsets.all(20),
            subtitle: Row(
              children: [
                const CircleAvatar(
                  radius: 15,
                ),
                const SizedBox(width: 10),
                Text(
                  _folders[index].creator ?? 'Unknown',
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
