import 'package:flutter/material.dart';
import '../../constants/styles.dart';

import '../../constants/sizes.dart';
import '../global/go_back_icon.dart';
import '../global/menu_icon.dart';
import '../global/person_icon.dart';

class MyAppBar extends StatelessWidget {
  final String? title;
  final Widget? rightIcon;

  const MyAppBar({
    Key? key,
    this.title,
    this.rightIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //* the main container of my app bar
    return Container(
      padding: EdgeInsets.only(
        // * this title == null allows me to check if the screen abb bar will have a horizontal padding or not
        top: kDefaultVerticalPadding,
        right: title == null ? kDefaultHorizontalPadding : 0,
        left: title == null ? kDefaultHorizontalPadding : 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //* showing the menuicon or go back icon
          title == null
              ? MenuIcon(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                )
              : const GoBackIcon(),
          //* showing the title of given

          Expanded(
            child: title != null
                ? Container(
                    alignment: Alignment.center,
                    child: Text(
                      title as String,
                      style: kParagraphTextStyle,
                    ),
                  )
                : Container(),
          ),
          //* showing the person icon for allowing the user to edit his profile data
          rightIcon ??
              PersonIcon(
                onTap: () {},
              ),
        ],
      ),
    );
  }
}
