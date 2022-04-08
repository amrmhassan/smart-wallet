// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/colors.dart';
import 'package:smart_wallet/constants/db_constants.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/helpers/db_helper.dart';
import 'package:smart_wallet/helpers/shared_pref_helper.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

import 'widgets/drawer_list_item.dart';
import 'widgets/drawer_logo.dart';
import 'widgets/drawer_separator_line.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      child: Container(
        color: themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
        child: Column(
          children: [
            SizedBox(
              height: kDefaultPadding,
            ),
            DrawerLogo(),
            DrawerSeparatorLine(),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  DrawerlistItem(
                    title: 'Home',
                    onTap: () {},
                    iconData: Icons.home,
                  ),
                  DrawerlistItem(
                    title: 'Debts',
                    onTap: () {},
                    iconData: Icons.money_off,
                    color: kModerateProfileStatusColor,
                  ),
                  DrawerlistItem(
                    title: 'Quick Actions',
                    onTap: () {},
                    iconData: FontAwesomeIcons.bolt,
                    color: kModerateProfileStatusColor,
                  ),
                  //* only show this option if the app is in debug mode
                  if (kDebugMode)
                    DrawerlistItem(
                      title: 'Delete Database',
                      onTap: () async {
                        await DBHelper.deleteDatabase(dbName);
                        await SharedPrefHelper.removeAllSavedKeys();
                        Phoenix.rebirth(context);
                      },
                      iconData: Icons.delete,
                      color: kOutcomeColor,
                    ),
                  if (kDebugMode)
                    DrawerlistItem(
                      title: 'Restart App',
                      onTap: () async {
                        Phoenix.rebirth(context);
                      },
                      iconData: FontAwesomeIcons.bolt,
                      color: kOutcomeColor,
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
