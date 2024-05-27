import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/flashcard/flash_card_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PreviewFlashCardSection extends StatefulWidget {
  final TopicModel topic;
  const PreviewFlashCardSection({super.key, required this.topic});

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
        List.generate(widget.topic.words.length, (_) => FlipCardController());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: widget.topic.words.length,
          itemBuilder: (context, index, realIndex) => FlipCard(
            controller: _flipCardControllers[index],
            axis: FlipAxis.horizontal,
            onTapFlipping: true,
            rotateSide: RotateSide.bottom,
            animationDuration: const Duration(milliseconds: 500),
            frontWidget:
                _buildCard(index, widget.topic.words[index].terminology),
            backWidget: _buildCard(index, widget.topic.words[index].meaning),
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
          count: widget.topic.words.length,
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

  _buildCard(int index, String title) {
    return Card(
      elevation: 1,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => _flipCardControllers[index].flipcard(),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(color: Colors.black),
                semanticsLabel: title,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: IconButton(
              onPressed: navigateToFlashCardLearnPage,
              icon: const Icon(Icons.fullscreen),
            ),
          ),
        ],
      ),
    );
  }

  navigateToFlashCardLearnPage() {
    final currentRoute = ModalRoute.of(context);
    final currentRouteName = currentRoute?.settings.name ?? '';
    const newRouteName = '/flashcards/';
    final fullRouteName = '$currentRouteName$newRouteName';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashCardPage(
          topic: widget.topic,
        ),
        settings: RouteSettings(name: fullRouteName),
      ),
    );
  }
}
