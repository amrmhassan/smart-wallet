import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
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

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: themeProvider.getThemeColor(ThemeColors.kCardBackgroundColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                User user = snapshot.data as User;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: UserPhoto(
                    photoUrl: user.photoURL ?? '',
                    raduis: 40,
                  ),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color:
                          themeProvider.getThemeColor(ThemeColors.kMainColor),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.person,
                    color: themeProvider.getThemeColor(ThemeColors.kMainColor),
                    size: kDefaultIconSize,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
