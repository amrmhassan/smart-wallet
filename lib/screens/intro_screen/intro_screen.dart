//? this screen is for holding the other main screen that will be controller by the bottom nav bar

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/screens/holder_screen/holder_screen.dart';
import 'package:smart_wallet/screens/intro_screen/widgets/intro_pages.dart';
import 'package:smart_wallet/screens/intro_screen/widgets/pages_tracker.dart';
import 'package:smart_wallet/screens/money_accounts_screen/widgets/custom_button.dart';
import 'package:smart_wallet/widgets/global/open_logging_screen.dart';

import '../home_screen/widgets/background.dart';

const Duration _pageSliderDuration = Duration(milliseconds: 200);

class IntroScreen extends StatefulWidget {
  static const String routeName = '/intro-screen';
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  //* these for controlling the current active tab on the bottom nav bar
  int _activePage = 0;
  late PageController _pageController;

  final List<Widget> pages = [
    Page1(),
    Page2(),
    Page3(),
    Page4(),
  ];

  void _setActiveNavBarIconIndex(int index) {
    _pageController.animateToPage(index,
        duration: _pageSliderDuration, curve: Curves.linear);
    setState(() {
      _activePage = index;
      //* for changing the page when the current active index changes
    });
  }

  @override
  void initState() {
    _pageController = PageController(
      initialPage: _activePage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

//* this is the build method of this widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      //* this is the main stack that have all the content of home screen by showing every thing on each other as a stack
      body: Stack(
        children: [
          Background(
            //? this is for changing the background image if the current screen is the settings screen
            backgroundPath: 'assets/images/backgroundLight.jpg',
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    //* prevented the user from scrolling by himself(to enable transactions dimissible)
                    physics: const BouncingScrollPhysics(),
                    // physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      return _setActiveNavBarIconIndex(index);
                    },
                    //! try this attribute now
                    allowImplicitScrolling: false,
                    controller: _pageController,

                    children: pages,
                  ),
                ),
                PagesTracker(
                  count: pages.length,
                  activeIndex: _activePage,
                ),
                // ContinueButton(
                //   active: _activePage == pages.length - 1,
                // ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: kDefaultVerticalPadding,
                  ),
                  height: 100,
                  child: CustomButton(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, HolderScreen.routeName);
                    },
                    title: 'Continue',
                    active: _activePage == pages.length - 1,
                    borderRadius: kDefaultBorderRadius,
                  ),
                )
              ],
            ),
          ),
          if (showLoggingBanner) OpenLoggingScreen(),
        ],
      ),
    );
  }
}
