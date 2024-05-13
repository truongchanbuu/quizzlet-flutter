import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PreviewFlashCardSection extends StatefulWidget {
  final List<WordModel> words;
  const PreviewFlashCardSection({super.key, required this.words});

  @override
  State<PreviewFlashCardSection> createState() =>
      _PreviewFlashCardSectionState();
}

class _PreviewFlashCardSectionState extends State<PreviewFlashCardSection> {
  int _currentIndex = 0;

  late final CarouselController _carouselController;
  late final List<FlipCardController> _flipCardControllers;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
    _flipCardControllers =
        List.generate(widget.words.length, (_) => FlipCardController());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: widget.words.length,
          itemBuilder: (context, index, realIndex) => FlipCard(
            controller: _flipCardControllers[index],
            axis: FlipAxis.horizontal,
            onTapFlipping: true,
            rotateSide: RotateSide.bottom,
            frontWidget: Material(
              elevation: 2,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: InkWell(
                onTap: () {
                  _flipCardControllers[index].flipcard();
                },
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Stack(
                  children: [
                    ListTile(
                      title: Center(
                        child: Text(
                          widget.words[index].terminology,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.fullscreen),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            backWidget: Material(
              elevation: 2,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: InkWell(
                onTap: () {
                  _flipCardControllers[index].flipcard();
                },
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Stack(
                  children: [
                    ListTile(
                      title: Center(
                        child: Text(
                          widget.words[index].meaning,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.fullscreen),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          options: CarouselOptions(
            onPageChanged: (index, reason) =>
                setState(() => _currentIndex = index),
            initialPage: 0,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            height: MediaQuery.of(context).size.height * 2 / 7,
            autoPlay: false,
            enableInfiniteScroll: false,
          ),
        ),
        const SizedBox(height: 15),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: widget.words.length,
          onDotClicked: (index) {
            setState(() => _currentIndex = index);
            _carouselController.animateToPage(index);
          },
          effect: const ScrollingDotsEffect(),
          curve: Curves.ease,
        ),
      ],
    );
  }
}
