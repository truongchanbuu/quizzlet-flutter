import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';

class FlashCard extends StatefulWidget {
  final WordModel word;
  final Color borderColor;
  const FlashCard({
    super.key,
    required this.word,
    this.borderColor = Colors.transparent,
  });

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  bool _isPronouncing = false;
  late final FlipCardController _flipCardController;

  @override
  void initState() {
    super.initState();
    _flipCardController = FlipCardController();
  }

  @override
  void dispose() {
    super.dispose();
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
        height: MediaQuery.of(context).size.height - 250,
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
                  onPressed: () =>
                      setState(() => _isPronouncing = !_isPronouncing),
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
}
