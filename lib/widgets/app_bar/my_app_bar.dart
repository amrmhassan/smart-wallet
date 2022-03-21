// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wallet_app/constants/styles.dart';

import '../../constants/sizes.dart';
import '../global/go_back_icon.dart';
import '../global/menu_icon.dart';
import '../global/person_icon.dart';

class MyAppBar extends StatelessWidget {
  final bool mainAppBar;
  const MyAppBar({
    Key? key,
    this.mainAppBar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: kDefaultVerticalPadding,
            right: kDefaultHorizontalPadding,
            left: kDefaultHorizontalPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              mainAppBar
                  ? MenuIcon(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                    )
                  : GoBackIcon(),
              if (!mainAppBar)
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'New Transaction',
                      style: kParagraphTextStyle,
                    ),
                  ),
                ),
              PersonIcon(
                onTap: () {},
              ),
            ],
          ),
        ),
        // if (mainAppBar) HomeHeading(),
      ],
    );
  }
}
