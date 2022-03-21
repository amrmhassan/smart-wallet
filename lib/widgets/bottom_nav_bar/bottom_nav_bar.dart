import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../constants/styles.dart';
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
    List<Map<String, dynamic>> bottomNavBarIcons = [
      {
        'iconData': FontAwesomeIcons.chartLine,
        'onTap': () {},
      },
      {
        'iconData': FontAwesomeIcons.users,
        'onTap': () {},
      },
      {
        'iconData': FontAwesomeIcons.home,
        'onTap': () {},
      },
      {
        'iconData': FontAwesomeIcons.moneyBillWave,
        'onTap': () {},
      },
      {
        'iconData': FontAwesomeIcons.cog,
        'onTap': () {},
      },
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
          ),
          height: bottomNavBarHeight,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: kBottomNavBarColors,
            ),
            boxShadow: [
              kBottomNavBarShadow,
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
