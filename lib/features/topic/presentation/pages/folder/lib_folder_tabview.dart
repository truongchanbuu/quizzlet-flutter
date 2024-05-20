import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/folder.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/folder/remote/folder_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/folder/folder_detail_page.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class LibFolderTabView extends StatefulWidget {
  const LibFolderTabView({super.key});

  @override
  State<LibFolderTabView> createState() => _LibFolderTabViewState();
}

class _LibFolderTabViewState extends State<LibFolderTabView> {
  final currentUser = sl.get<FirebaseAuth>().currentUser!;
  late List<FolderModel> _folders;

  @override
  void initState() {
    super.initState();
    context.read<FolderBloc>().add(GetFoldersByEmail(currentUser.email!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FolderBloc, FolderState>(
      builder: (context, state) {
        if (state is FolderLoaded) {
          _folders = state.folders;

          if (_folders.isEmpty) {
            return const Center(
              child: Text(
                'Hiện tại chưa có thư mục nào',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            itemBuilder: _createItem,
            itemCount: _folders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        }

        return const LoadingIndicator();
      },
      listener: (context, state) {
        if (state is FolderLoadFailed) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            headerAnimationLoop: false,
            title: 'Tải dữ liệu thất bại',
            desc: 'Hãy thử lại sau',
            btnCancelOnPress: () {},
          ).show();
        }
      },
    );
  }

  Widget _createItem(BuildContext ctx, int index) {
    return InkWell(
      onTap: () => _navigatorFolderDetailPage(_folders[index]),
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

  _navigatorFolderDetailPage(FolderModel folder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => sl.get<FolderBloc>(),
          child: FolderDetailPage(
            folder: folder,
          ),
        ),
      ),
    );
  }
}
