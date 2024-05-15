import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/flash_card_widget.dart';

class FlashCardPage extends StatefulWidget {
  final List<WordModel> words;
  const FlashCardPage({super.key, required this.words});

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  int _currentWordIndex = 0;
  int _currentStudying = 0;
  int _currentLearned = 0;
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text(
        '${_currentWordIndex + 1} / ${widget.words.length}',
        style: const TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: _showFlashCardSettings,
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }

  _buildBody() {
    var percentage = _currentWordIndex / widget.words.length;

    return SingleChildScrollView(
      child: Column(
        children: [
          LinearProgressIndicator(
            value: percentage,
            semanticsLabel: 'Your learning progress',
            semanticsValue: 'You learned ${percentage * 100}%',
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Text(
                  '$_currentStudying',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 100,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                child: Text(
                  '$_currentLearned',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FlashCard(word: widget.words[_currentWordIndex]),
          const SizedBox(height: 20),
          buildToolButtons(),
        ],
      ),
    );
  }

  buildToolButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            onPressed: () => setState(() => _isPlaying = !_isPlaying),
            icon: _isPlaying
                ? const Icon(Icons.pause)
                : const Icon(Icons.play_arrow),
          ),
        ],
      ),
    );
  }

  _showFlashCardSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        children: [
          const Text(
            'Tùy chọn',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          _buildToolIcons(),
        ],
      ),
    );
  }

  _buildToolIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIconWithTextBelow('Trộn thẻ', const Icon(Icons.shuffle)),
        const SizedBox(width: 100),
        _buildIconWithTextBelow(
            'Phát bản thu', const Icon(Icons.volume_up_outlined)),
      ],
    );
  }

  _buildIconWithTextBelow(String text, Icon icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1),
          ),
          child: IconButton(
            onPressed: () {},
            icon: icon,
            iconSize: 30,
          ),
        ),
        const SizedBox(height: 10),
        Text(text),
      ],
    );
  }
}
