import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/folder.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/folder/remote/folder_bloc.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class CreateFolderDialog extends StatefulWidget {
  final FolderModel? folder;
  const CreateFolderDialog({super.key, this.folder});

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  late final GlobalKey<FormState> _formKey;
  final currentUser = sl.get<FirebaseAuth>().currentUser!;

  String? folderName;
  String? folderDesc;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();

    if (widget.folder != null) {
      folderName = widget.folder!.folderName;
      folderDesc = widget.folder!.folderDesc;
    }
  }

  _handleFolderCreation() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      String folderId = widget.folder?.folderId ?? generateFolderId();
      var folder = FolderModel(
        folderId: folderId,
        folderName: folderName!,
        folderDesc: folderDesc,
        topics: widget.folder?.topics ?? const [],
        creator: currentUser.email,
      );

      if (widget.folder != null) {
        context.read<FolderBloc>().add(EditFolder(folder));
      } else {
        context.read<FolderBloc>().add(CreateFolder(folder));
      }

      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FolderBloc, FolderState>(
      listener: (context, state) {
        if (state is CreateFolderFailed || state is UpdateFolderFailed) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            headerAnimationLoop: false,
            title: 'Tạo thất bại',
            desc: 'Hãy thử lại sau',
            padding: const EdgeInsets.all(10),
            btnCancelOnPress: () {},
          ).show();
        } else if (state is CreateFolderSuccess ||
            state is UpdateFolderSuccess) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is Creating || state is Updating) {
          return const LoadingIndicator();
        }

        return AlertDialog(
          title: widget.folder != null
              ? const Text('Sửa thư mục')
              : const Text('Tạo thư mục'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (name) {
                      if (name?.isEmpty ?? true) {
                        return 'HÃY NHẬP TÊN THƯ MỤC';
                      }

                      return null;
                    },
                    onSaved: (newValue) => folderName = newValue,
                    initialValue: folderName,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Tên thư mục',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (desc) {
                      return null;
                    },
                    onSaved: (newValue) => folderDesc = newValue,
                    initialValue: folderDesc,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Mô tả (tùy chọn)',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('HỦY'),
            ),
            TextButton(
              onPressed: _handleFolderCreation,
              child:
                  widget.folder != null ? const Text('Sửa') : const Text('Tạo'),
            ),
          ],
        );
      },
    );
  }

  String generateFolderId() {
    return '${folderName?.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}';
  }
}
