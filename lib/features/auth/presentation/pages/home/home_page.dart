import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
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
  late final List<Widget> pages = [
    const Padding(
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreakDaySection(streakDays: 2),
          ],
        ),
      ),
    ),
    const Text('Loi giai'),
    const Text('Thu vien'),
    const InfoPage(),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
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
      automaticallyImplyLeading: false,
    );
  }

  _buildBody() {
    return PageView(
      controller: pageController,
      onPageChanged: (page) => setState(() => _currentPageIndex = page),
      children: pages,
    );
  }

  _buildBottomNavigation() {
    return AnimatedBottomNavigationBar.builder(
      backgroundColor: Colors.white,
      activeIndex: _currentPageIndex,
      onTap: (int pageIndex) {
        setState(() => _currentPageIndex = pageIndex);
        pageController.jumpToPage(
          pageIndex,
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
      onPressed: _showBottomSheeetForCreation,
      backgroundColor: Colors.white,
      shape: const CircleBorder(side: BorderSide.none),
      child: const Icon(
        Icons.add,
        color: Colors.indigo,
      ),
    );
  }

  _showBottomSheeetForCreation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: const ListTile(
                        title: Text('Topic'),
                        leading: Icon(Icons.filter_none),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: const ListTile(
                        title: Text('Thư mục'),
                        leading: Icon(Icons.folder),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: const ListTile(
                        title: Text('Lớp'),
                        leading: Icon(Icons.switch_account),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
