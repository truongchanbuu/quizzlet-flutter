import 'package:flutter/material.dart';

class CreateFolderDialog extends StatefulWidget {
  const CreateFolderDialog({super.key});

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  late final GlobalKey<FormState> _formKey;

  String? folderName;
  String? folderDesc;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _handleFolderCreation() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Create folder
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tạo thư mục'),
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
          },
          child: const Text('HỦY'),
        ),
        TextButton(
          onPressed: _handleFolderCreation,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
