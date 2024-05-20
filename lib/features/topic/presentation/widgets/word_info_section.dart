import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quizzlet_fluttter/core/util/image_util.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';

class WordInfoSection extends StatefulWidget {
  final int index;
  final Function() onDelete;
  final WordModel word;

  WordInfoSection({
    super.key,
    required this.word,
    required this.onDelete,
    required this.index,
  });

  final _WordInfoSectionState state = _WordInfoSectionState();

  @override
  State<WordInfoSection> createState() => state;

  bool isValidated() => state.validate();
}

class _WordInfoSectionState extends State<WordInfoSection> {
  final formKey = GlobalKey<FormState>();

  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => widget.onDelete(),
            icon: Icons.delete,
            backgroundColor: Colors.red,
          )
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                validator: (term) {
                  if (term?.isEmpty ?? true) {
                    return 'HÃY NHẬP THUẬT NGỮ';
                  }

                  return null;
                },
                onSaved: (term) => widget.word.terminology = term!,
                decoration: InputDecoration(
                    hintText: 'Thuật ngữ',
                    border: const UnderlineInputBorder(),
                    focusColor: Colors.indigo,
                    suffixIcon: IconButton(
                        onPressed: _pickImage, icon: const Icon(Icons.image))),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 5),
              const Text(
                'THUẬT NGỮ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (meaning) {
                  if (meaning?.isEmpty ?? true) {
                    return 'HÃY NHẬP ĐỊNH NGHĨA';
                  }

                  return null;
                },
                onSaved: (meaning) => widget.word.meaning = meaning!,
                decoration: const InputDecoration(
                  hintText: 'Định nghĩa',
                  border: UnderlineInputBorder(),
                  focusColor: Colors.indigo,
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 5),
              const Text(
                'ĐỊNH NGHĨA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                onSaved: (desc) => widget.word.wordDesc = desc,
                decoration: const InputDecoration(
                  hintText: 'Mô tả',
                  border: UnderlineInputBorder(),
                  focusColor: Colors.indigo,
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 5),
              const Text(
                'MÔ TẢ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              if (widget.word.illustratorUrl != null)
                const SizedBox(height: 20),
              if (widget.word.illustratorUrl != null)
                Text(widget.word.illustratorUrl!),
              if (widget.word.illustratorUrl != null && !kIsWeb)
                Image.file(
                  File(widget.word.illustratorUrl!),
                  width: 100,
                  height: 100,
                ),
              if (widget.word.illustratorUrl != null && kIsWeb)
                Image.network(
                  widget.word.illustratorUrl!,
                  width: 100,
                  height: 100,
                ),
              // ImageField(
              //   multipleUpload: false,
              //   cardinality: 1,
              //   onSave: (List<ImageAndCaptionModel?>? imageAndCaptionList) {
              //     widget.file = imageAndCaptionList![0]!.file;
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Handle Data
  bool validate() {
    bool validate = formKey.currentState?.validate() ?? false;
    if (validate) formKey.currentState?.save();

    return validate;
  }

  _pickImage() async {
    String? imagePath = await pickImage();
    setState(() {
      widget.word.illustratorUrl = imagePath;
    });
  }
}
