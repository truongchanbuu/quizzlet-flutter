import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:quizzlet_fluttter/core/constants/constants.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/account/user_info_page.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/search_box.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/streak_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user;

  // Controllers
  late final PageController pageController;

  // State
  int _currentPageIndex = 0;

  // Bottom Navigation Items
  final bottomNavItems = [
    {
      'icon': Icons.search,
      'name': 'Trang chủ',
    },
    {
      'icon': Icons.book,
      'name': 'Lời giải',
    },
    {
      'icon': Icons.folder,
      'name': 'Thư viện',
    },
    {
      'icon': Icons.contacts,
      'name': 'Hồ sơ',
    },
  ];

  // Pages
  late final pages = [
    const SingleChildScrollView(
      child: Column(
        children: [
          StreakDaySection(streakDays: 2),
        ],
      ),
    ),
    const Text('Loi giai'),
    const Text('Thu vien'),
    InfoPage(
      user: user,
    ),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    user = GetIt.instance.get<FirebaseAuth>().currentUser!;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentPageIndex == 0 ? _buildAppBar(context) : null,
      backgroundColor: Colors.grey.shade200,
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // Build UI method
  _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigo,
      iconTheme: const IconThemeData(color: Colors.white),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(90),
        bottomLeft: Radius.circular(90),
      )),
      bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height / 6),
          child: const SizedBox(
            child: Padding(
              padding: EdgeInsets.only(left: 50, right: 50, bottom: 40),
              child: SearchBox(),
            ),
          )),
      title: const Text(
        appName,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none,
            size: 30,
          ),
        )
      ],
    );
  }

  _buildBody() {
    return PageView(
      controller: pageController,
      children: pages,
      onPageChanged: (page) => setState(() => _currentPageIndex = page),
    );
  }

  _buildBottomNavigation() {
    return AnimatedBottomNavigationBar.builder(
      backgroundColor: Colors.white,
      activeIndex: _currentPageIndex,
      onTap: (int pageIndex) {
        setState(() => _currentPageIndex = pageIndex);
        pageController.animateToPage(
          pageIndex,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      },
      notchSmoothness: NotchSmoothness.smoothEdge,
      gapLocation: GapLocation.center,
      height: 70,
      itemCount: bottomNavItems.length,
      tabBuilder: (int index, bool isActive) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            bottomNavItems[index]['icon'] as IconData,
            color: isActive ? Colors.indigo : Colors.grey,
          ),
          Text(bottomNavItems[index]['name'].toString()),
        ],
      ),
    );
  }

  _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.white,
      shape: const CircleBorder(side: BorderSide.none),
      child: const Icon(
        Icons.add,
        color: Colors.indigo,
      ),
    );
  }
}
