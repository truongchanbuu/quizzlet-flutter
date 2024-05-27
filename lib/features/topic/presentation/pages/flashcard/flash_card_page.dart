import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:quizzlet_fluttter/features/result/presentation/pages/conclusion_page.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/widgets/flashcard/flash_card_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class FlashCardPage extends StatefulWidget {
  final TopicModel topic;
  final List<WordModel>? words;
  const FlashCardPage({super.key, required this.topic, this.words});

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  final StreamController changeNotifier = StreamController.broadcast();
  final GlobalKey<FlipCardState> _flipCardKey = GlobalKey();

  final flutterTTS = sl.get<FlutterTts>();
  void initTTS() {
    flutterTTS.getVoices.then((data) {
      try {
        List<Map> voices = List.from(data);
        voices = voices.where((voice) => voice['name'].contains('en')).toList();
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  int _currentWordIndex = 0;
  final List<WordModel> _currentStudying = List.empty(growable: true);
  final List<WordModel> _currentLearned = List.empty(growable: true);
  int _currentFrontFaceSelected = 0;
  int _currentLearningContentSelected = 0;

  bool _isPlaying = false;
  bool _isShuffled = false;
  bool _isAllPronouncing = false;
  bool _isMessageVisible = false;

  bool _isStudyingDrag = false;
  bool _isLearnedDrag = false;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  @override
  void dispose() {
    changeNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var words = widget.words ?? widget.topic.words;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(words),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildLearningStats(),
          const SizedBox(height: 10),
          Expanded(
            child: _buildFlashCard(words[_currentWordIndex]),
          ),
          const SizedBox(height: 10),
          _buildToolButtons(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  _buildProgressIndicator(words) {
    var percentage = (_currentWordIndex + 1) / words.length;
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

  _buildAppBar(words) {
    return AppBar(
      title: Text(
        '${_currentWordIndex + 1} / ${words.length}',
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
        child: _buildProgressIndicator(words),
      ),
    );
  }

  _buildToolButtons() {
    const textStyle = TextStyle(color: Colors.black, fontSize: 11);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _currentWordIndex == 0 ? null : _undoCard,
            icon: const Icon(Icons.undo),
          ),
          Visibility(
              visible: _isMessageVisible,
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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

              if (_isPlaying) {
                _playAllFlashCard();
              }
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

  _buildDragTarget(word) {
    return DragTarget(
      builder: (context, candidateData, rejectedData) => SizedBox(
        height: MediaQuery.of(context).size.height,
      ),
      onWillAcceptWithDetails: (details) => details.data is WordModel,
      onAcceptWithDetails: (details) {
        if (_isStudyingDrag) {
          _currentStudying.add(word);
        } else {
          _currentLearned.add(word);
        }
        _changeFlashCard();
      },
      onMove: (details) {
        var dx = details.offset.dx;
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
      },
    );
  }

  _buildFlashCard(WordModel word) {
    return Row(
      children: [
        Expanded(flex: 1, child: _buildDragTarget(word)),
        Expanded(
          flex: 5,
          child: Draggable(
            data: word,
            onDragEnd: _dragEnd,
            feedback: FlashCard(word: word),
            childWhenDragging: Card(
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              elevation: 3,
              child: GestureDetector(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  height: MediaQuery.of(context).size.height - 200,
                  child: const Center(
                    child: Text(
                      '',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            child: FlashCard(
              key: _flipCardKey,
              word: word,
              notifyToFlipCard: changeNotifier.stream,
            ),
          ),
        ),
        Expanded(flex: 1, child: _buildDragTarget(word)),
      ],
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

  _dragEnd(DraggableDetails details) {
    setState(() {
      _isStudyingDrag = false;
      _isLearnedDrag = false;
    });
  }

  _changeFlashCard() {
    var words = widget.words ?? widget.topic.words;

    if (_currentWordIndex < words.length - 1) {
      setState(() {
        _currentWordIndex++;
      });
    } else {
      setState(() {
        _isPlaying = false;
        _isFinished = true;
      });
    }

    if (_isFinished) {
      _navigateConclusionPage();
    }
  }

  _navigateConclusionPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConclusionPage(
          studyingWords: _currentStudying,
          learnedWords: _currentLearned,
          topic: widget.topic,
        ),
      ),
    );
  }

  _undoCard() {
    var words = widget.words ?? widget.topic.words;

    setState(() {
      _currentWordIndex--;
      _currentLearned.removeWhere(
          (word) => word.wordId == words[_currentWordIndex].wordId);
      _currentStudying.removeWhere(
          (word) => word.wordId == words[_currentWordIndex].wordId);
    });
  }

  Future<void> _speak(String text) async {
    await flutterTTS.speak(text);
  }

  Future<void> _playAllFlashCard() async {
    var words = widget.words ?? widget.topic.words;

    while (_currentWordIndex < words.length && _isPlaying) {
      var currentWord = words[_currentWordIndex];

      String firstText = _flipCardKey.currentState?.isFront ?? true
          ? currentWord.terminology
          : currentWord.meaning;

      String secondText = firstText == currentWord.terminology
          ? currentWord.meaning
          : currentWord.terminology;

      await _speak(firstText);
      await flutterTTS.awaitSpeakCompletion(true);
      await Future.delayed(const Duration(seconds: 1));

      if (_isPlaying) {
        changeNotifier.sink.add(null);
        await Future.delayed(const Duration(seconds: 1));
        await _speak(secondText);
        await flutterTTS.awaitSpeakCompletion(true);
        await Future.delayed(const Duration(seconds: 1));

        setState(() {
          _currentLearned.add(currentWord);
          _changeFlashCard();
        });
      }
    }
  }
}
