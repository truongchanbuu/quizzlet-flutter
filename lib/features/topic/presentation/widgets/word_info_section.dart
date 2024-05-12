import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class WordInfoSection extends StatefulWidget {
  final int index;
  final Function(int) onDelete;
  const WordInfoSection(
      {super.key, required this.onDelete, required this.index});

  @override
  State<WordInfoSection> createState() => _WordInfoSectionState();
}

class _WordInfoSectionState extends State<WordInfoSection> {
  late final GlobalKey<FormState> _formKey;

  String? terminology;
  String? meaning;
  String? desc;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => widget.onDelete(widget.index),
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
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                onSaved: (newValue) => terminology = newValue,
                decoration: InputDecoration(
                  hintText: 'Thuật ngữ',
                  border: const UnderlineInputBorder(),
                  focusColor: Colors.indigo,
                  suffixIcon: IconButton(
                    onPressed: _pickVocabIllustrator,
                    icon: const Icon(Icons.image),
                    tooltip:
                        'Chọn hình minh họa (Chỉ duy nhất một hình minh họa)',
                  ),
                ),
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
                onSaved: (newValue) => meaning = newValue,
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
                onSaved: (newValue) => desc = newValue,
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
            ],
          ),
        ),
      ),
    );
  }

  // Handle Data
  _pickVocabIllustrator() {}
}
