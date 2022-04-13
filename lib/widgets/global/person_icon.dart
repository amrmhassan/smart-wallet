import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/authentication_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/user_photo.dart';

import '../../constants/sizes.dart';

class PersonIcon extends StatelessWidget {
  final VoidCallback onTap;
  const PersonIcon({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var authenticationProvider = Provider.of<AuthenticationProvider>(context);
    String? userId;
    String? profilePic;
    try {
      userId = authenticationProvider.userGoogle.id;
      profilePic = authenticationProvider.userGoogle.photoUrl;
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: themeProvider.getThemeColor(ThemeColors.kCardBackgroundColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          //! add a property enablePersonIconTapping and make its default to true, make it false only from the synced data page

          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(
                width: userId != null ? 1 : 3,
                color: themeProvider.getThemeColor(ThemeColors.kMainColor),
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: userId != null && profilePic != null
                ? UserPhoto(
                    photoUrl: profilePic,
                    raduis: 40,
                  )
                : Icon(
                    Icons.person,
                    color: themeProvider.getThemeColor(ThemeColors.kMainColor),
                    size: kDefaultIconSize,
                  ),
          ),
        ),
      ),
    );
  }
}
