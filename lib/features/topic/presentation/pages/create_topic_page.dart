import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/word_info_section.dart';

class CreateTopicPage extends StatefulWidget {
  const CreateTopicPage({super.key});

  @override
  State<CreateTopicPage> createState() => _CreateTopicPageState();
}

class _CreateTopicPageState extends State<CreateTopicPage> {
  late final GlobalKey<FormState> _formKey;

  late final List<Widget> wordSections;

  String? topic;
  String? desc;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    wordSections = [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // Build UI methods
  _buildAppBar() {
    return AppBar(
      title: const Text(
        'Tạo học phần',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, 'topic/create/setting');
          },
          icon: const Icon(Icons.settings),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.check),
        ),
      ],
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                onSaved: (newValue) => topic = newValue,
                decoration: const InputDecoration(
                  hintText: 'Chủ đề',
                  border: UnderlineInputBorder(),
                  focusColor: Colors.indigo,
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 5),
              const Text(
                'CHỦ ĐỀ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => wordSections[index],
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: wordSections.length,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          wordSections.add(WordInfoSection(
            index: wordSections.length,
            onDelete: _deleteWordForm,
          ));
        });
      },
      shape: const CircleBorder(side: BorderSide.none),
      backgroundColor: Colors.indigo,
      tooltip: 'Thêm từ mới',
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  _deleteWordForm(int index) {
    setState(() {
      wordSections.removeAt(index);
    });
  }
}
