// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wallet_app/constants/styles.dart';

import '../../constants/sizes.dart';
import '../global/go_back_icon.dart';
import '../global/menu_icon.dart';
import '../global/person_icon.dart';

class MyAppBar extends StatelessWidget {
  final String? title;

  const MyAppBar({
    Key? key,
    this.title,
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
              title == null
                  ? MenuIcon(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                    )
                  : GoBackIcon(),
              if (title != null)
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      title as String,
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
