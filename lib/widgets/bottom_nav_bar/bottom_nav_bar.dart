import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/widgets/global/bottom_nav_bar_icon_colored.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../providers/theme_provider.dart';
import '../global/bottom_nav_bar_icon.dart';

class BottomNavBar extends StatelessWidget {
  final int activeIndex;
  final Function(int index) setActiveBottomNavBarIcon;
  const BottomNavBar({
    Key? key,
    required this.activeIndex,
    required this.setActiveBottomNavBarIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    List<Map<String, dynamic>> bottomNavBarIcons = [
      {
        'iconData': FontAwesomeIcons.chartLine,
        'onTap': () {},
        'iconImage': 'assets/icons/bot_nav/trend.png'
      },
      {
        'iconData': FontAwesomeIcons.users,
        'onTap': () {},
        'iconImage': 'assets/icons/bot_nav/team.png'
      },
      {
        'iconData': FontAwesomeIcons.home,
        'onTap': () {},
        'iconImage': 'assets/icons/bot_nav/house.png'
      },
      {
        'iconData': FontAwesomeIcons.moneyBillWave,
        'onTap': () {},
        'iconImage': 'assets/icons/bot_nav/transaction.png'
      },
      {
        'iconData': FontAwesomeIcons.cog,
        'onTap': () {},
        'iconImage': 'assets/icons/bot_nav/admin.png'
      },
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
          ),
          height: kCustomBottomNavBarHeight,
          decoration: BoxDecoration(
            gradient: themeProvider.currentTheme == Themes.dark
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                        themeProvider.getThemeColor(
                          ThemeColors.kMainBackgroundColor,
                        ),
                        themeProvider.getThemeColor(
                          ThemeColors.kCardBackgroundColor,
                        ),
                      ])
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: kBottomNavBarColors,
                  ),
            boxShadow: [
              themeProvider.getBoxShadow(ThemeBoxShadow.kBottomNavBarShadow)
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(kDefaultBorderRadius),
              topRight: Radius.circular(kDefaultBorderRadius),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: bottomNavBarIcons.map((e) {
              int index = bottomNavBarIcons.indexOf(e);
              //? you can use the colord icons
              return BottomNavBarIcon(
                iconData: e['iconData'],
                onTap: () {
                  setActiveBottomNavBarIcon(index);
                  e['onTap'] as VoidCallback;
                },
                active: activeIndex == index,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
