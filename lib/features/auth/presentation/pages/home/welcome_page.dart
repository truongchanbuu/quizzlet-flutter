import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:quizzlet_fluttter/core/constants/constants.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_state.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/home/home_page.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/common.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late UserRepository userRepository;

  // State
  int _activeIndex = 0;

  // Controller
  late CarouselController carouseController;

  // Storage
  late final FlutterSecureStorage storage;

  // Info
  String? token;

  @override
  void initState() {
    super.initState();
    userRepository = GetIt.instance.get<UserRepository>();
    carouseController = CarouselController();
    storage = const FlutterSecureStorage();
    getToken();
  }

  void getToken() async {
    token = await storage.read(key: 'token');
  }

  bool isAuthedByToken() {
    if (token != null) {
      try {
        var decodedToken = JwtDecoder.decode(token!);

        return decodedToken['email'] != null &&
            decodedToken['email'] ==
                GetIt.instance.get<FirebaseAuth>().currentUser!.email;
      } catch (e) {
        log('Decode error: ${e.toString()}');
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance.get<AuthenticationBloc>(),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (isAuthedByToken() ||
              state.status == AuthenticationStatus.authenticated) {
            return const HomePage();
          }

          return Scaffold(
            appBar: _buildAppBar(),
            body: _buildBody(),
          );
        },
      ),
    );
  }

  // Build UI methods
  _buildAppBar() {
    return AppBar(
      title: const Text(
        appName,
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

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildSlider(introductionItems),
            const SizedBox(height: 15),
            _buildIntroText(introductionItems[_activeIndex]['content']!),
            const SizedBox(height: 25),
            _buildIndicator(introductionItems.length),
            const SizedBox(height: 25),
            buildPolicyAlertText(),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _navigateToSignUpPage,
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
              onPressed: _navigateToSignInPage,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.grey.shade100,
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
      ),
    );
  }

  _buildSlider(List<Map<String, dynamic>> items) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: CarouselSlider(
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
          enableInfiniteScroll: true,
          autoPlay: true,
          viewportFraction: 1,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  _buildIndicator(count) {
    return AnimatedSmoothIndicator(
      activeIndex: _activeIndex,
      count: count,
      onDotClicked: (page) {
        setState(() => _activeIndex = page);
        carouseController.animateToPage(page);
      },
    );
  }

  _buildIntroText(String text) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var height = MediaQuery.of(context).size.height;

        if (constraints.minHeight <= 640) {
          height = height / 5;
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: height,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
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

  // Navigation methods
  _navigateToSignUpPage() {
    Navigator.of(context).pushNamed('/account/sign-up');
  }

  _navigateToSignInPage() {
    Navigator.of(context).pushNamed('/account/sign-in');
  }
}
