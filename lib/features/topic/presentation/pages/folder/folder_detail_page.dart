import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/folder.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/folder/remote/folder_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/topic/remote/topic_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/folder/add_topic_to_folder_page.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/topic/topic_detail_page.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/create_folder_dialog.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/topic_item.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

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
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  _buildAppBar(BuildContext ctx) {
    return AppBar(
      title: const Text(
        'Thư mục',
        style: TextStyle(color: Colors.black),
      ),
      elevation: 1,
      actions: [
        IconButton(
            onPressed: () => _showBottomSheetSelection(ctx),
            icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  _showBottomSheetSelection(BuildContext ctx) {
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
                onTap: _addTopicToFolder,
                title: const Text('Thêm chủ đề'),
                leading: const Icon(Icons.add),
              ),
              ListTile(
                onTap: () => _deleteFolder(ctx),
                title: const Text(
                  'Xóa',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildBody() {
    return BlocConsumer<FolderBloc, FolderState>(
      listener: (context, state) {
        if (state is DeleteFolderFailed) {
          AwesomeDialog(
            context: context,
            padding: const EdgeInsets.all(10),
            title: 'Xóa không thành công',
            headerAnimationLoop: false,
            dialogType: DialogType.error,
            btnCancelOnPress: () {},
          ).show();
        } else if (state is DeleteFolderSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      },
      builder: (context, state) {
        if (state is DeletingFolder) {
          return const LoadingIndicator();
        }

        return ListView(
          children: [
            _buildInfoSection(),
            const SizedBox(height: 20),
            _buildTopics(),
          ],
        );
      },
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
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Material(
          elevation: 2,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                const Text(
                  'Thư mục này hiện chưa có chủ đề nào',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _addTopicToFolder,
                  style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    backgroundColor: Colors.indigo,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Thêm chủ đề',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) =>
          _createTopicItem(widget.folder.topics[index]),
      itemCount: widget.folder.topics.length,
    );
  }

  _createTopicItem(topic) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TopicItem(
          topic: topic,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => sl.get<TopicBloc>(),
                  child: TopicDetailPage(topic: topic),
                ),
                settings: RouteSettings(
                  name: '/topic/detail/${topic.topicId}',
                ),
              ),
            );
          }),
    );
  }

  _editTopic() {
    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => sl.get<FolderBloc>(),
        child: CreateFolderDialog(
          folder: widget.folder,
        ),
      ),
    );
  }

  _deleteFolder(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        title: const Text(
          'Bạn có chắc muốn xóa thư mục này vĩnh vễn? Các học phần sẽ không bị ảnh hưởng',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(ctx);
              },
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ctx.read<FolderBloc>().add(DeleteFolder(widget.folder.folderId));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  _addTopicToFolder() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl.get<TopicBloc>(),
            ),
            BlocProvider(
              create: (context) => sl.get<FolderBloc>(),
            ),
          ],
          child: AddTopicFolderPage(
            folder: widget.folder,
          ),
        ),
      ),
    );
  }
}
