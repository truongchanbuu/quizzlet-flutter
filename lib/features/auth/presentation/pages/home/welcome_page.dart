import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_state.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/home/homepage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatefulWidget {
  final UserRepository userRepository;
  const WelcomePage({super.key, required this.userRepository});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _activeIndex = 0;
  late CarouselController carouseController;

  @override
  void initState() {
    super.initState();
    carouseController = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // Build UI methods
  _buildAppBar() {
    return AppBar(
      title: const Text(
        'Quizzlet',
        style: TextStyle(
          color: Colors.indigo,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
            size: 25,
            color: Colors.indigo,
          ),
        ),
      ],
    );
  }

  _buildBody() {
    final introductionItems = [
      {
        'image': 'assets/images/introduction/introduction_img_1.png',
        'content':
            'Hơn 90% học sinh sử dụng Quizzlet cho biết họ đã cải thiện được điểm số.',
      },
      {
        'image': 'assets/images/introduction/introduction_img_2.png',
        'content': 'Tìm kiếm hàng triệu bộ thẻ ghi nhớ.',
      },
      {
        'image': 'assets/images/introduction/introduction_img_3.png',
        'content': 'Học bằng bốn cách khác nhau.',
      },
      {
        'image': 'assets/images/introduction/introduction_img_4.png',
        'content': 'Tùy chỉnh thẻ ghi nhớ theo nhu cầu của bạn.',
      },
    ];

    return BlocProvider(
      create: (context) => GetIt.instance.get<AuthenticationBloc>(),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return const HomePage();
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildSlider(introductionItems),
                const SizedBox(height: 15),
                // Cần cách nhau ra thật xa
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Bằng việc đăng ký, tôi chấp thuận ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'Điều khoản dịch vụ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' và ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'Chính sách quyền riêng tư',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' của Quizzlet',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Đăng ký miễn phí',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Hoặc đăng nhập',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildSlider(List<Map<String, dynamic>> items) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          CarouselSlider(
            carouselController: carouseController,
            items: items
                .map(
                  (item) => Image.asset(
                    item['image']!,
                    semanticLabel: item['content'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildErrorImageWidget(error.toString()),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              onPageChanged: (index, reason) =>
                  setState(() => _activeIndex = index),
              initialPage: 0,
              enableInfiniteScroll: false,
              autoPlay: false,
              viewportFraction: 1,
              scrollDirection: Axis.horizontal,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            items[_activeIndex]['content'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          AnimatedSmoothIndicator(
            activeIndex: _activeIndex,
            count: items.length,
            onDotClicked: (index) => carouseController.animateToPage(index),
          ),
        ],
      ),
    );
  }

  _buildErrorImageWidget(String errorMessage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.error),
        const SizedBox(height: 10),
        Text(errorMessage),
      ],
    );
  }
}
