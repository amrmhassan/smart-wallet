//? this screen is for holding the other main screen that will be controller by the bottom nav bar

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

//! how to make my own icons using adobe xd then change the icon of menu to be one dash and a half

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/providers/quick_actions_provider.dart';
import 'package:wallet_app/screens/home_screen/home_screen.dart';
import 'package:wallet_app/screens/transactions_screen/transactions_screen.dart';

import '../../widgets/app_bar/my_app_bar.dart';
import '../../widgets/bottom_nav_bar/bottom_nav_bar.dart';
import '../providers/transactions_provider.dart';
import '../widgets/global/add_quick_action_button.dart';
import 'home_screen/widgets/background.dart';

const Duration _pageSliderDuration = Duration(milliseconds: 200);

class HolderScreen extends StatefulWidget {
  static const String routeName = '/holder-screen';
  const HolderScreen({Key? key}) : super(key: key);

  @override
  State<HolderScreen> createState() => _HolderScreenState();
}

class _HolderScreenState extends State<HolderScreen> {
  //* these for controlling the current active tab on the bottom nav bar
  int _activeBottomNavBarIndex = 2;
  bool _apply = true;
  late PageController _pageController;

  void _setActiveNavBarIconIndex(int index) {
    if (_apply) {
      _pageController.animateToPage(index,
          duration: _pageSliderDuration, curve: Curves.easeIn);
      setState(() {
        _activeBottomNavBarIndex = index;
        //* for changing the page when the current active index changes
      });
      //? this apply variable is to prevent another changing of the screens to happen before the animation finishes
      //? cause when i change the page with the bottom nav bar the page viewer itself recall the changing of the active tab before the animation changes and that make a conflict
      _apply = false;
      Future.delayed(_pageSliderDuration).then((_) {
        _apply = true;
      });
    }
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: _activeBottomNavBarIndex);
    //* i needed the trick of duration zero here
    //* here i will fetch and update the transactions
    Future.delayed(Duration.zero).then((value) async {
      //* i forgot to add the await
      await Provider.of<TransactionProvider>(context, listen: false)
          .fetchAndUpdateTransactions();

      await Provider.of<QuickActionsProvider>(context, listen: false)
          .fetchAndUpdateQuickActions();
    });
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

      drawer: Drawer(
        child: Container(
          color: Colors.white,
        ),
      ),
      //* this is the main stack that have all the content of home screen by showing every thing on each other as a stack
      body: Stack(
        children: [
          Background(),
          SafeArea(
            child: Column(
              children: [
                //* this is a custom widget of app bar
                //* not a real one but made of containers and paddings for more control
                MyAppBar(),
                //* here i showed that you can know which environment you are on (development or production)
                //* and i worked successfully
                // if (kDebugMode) Text('In debug Mode'),
                // if (kReleaseMode) Text('In release  Mode'),

                Expanded(
                  //* main pages of the app
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      return _setActiveNavBarIconIndex(index);
                    },
                    //! try this attribute now
                    allowImplicitScrolling: false,
                    controller: _pageController,

                    children: [
                      Container(
                        child: Text('Statistics page'),
                      ),
                      Container(
                        child: Text('Profiles  page'),
                      ),
                      HomeScreen(),
                      TransactionsScreen(),
                      Container(
                        child: Text('Settings  page'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //* this is the bottom nav bar that has all 5 main tabs
          BottomNavBar(
            activeIndex: _activeBottomNavBarIndex,
            setActiveBottomNavBarIcon: _setActiveNavBarIconIndex,
          ),
        ],
      ),
    );
  }
}
