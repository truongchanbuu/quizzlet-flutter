import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class FlashCard extends StatefulWidget {
  final WordModel word;
  final Stream? notifyToFlipCard;
  final Color borderColor;

  FlashCard({
    super.key,
    required this.word,
    this.notifyToFlipCard,
    this.borderColor = Colors.transparent,
  });

  final _FlashCardState state = _FlashCardState();

  @override
  State<FlashCard> createState() => state;

  late bool? isFront = state._flipCardController.state?.isFront;
}

class _FlashCardState extends State<FlashCard> {
  late final StreamSubscription? streamSubscription;

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

  late final FlipCardController _flipCardController;

  bool _isPronouncing = false;

  @override
  void initState() {
    super.initState();
    initTTS();
    _flipCardController = FlipCardController();
    streamSubscription = widget.notifyToFlipCard?.listen((_) async {
      _flipCardController.flipcard();
    });
  }

  final textStyle = const TextStyle(
    fontSize: 20,
  );

  final double elevation = 5;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: widget.borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      elevation: elevation,
      child: FlipCard(
        frontWidget: _buildCard(widget.word.terminology),
        backWidget: _buildCard(widget.word.meaning),
        controller: _flipCardController,
        rotateSide: RotateSide.left,
        axis: FlipAxis.vertical,
        animationDuration: const Duration(milliseconds: 500),
        onTapFlipping: true,
      ),
    );
  }

  _buildCard(String title) {
    return GestureDetector(
      onTap: () => _flipCardController.flipcard(),
      onLongPress: () => _showCardDialog(title),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 100,
        height: MediaQuery.of(context).size.height - 200,
        child: Stack(
          children: [
            Center(
              child: Text(
                title,
                style: textStyle,
                semanticsLabel: title,
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isPronouncing ? Colors.grey.withOpacity(0.3) : null,
                ),
                child: IconButton(
                  onPressed: () => _speakText(title),
                  icon: const Icon(Icons.volume_up_outlined),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showCardDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(title),
        semanticLabel: title,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: const BeveledRectangleBorder(),
              padding: const EdgeInsets.all(20.0),
            ),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  _speakText(String title) async {
    setState(() => _isPronouncing = !_isPronouncing);
    if (_isPronouncing) {
      await flutterTTS.speak(title);
      flutterTTS.setCompletionHandler(() {
        setState(() => _isPronouncing = !_isPronouncing);
      });
    }
  }
}
