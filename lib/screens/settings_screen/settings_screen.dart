// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/settings_screen/widgets/setting_element.dart';
import '../../constants/sizes.dart';
import '../../widgets/app_bar/home_heading.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void changeTheme() {
    //? this will toggle the theme from dark to basic and vice versa
    Themes theme =
        Provider.of<ThemeProvider>(context, listen: false).currentTheme;
    if (theme == Themes.basic) {
      Provider.of<ThemeProvider>(context, listen: false).setTheme(Themes.dark);
    } else {
      Provider.of<ThemeProvider>(context, listen: false).setTheme(Themes.basic);
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Column(
            children: [
              HomeHeading(
                title: 'Settings',
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Expanded(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.all(kDefaultPadding / 2),
                  child: GridView(
                    clipBehavior: Clip.none,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: kDefaultPadding / 2,
                      mainAxisSpacing: kDefaultPadding / 2,
                      childAspectRatio: 1.4,
                    ),
                    children: [
                      //! type the theme name and preview it
                      SettingElement(
                        onTap: changeTheme,
                        iconPath: 'assets/icons/themes.png',
                        title: 'Themes',
                        value: themeProvider.currentTheme == Themes.basic
                            ? 'Basic'
                            : 'Dark',
                      ),
                      SettingElement(
                        onTap: () {},
                        iconPath: 'assets/icons/vision.png',
                        title: 'Look',
                        value: 'Default',
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
