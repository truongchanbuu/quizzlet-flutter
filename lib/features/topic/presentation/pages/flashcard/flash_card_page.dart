import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/flashcard/flash_card_widget.dart';
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
  bool _isFinished = false;

  num percentage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              _buildLearningStats(),
              const SizedBox(height: 20),
              _buildFlashCard(context),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildToolButtons(),
          ),
          Positioned(
            left: 0,
            child: _buildFlashCardDragTarget(
              MediaQuery.of(context).size.height,
              20,
            ),
          ),
          Positioned(
            right: 0,
            child: _buildFlashCardDragTarget(
              MediaQuery.of(context).size.height,
              20,
            ),
          ),
        ],
      ),
    );
  }

  _buildProgressIndicator() {
    percentage = _currentWordIndex / widget.words.length;
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
            color: _isStudyingDrag
                ? Colors.orangeAccent
                : Colors.orangeAccent.withOpacity(0.2),
            border: Border.all(width: 1, color: Colors.orangeAccent),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Text(
            _isStudyingDrag ? '+1' : '${_currentStudying.length}',
            style: TextStyle(
              color: _isStudyingDrag ? Colors.white : Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: 100,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: _isLearnedDrag
                ? Colors.greenAccent
                : Colors.greenAccent.withOpacity(0.2),
            border: Border.all(width: 1, color: Colors.greenAccent),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Text(
            _isLearnedDrag ? '+1' : '${_currentLearned.length}',
            style: TextStyle(
              color: _isLearnedDrag ? Colors.white : Colors.green,
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
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: _buildProgressIndicator(),
      ),
    );
  }

  _buildToolButtons() {
    const textStyle = TextStyle(color: Colors.black, fontSize: 11);

    return Container(
      margin: const EdgeInsets.all(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _currentWordIndex == 0 ? null : () {},
            icon: const Icon(Icons.undo),
          ),
          Visibility(
              visible: _isMessageVisible,
              child: Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow),
                    const SizedBox(width: 10),
                    _isPlaying
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
                  ],
                ),
              )),
          IconButton(
            onPressed: () {
              setState(() => _isPlaying = !_isPlaying);
              _showAutoPlayText();
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
                  shape: const BeveledRectangleBorder(),
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

  _buildFlashCardDragTarget(double height, double width) {
    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: height,
          width: width,
          color: Colors.transparent,
        );
      },
      onWillAcceptWithDetails: (details) {
        return details.data is WordModel;
      },
      onAcceptWithDetails: (details) {
        _changeFlashCard(details.data as WordModel);
      },
      onLeave: (data) {},
    );
  }

  _buildFlashCard(BuildContext context) {
    return Draggable(
      data: widget.words[_currentWordIndex],
      onDragUpdate: _dragProcess,
      onDragEnd: _dragEnd,
      feedback: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: FlashCard(
          word: widget.words[_currentWordIndex],
        ),
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
      child: FlashCard(
        word: widget.words[_currentWordIndex],
      ),
    );
  }

  // Handle data
  _showAutoPlayText() {
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

  _dragProcess(DragUpdateDetails details) {
    var dx = details.delta.dx;

    if (dx > 0) {
      setState(() {
        _isLearnedDrag = true;
        _isStudyingDrag = false;
      });
    } else if (dx < 0) {
      setState(() {
        _isStudyingDrag = true;
        _isLearnedDrag = false;
      });
    } else {
      setState(() {
        _isLearnedDrag = false;
        _isStudyingDrag = false;
      });
    }
  }

  _dragEnd(DraggableDetails details) {
    setState(() {
      _isStudyingDrag = false;
      _isLearnedDrag = false;
    });

    var dx = details.velocity.pixelsPerSecond.dx;

    // if (dx > 0) {
    //   _changeFlashCard(widget.words[_currentWordIndex]);
    // } else if (dx < 0) {
    //   _changeFlashCard(widget.words[_currentWordIndex]);
    // }
  }

  _changeFlashCard(WordModel word) {
    int nextIndex = _currentWordIndex + 1;
    if (nextIndex < widget.words.length) {
      setState(() {
        _currentWordIndex++;
        if (_isStudyingDrag) {
          _currentStudying.add(word);
        } else if (_isLearnedDrag) {
          _currentLearned.add(word);
        }
      });
    } else {
      setState(() => _isFinished = true);
    }
  }
}
