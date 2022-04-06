// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/colors.dart';
import 'package:smart_wallet/constants/db_constants.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/helpers/db_helper.dart';
import 'package:smart_wallet/helpers/shared_pref_helper.dart';
import 'package:smart_wallet/utils/general_utils.dart';

import 'widgets/drawer_list_item.dart';
import 'widgets/drawer_logo.dart';
import 'widgets/drawer_separator_line.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: kDefaultPadding,
          ),
          DrawerLogo(),
          DrawerSeparatorLine(),
          Expanded(
            child: ListView(
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
                  title: 'Delete Database',
                  onTap: () async {
                    await DBHelper.deleteDatabase(dbName);
                    await SharedPrefHelper.removeAllSavedKeys();
                    showSnackBar(
                        context, 'Database deleted', SnackBarType.success);
                  },
                  iconData: Icons.delete,
                  color: kOutcomeColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
