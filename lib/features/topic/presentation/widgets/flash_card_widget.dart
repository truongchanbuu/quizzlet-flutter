import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';

class FlashCard extends StatefulWidget {
  final WordModel word;
  const FlashCard({super.key, required this.word});

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
    fontSize: 40,
  );

  final double elevation = 3;

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      frontWidget: _buildCard(widget.word.terminology),
      backWidget: _buildCard(widget.word.meaning),
      controller: _flipCardController,
      rotateSide: RotateSide.right,
      axis: FlipAxis.vertical,
      animationDuration: const Duration(milliseconds: 500),
      onTapFlipping: true,
    );
  }

  _buildCard(String title) {
    return GestureDetector(
      onTap: () => _flipCardController.flipcard(),
      onHorizontalDragStart: (details) {},
      onVerticalDragStart: (details) {},
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 100,
        height: MediaQuery.of(context).size.height - 250,
        child: Stack(
          children: [
            Card(
              elevation: elevation,
              child: Center(
                child: Text(
                  title,
                  style: textStyle,
                  semanticsLabel: title,
                ),
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
}
