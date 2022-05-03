// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/user_photo.dart';

import '../../../constants/theme_constants.dart';
import '../../../providers/theme_provider.dart';

class UserInfoViewer extends StatelessWidget {
  final String? photoUrl;
  final String? userName;
  final String? userEmail;
  const UserInfoViewer({
    Key? key,
    this.photoUrl,
    this.userName,
    this.userEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      children: [
        UserPhoto(),
        SizedBox(
          height: kDefaultPadding / 2,
        ),
        if (userName != null)
          Text(
            userName!,
            style: themeProvider.getTextStyle(
              ThemeTextStyles.kHeadingTextStyle,
            ),
          ),
        SizedBox(
          height: kDefaultPadding / 3,
        ),
        if (userEmail != null)
          Text(
            userEmail!,
            style: themeProvider.getTextStyle(
              ThemeTextStyles.kSmallInActiveParagraphTextStyle,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
