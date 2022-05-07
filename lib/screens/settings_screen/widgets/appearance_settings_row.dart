// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/settings_screen/widgets/setting_element.dart';

class AppearanceSettingsRow extends StatelessWidget {
  final VoidCallback changeTheme;
  const AppearanceSettingsRow({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      children: [
        Expanded(
          child: SettingElement(
            onTap: changeTheme,
            iconPath: 'assets/icons/themes.png',
            title: 'Themes',
            value:
                themeProvider.currentTheme == Themes.basic ? 'Basic' : 'Dark',
          ),
        ),
        SizedBox(width: kDefaultPadding / 2),
        Expanded(
          child: SettingElement(
            onTap: () {},
            iconPath: 'assets/icons/vision.png',
            title: 'Look',
            value: 'Default',
          ),
        ),
      ],
    );
  }
}
