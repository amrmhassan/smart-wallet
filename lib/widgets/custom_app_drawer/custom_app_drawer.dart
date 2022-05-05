// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/colors.dart';
import 'package:smart_wallet/constants/db_constants.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/helpers/db_helper.dart';
import 'package:smart_wallet/helpers/shared_pref_helper.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/about_app/about_app.dart';
import 'package:smart_wallet/screens/holder_screen/holder_screen.dart';
import 'package:smart_wallet/screens/loading_data_screen.dart';
import 'package:smart_wallet/screens/quick_actions_screen/quick_actions_screen.dart';
import 'package:smart_wallet/utils/general_utils.dart';

import 'widgets/drawer_list_item.dart';
import 'widgets/drawer_logo.dart';
import 'widgets/drawer_separator_line.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({
    Key? key,
  }) : super(key: key);

  Future<void> deleteDatabaseAndRestart(BuildContext context) async {
    {
      await DBHelper.deleteDatabase(dbName);
      await SharedPrefHelper.removeAllSavedKeys();
      // Navigator.pushReplacementNamed(context, LoadingDataScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      child: Container(
        color: themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
        child: Column(
          children: [
            DrawerLogo(),
            DrawerSeparatorLine(),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  DrawerlistItem(
                    title: 'Home',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(HolderScreen.routeName);
                    },
                    iconData: Icons.home,
                  ),
                  DrawerlistItem(
                    title: 'Quick Actions',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushNamed(QuickActionsScreen.routeName);
                    },
                    iconData: FontAwesomeIcons.bolt,
                    color: kModerateProfileStatusColor,
                  ),
                  DrawerlistItem(
                    title: 'Debts',
                    onTap: () {
                      showSnackBar(context, 'Coming soon', SnackBarType.info);
                      Navigator.of(context).pop();
                    },
                    iconData: Icons.money_off,
                    color: kModerateProfileStatusColor,
                  ),

                  //* only show this option if the app is in debug mode
                  if (kDebugMode)
                    DrawerlistItem(
                      title: 'Delete Database',
                      onTap: () async => deleteDatabaseAndRestart(context),
                      iconData: Icons.delete,
                      color: themeProvider
                          .getThemeColor(ThemeColors.kOutcomeColor),
                    ),
                  if (kDebugMode)
                    DrawerlistItem(
                      title: 'Restart App',
                      onTap: () async {
                        Navigator.pushReplacementNamed(
                            context, LoadingDataScreen.routeName);
                      },
                      iconData: FontAwesomeIcons.bolt,
                      color: kModerateProfileStatusColor,
                    ),
                  DrawerlistItem(
                    title: 'About App',
                    onTap: () async {
                      Navigator.pushNamed(context, AboutApp.routeName);
                    },
                    iconData: FontAwesomeIcons.info,
                    color: kModerateProfileStatusColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
