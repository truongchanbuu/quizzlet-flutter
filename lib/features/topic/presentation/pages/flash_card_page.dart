import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/flash_card_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
  int _currentFrontFaceSelected = 0;
  int _currentLearningContentSelected = 0;

  bool _isPlaying = false;
  bool _isShuffled = false;
  bool _isAllPronouncing = false;

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
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Tùy chọn',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildToolIcons(),
              const SizedBox(height: 10),
              const Text(
                'Thiết lập thẻ nhớ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('Mặt trước'),
              const SizedBox(height: 10),
              _buildFlashCardFrontSelection(),
              const SizedBox(height: 10),
              const Text('Nội dung học'),
              const SizedBox(height: 10),
              _buildLearningContentSelection(),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(55),
                ),
                child: const Text(
                  'Đặt lại thẻ nhớ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildToolIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StatefulBuilder(
          builder: (context, setModalState) => _buildIconWithTextBelow(
            'Trộn thẻ',
            const Icon(Icons.shuffle),
            _isShuffled ? Colors.indigo : null,
            () =>
                setState(() => setModalState(() => _isShuffled = !_isShuffled)),
          ),
        ),
        const SizedBox(width: 100),
        StatefulBuilder(
          builder: (context, setModalState) => _buildIconWithTextBelow(
            'Phát bản thu',
            const Icon(Icons.volume_up_outlined),
            _isAllPronouncing ? Colors.indigo : null,
            () => setState(() =>
                setModalState(() => _isAllPronouncing = !_isAllPronouncing)),
          ),
        )
      ],
    );
  }

  _buildIconWithTextBelow(
      String text, Icon icon, Color? color, void Function()? onPressed) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1),
            color: Colors.transparent,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: icon,
            iconSize: 30,
            color: color,
          ),
        ),
        const SizedBox(height: 10),
        Text(text),
      ],
    );
  }

  _buildFlashCardFrontSelection() {
    return SizedBox(
      width: double.infinity,
      child: ToggleSwitch(
        onToggle: (index) =>
            setState(() => _currentFrontFaceSelected = index ?? 0),
        initialLabelIndex: _currentFrontFaceSelected,
        totalSwitches: 2,
        labels: const ['Thuật ngữ', 'Định nghĩa'],
        activeBgColor: const [Colors.indigo],
        inactiveBgColor: Colors.white,
        activeFgColor: Colors.white,
        inactiveFgColor: Colors.indigo,
        customWidths: const [double.infinity, double.infinity],
        customTextStyles: const [
          TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ],
        centerText: true,
        borderColor: const [Colors.indigo],
      ),
    );
  }

  _buildLearningContentSelection() {
    return SizedBox(
      width: double.infinity,
      child: ToggleSwitch(
        onToggle: (index) =>
            setState(() => _currentLearningContentSelected = index ?? 0),
        initialLabelIndex: _currentLearningContentSelected,
        totalSwitches: 2,
        labels: const ['Tất cả các thẻ', 'Chỉ các thẻ được gắn sao'],
        activeBgColor: const [Colors.indigo],
        inactiveBgColor: Colors.white,
        activeFgColor: Colors.white,
        inactiveFgColor: Colors.indigo,
        customWidths: const [double.infinity, double.infinity],
        customTextStyles: const [
          TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ],
        centerText: true,
        borderColor: const [Colors.indigo],
      ),
    );
  }
}
