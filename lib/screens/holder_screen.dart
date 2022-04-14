//? this screen is for holding the other main screen that will be controller by the bottom nav bar

// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/screens/loading_data_screen.dart';
import 'package:smart_wallet/screens/money_accounts_screen/money_accounts_screen.dart';
import 'package:smart_wallet/screens/settings_screen/settings_screen.dart';
import 'package:smart_wallet/widgets/global/main_loading.dart';
import '../providers/theme_provider.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/transactions_screen/transactions_screen.dart';

import '../../widgets/app_bar/my_app_bar.dart';
import '../../widgets/bottom_nav_bar/bottom_nav_bar.dart';
import '../utils/profile_utils.dart';
import '../widgets/custom_app_drawer/custom_app_drawer.dart';
import 'add_transaction_screen/add_transaction_screen.dart';
import 'home_screen/widgets/background.dart';
import 'statistics_screen/statistics_screen.dart';

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
  bool _loading = false;
  late PageController _pageController;
  final TextEditingController _profileNameController = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  void _setActiveNavBarIconIndex(int index) {
    if (_apply) {
      _pageController.animateToPage(index,
          duration: _pageSliderDuration, curve: Curves.easeInOut);
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
    _pageController = PageController(
      initialPage: _activeBottomNavBarIndex,
    );

    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        _loading = true;
      });
      //? 1]  fetching the active theme
      await Provider.of<ThemeProvider>(context, listen: false)
          .fetchAndSetActiveTheme();

      //? 2] fetching the profiles
      await Provider.of<ProfilesProvider>(context, listen: false)
          .fetchAndUpdateProfiles();

      //? 3] fetching the active profile id
      await Provider.of<ProfilesProvider>(context, listen: false)
          .fetchAndUpdateActivatedProfileId();

      // //? 4] fetching the transactions from the database
      await Provider.of<TransactionProvider>(context, listen: false)
          .fetchAllTransactionsFromDataBase();

      // //? 5] fetching the quick actions
      await Provider.of<QuickActionsProvider>(context, listen: false)
          .fetchAllQuickActionsFromDataBase();

      setState(() {
        _loading = false;
      });
    });

    super.initState();
  }

  void openTransactionScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const AddTransactionScreen(
          addTransactionScreenOperations:
              AddTransactionScreenOperations.addTransaction,
        ),
      ),
    );
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
      key: _key,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      drawer: const CustomAppDrawer(),
      //* this is the main stack that have all the content of home screen by showing every thing on each other as a stack
      body: _loading
          ? MainLoading()
          : Stack(
              children: [
                Background(
                  //? this is for changing the background image if the current screen is the settings screen
                  backgroundPath: _activeBottomNavBarIndex == 4
                      ? 'assets/images/backgroundLight.jpg'
                      : null,
                ),
                SafeArea(
                  child: Column(
                    children: [
                      //* this is a custom widget of app bar
                      //* not a real one but made of containers and paddings for more control
                      _activeBottomNavBarIndex == 1
                          ? MyAppBar(
                              rightIcon: AddElementButton(
                                onTap: () async => showAddProfileModal(
                                    context, _profileNameController),
                              ),
                            )
                          : _activeBottomNavBarIndex == 3
                              ? MyAppBar(
                                  rightIcon: AddElementButton(
                                    onTap: () => openTransactionScreen(context),
                                  ),
                                )
                              : MyAppBar(),
                      //* here i showed that you can know which environment you are on (development or production)
                      //* and i worked successfully
                      // if (kDebugMode) Text('In debug Mode'),
                      // if (kReleaseMode) Text('In release  Mode'),

                      Expanded(
                        //* main pages of the app
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            if (details.delta.dx > 0) {
                              //? this will be executed when ever the user swipes right
                              _key.currentState!.openDrawer();
                            } else {
                              //? this will be executed when ever the user swipes left

                            }
                          },
                          //! at the end remove this column , container, expanded and leave only the page viewer
                          child: Column(
                            children: [
                              if (false) TestingLengthsWidget(),
                              Expanded(
                                child: PageView(
                                  //* prevented the user from scrolling by himself(to enable transactions dimissible)
                                  // physics: const BouncingScrollPhysics(),
                                  physics: const NeverScrollableScrollPhysics(),
                                  onPageChanged: (index) {
                                    return _setActiveNavBarIconIndex(index);
                                  },
                                  //! try this attribute now
                                  allowImplicitScrolling: false,
                                  controller: _pageController,

                                  children: const [
                                    StatisticsScreen(),
                                    MoneyAccountsScreen(),
                                    HomeScreen(),
                                    TransactionsScreen(),
                                    SettingsScreen(),
                                  ],
                                ),
                              ),
                            ],
                          ),
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

class TestingLengthsWidget extends StatelessWidget {
  const TestingLengthsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
      ),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          TestingElement(
            title: 'All Profiles',
            value: Provider.of<ProfilesProvider>(context).profiles.length,
          ),
          TestingElement(
            title: 'Active id',
            value: Provider.of<ProfilesProvider>(context).activatedProfileId,
          ),
          ...Provider.of<ProfilesProvider>(context)
              .profiles
              .map((profile) => TestingElement(
                    title: profile.name,
                    value: profile.id,
                  ))
              .toList(),
          TestingElement(
            title: 'All Transactions',
            value:
                Provider.of<TransactionProvider>(context).transactions.length,
          ),
          TestingElement(
            title: 'All Quick Actions',
            value: Provider.of<QuickActionsProvider>(context)
                .allQuickActions
                .length,
          ),
        ],
      ),
    );
  }
}

class TestingElement extends StatelessWidget {
  final String title;
  final dynamic value;
  const TestingElement({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toString(),
        ),
        Text(
          value.toString(),
        ),
      ],
    );
  }
}

class AddElementButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddElementButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(1000)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(kDefaultPadding / 2),
            child: Icon(
              Icons.add,
              color: themeProvider.getThemeColor(
                ThemeColors.kMainColor,
              ),
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
