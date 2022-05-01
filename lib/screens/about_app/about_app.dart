// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/app_details.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/providers/update_app_provider.dart';
import 'package:smart_wallet/screens/home_screen/widgets/background.dart';
import 'package:smart_wallet/screens/money_accounts_screen/widgets/custom_button.dart';
import 'package:smart_wallet/utils/general_utils.dart';
import 'package:smart_wallet/utils/update_app_utils.dart';
import 'package:smart_wallet/widgets/app_bar/my_app_bar.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';
import 'package:smart_wallet/widgets/global/line.dart';
import 'package:smart_wallet/widgets/global/main_loading.dart';

class AboutApp extends StatefulWidget {
  static const String routeName = '/route-name';
  const AboutApp({Key? key}) : super(key: key);

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  bool _loading = false;
  String latestVersion = '';
  bool needUpdate = false;
  bool online = false;

  Future<void> _handleUpdate(BuildContext context) async {
    await updateAndInstall(context);
  }

  Future<void> fetchLatestVersion() async {
    setState(() {
      _loading = true;
    });
    bool o = await isOnline();

    String? v = await getLatestVersion();
    if (v != null) {
      setState(() {
        latestVersion = v;
      });
    }
    if (currentAppVersion != v) {
      setState(() {
        needUpdate = true;
      });
    }
    setState(() {
      online = o;
      _loading = false;
    });
  }

  @override
  void initState() {
    fetchLatestVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var themeProvider = Provider.of<ThemeProvider>(context);
    var updateAppProvider = Provider.of<UpdateAppProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      //? this will prevent the screen to resize whenever keyboard is opened
      resizeToAvoidBottomInset: false,

      //* this is the drawer
      drawer: Drawer(
        child: Container(
          color: Colors.white,
        ),
      ),
      //? this gesture detector will remove the focus whenever anything else is clicked in the screen
      body: _loading
          ? MainLoading()
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Stack(
                children: [
                  //* this is the background of the screen
                  const Background(),

                  SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding / 2),
                      child: Column(
                        children: [
                          //* my custom app bar and the mainAppBar is equal to false for adding the back button and remove the menu icon(side bar opener)
                          MyAppBar(
                            title: 'About App',
                          ),
                          //* space between the app bar and the next widget
                          const SizedBox(
                            height: 40,
                          ),
                          //* the main container of the adding new transaction cart which will have the main padding around the edges of the screen
                          CustomCard(
                            padding: const EdgeInsets.all(kDefaultPadding),
                            //* the row which will have the main sides of the cart
                            child: Column(
                              children: [
                                InfoElement(
                                  title: 'Current Version',
                                  value: currentAppVersion,
                                ),
                                if (online)
                                  Column(
                                    children: [
                                      SizedBox(height: kDefaultPadding / 4),
                                      Line(
                                        lineType: LineType.horizontal,
                                        thickness: 1,
                                      ),
                                      SizedBox(height: kDefaultPadding / 4),
                                      InfoElement(
                                          title: 'Latest Version',
                                          value: latestVersion),
                                    ],
                                  ),
                                if (needUpdate && online)
                                  Column(
                                    children: [
                                      SizedBox(height: kDefaultPadding / 4),
                                      Line(
                                        lineType: LineType.horizontal,
                                        thickness: 1,
                                      ),
                                      SizedBox(height: kDefaultPadding),
                                      CustomButton(
                                        onTap: () async {
                                          await _handleUpdate(context);
                                        },
                                        title: updateAppProvider.downloading
                                            ? 'Downloading'
                                            : 'Update',
                                        active: !updateAppProvider.downloading,
                                      ),
                                      SizedBox(
                                        height: kDefaultPadding / 2,
                                      ),
                                      if (updateAppProvider.downloading)
                                        ProgressBar(
                                          progress: updateAppProvider
                                              .downloadProgress,
                                        ),
                                    ],
                                  ),
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
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double progress;
  const ProgressBar({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      clipBehavior: Clip.hardEdge,
      height: 5,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: themeProvider
            .getThemeColor(ThemeColors.kSavingsColor)
            .withOpacity(.1),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: themeProvider.getThemeColor(ThemeColors.kSavingsColor),
            borderRadius: BorderRadius.circular(
              1000,
            ),
          ),
        ),
      ),
    );
  }
}

class InfoElement extends StatelessWidget {
  final String title;
  final String value;

  const InfoElement({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: themeProvider
              .getTextStyle(ThemeTextStyles.kSmallTextPrimaryColorStyle),
        ),
        Text(
          value,
          style: themeProvider
              .getTextStyle(ThemeTextStyles.kSmallTextPrimaryColorStyle),
        ),
      ],
    );
  }
}
