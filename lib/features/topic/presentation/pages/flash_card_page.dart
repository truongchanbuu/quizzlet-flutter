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
  var _currentStudying = [];
  var _currentLearned = [];
  int _currentFrontFaceSelected = 0;
  int _currentLearningContentSelected = 0;

  bool _isPlaying = false;
  bool _isShuffled = false;
  bool _isAllPronouncing = false;
  bool _isMessageVisible = false;
  bool _isStudyingDrag = false;
  bool _isLearnedDrag = false;

  num percentage = 0;

  @override
  void initState() {
    super.initState();
    percentage = (_currentWordIndex / widget.words.length).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: ListView(
        children: [
          _buildProgressIndicator(),
          const SizedBox(height: 10),
          _buildLearningStats(),
          const SizedBox(height: 30),
          _buildFlashCard(),
          const SizedBox(height: 25),
          buildToolButtons(),
        ],
      ),
    );
  }

  _buildProgressIndicator() {
    return LinearProgressIndicator(
      value: percentage.toDouble(),
      semanticsLabel: 'Your learning progress',
      semanticsValue: 'You learned ${percentage * 100}%',
    );
  }

  _buildLearningStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 100,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.orangeAccent.withOpacity(0.2),
            border: Border.all(width: 1, color: Colors.orangeAccent),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Text(
            '${_currentStudying.length}',
            style: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: 100,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.greenAccent.withOpacity(0.2),
            border: Border.all(width: 1, color: Colors.greenAccent),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Text(
            '${_currentLearned.length}',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
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

  buildToolButtons() {
    const textStyle = TextStyle(color: Colors.black, fontSize: 11);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: _currentWordIndex == 0 ? null : () {},
            icon: const Icon(Icons.undo),
          ),
          Visibility(
            visible: _isMessageVisible,
            child: Expanded(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _isMessageVisible ? 1.0 : 0.0,
                child: ListTile(
                  leading: const Icon(Icons.play_arrow),
                  title: _isPlaying
                      ? const Text(
                          'Tự động cuộn thẻ đang được BẬT',
                          style: textStyle,
                          textAlign: TextAlign.center,
                        )
                      : const Text(
                          'Tự động cuộn thẻ đang được TẮT',
                          style: textStyle,
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() => _isPlaying = !_isPlaying);
              _showText();
            },
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

  _buildFlashCard() {
    return Draggable(
      data: widget.words[_currentWordIndex],
      onDragUpdate: _dragProcess,
      feedback: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: FlashCard(word: widget.words[_currentWordIndex]),
      ),
      childWhenDragging: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: MediaQuery.of(context).size.height - 250,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: const Card(
          elevation: 3,
          child: Center(
            child: Text(
              '',
              semanticsLabel: '',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: FlashCard(word: widget.words[_currentWordIndex]),
      ),
    );
  }

  // Handle data
  _showText() {
    setState(() {
      _isMessageVisible = true;
    });
    Future.delayed(
      const Duration(seconds: 2),
      () {
        setState(() {
          _isMessageVisible = false;
        });
      },
    );
  }

  _dragProcess(DragUpdateDetails details) {}

  _dragCanceled() {}

  _dragSuccess() {}
}
