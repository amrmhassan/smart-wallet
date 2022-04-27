//? this screen is for holding the other main screen that will be controller by the bottom nav bar

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/durations.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
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
        duration: _pageSliderDuration, curve: Curves.easeInOut);
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
    var themeProvider = Provider.of<ThemeProvider>(context);

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
                ContinueButton(
                  active: _activePage == pages.length - 1,
                ),
              ],
            ),
          ),
          if (showLoggingBanner) OpenLoggingScreen(),
        ],
      ),
    );
  }
}

class PagesTracker extends StatelessWidget {
  final int count;
  final int activeIndex;
  const PagesTracker({
    Key? key,
    required this.activeIndex,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          count,
          (index) => Dot(
                active: index == activeIndex,
              )),
    );
  }
}

class Dot extends StatelessWidget {
  final bool active;
  const Dot({
    Key? key,
    required this.active,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedContainer(
      duration: kAnimationsDuration,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: active
            ? themeProvider.getThemeColor(ThemeColors.kMainColor)
            : themeProvider
                .getThemeColor(ThemeColors.kMainColor)
                .withOpacity(.2),
        borderRadius: BorderRadius.circular(1000),
      ),
      width: 5,
      height: 5,
    );
  }
}

class ContinueButton extends StatelessWidget {
  final bool active;
  const ContinueButton({
    Key? key,
    required this.active,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      height: 100,
      child: AnimatedContainer(
        duration: kAnimationsDuration,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: active
              ? themeProvider.getThemeColor(
                  ThemeColors.kActiveButtonColor,
                )
              : themeProvider
                  .getThemeColor(ThemeColors.kActiveButtonColor)
                  .withOpacity(.2),
          borderRadius: BorderRadius.circular(
            kDefaultBorderRadius,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: !active
                ? null
                : () {
                    Navigator.pushReplacementNamed(
                        context, HolderScreen.routeName);
                  },
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'Continue',
                style: active
                    ? themeProvider.getTextStyle(
                        ThemeTextStyles.kParagraphTextStyle,
                      )
                    : themeProvider.getTextStyle(
                        ThemeTextStyles.kInActiveParagraphTextStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Page4 extends StatelessWidget {
  const Page4({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Back Up Your Data!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'All your data is securely saved to the cloud.',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: kDefaultPadding * 3,
          ),
          Image.asset('assets/images/intro_page/cloud-data.png'),
        ],
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Follow Your Spendings!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'With Live Stats.',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: kDefaultPadding * 3,
          ),
          Image.asset('assets/images/intro_page/stats.png'),
        ],
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/intro_page/running.png'),
          SizedBox(
            height: kDefaultPadding * 3,
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'You can use A Quick Action',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'For repeatedly used Transactions.\nJust a quick action to apply it.',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Keep Track Of Your Expenses!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Stop wasting your money everywhere.',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: kDefaultPadding * 3,
          ),
          Image.asset('assets/images/intro_page/money.png'),
        ],
      ),
    );
  }
}
