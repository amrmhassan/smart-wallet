// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

import 'package:smart_wallet/utils/general_utils.dart';
import 'package:smart_wallet/utils/profile_utils.dart';

class DeleteProfileIcon extends StatelessWidget {
  final String profileId;

  const DeleteProfileIcon({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var activeProfileId = Provider.of<ProfilesProvider>(context, listen: false)
        .activatedProfileId;
    return GestureDetector(
      onTap: activeProfileId == profileId
          ? () {
              showSnackBar(
                context,
                'You can\'t delete the active profile',
                SnackBarType.error,
              );
            }
          : null,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: activeProfileId == profileId
                ? null
                : () async => await showDeleteProfileModal(
                    context, profileId, null, true),
            child: Container(
              padding: EdgeInsets.all(kDefaultPadding / 2),
              child: Icon(
                Icons.delete,
                color: activeProfileId == profileId
                    ? themeProvider
                        .getThemeColor(ThemeColors.kOutcomeColor)
                        .withOpacity(0.5)
                    : themeProvider.getThemeColor(ThemeColors.kOutcomeColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
