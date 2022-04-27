//? this screen is for holding the other main screen that will be controller by the bottom nav bar

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/screens/holder_screen/holder_screen.dart';
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
  int _activeBottomNavBarIndex = 2;
  late PageController _pageController;

  void _setActiveNavBarIconIndex(int index) {
    _pageController.animateToPage(index,
        duration: _pageSliderDuration, curve: Curves.easeInOut);
    setState(() {
      _activeBottomNavBarIndex = index;
      //* for changing the page when the current active index changes
    });
  }

  @override
  void initState() {
    _pageController = PageController(
      initialPage: _activeBottomNavBarIndex,
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
            backgroundPath: _activeBottomNavBarIndex == 4
                ? 'assets/images/backgroundLight.jpg'
                : null,
          ),
          SafeArea(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, HolderScreen.routeName);
                },
                child: Text('Proceed')),
          ),
          if (showLoggingBanner) OpenLoggingScreen(),
        ],
      ),
    );
  }
}
