import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/folder.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/folder/remote/folder_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/folder/create_folder_dialog.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/folder/folder_item.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class FoldersToAddPage extends StatefulWidget {
  final TopicModel topic;
  const FoldersToAddPage({super.key, required this.topic});

  @override
  State<FoldersToAddPage> createState() => _FoldersToAddPageState();
}

class _FoldersToAddPageState extends State<FoldersToAddPage> {
  final currentUser = sl.get<FirebaseAuth>().currentUser!;
  Set<String> selectedFolderIds = {};
  Set<String> initialFolderIds = {};
  bool isSelectedFolderIdsInitialized = false;

  @override
  void initState() {
    super.initState();
    context.read<FolderBloc>().add(GetFoldersByEmail(currentUser.email!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title:
          const Text('Thêm vào thư mục', style: TextStyle(color: Colors.black)),
      actions: [
        IconButton(
          onPressed: _onSave,
          icon: const Icon(Icons.check),
        )
      ],
    );
  }

  Widget _buildBody() {
    return BlocConsumer<FolderBloc, FolderState>(
      builder: (context, state) {
        if (state is FolderLoaded) {
          if (!isSelectedFolderIdsInitialized) {
            selectedFolderIds = _getFolderIdsBelongsToTopic(state.folders);
            initialFolderIds = Set.from(selectedFolderIds);
            isSelectedFolderIdsInitialized = true;
          }

          return _buildFolderListWithCreateButton(state.folders);
        } else if (state is FolderLoadFailed ||
            state is RemoveTopicsFailed ||
            state is AddTopicsFailed) {
          return _buildFolderListWithCreateButton([]);
        }

        return const LoadingIndicator();
      },
      listener: (context, state) {
        if (state is AddTopicsSuccess || state is RemoveTopicsSuccess) {
          context.read<FolderBloc>().add(GetFoldersByEmail(currentUser.email!));
        }
      },
    );
  }

  Widget _buildFolderListWithCreateButton(List<FolderModel> folders) {
    return ListView(
      children: [
        _buildCreateFolderButton(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildFolderList(folders),
        ),
      ],
    );
  }

  Widget _buildCreateFolderButton() {
    return GestureDetector(
      onTap: _createFolder,
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.indigo),
            SizedBox(width: 8),
            Text(
              'Tạo thư mục mới',
              style:
                  TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _createFolder() {
    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => sl.get<FolderBloc>(),
        child: const CreateFolderDialog(),
      ),
    );
  }

  Widget _buildFolderList(List<FolderModel> folders) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: folders.length,
      itemBuilder: (context, index) => _buildFolderItem(folders[index]),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }

  Widget _buildFolderItem(FolderModel folder) {
    bool isSelected = selectedFolderIds.contains(folder.folderId);

    return FolderItem(
      folder: folder,
      borderColor: isSelected ? Colors.orange : Colors.transparent,
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedFolderIds.remove(folder.folderId);
          } else {
            selectedFolderIds.add(folder.folderId);
          }
        });
      },
    );
  }

  Set<String> _getFolderIdsBelongsToTopic(List<FolderModel> folders) {
    var folderIds = <String>{};

    for (var folder in folders) {
      for (var topic in folder.topics) {
        if (topic.topicId == widget.topic.topicId) {
          folderIds.add(folder.folderId);
          break;
        }
      }
    }

    return folderIds;
  }

  void _onSave() {
    for (var id in selectedFolderIds) {
      if (!initialFolderIds.contains(id)) {
        context.read<FolderBloc>().add(
            AddTopicsToFolder(folderId: id, topicIds: [widget.topic.topicId]));
      }
    }

    for (var id in initialFolderIds) {
      if (!selectedFolderIds.contains(id)) {
        context
            .read<FolderBloc>()
            .add(RemoveTopicsFromFolder(id, [widget.topic.topicId]));
      }
    }

    initialFolderIds = Set.from(selectedFolderIds);
  }
}
