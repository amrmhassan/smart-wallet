// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';

class ProfileToChooseCard extends StatelessWidget {
  final ProfileModel profileModel;
  final bool active;
  final Function(ProfileModel profileModel) onChooseProfile;
  const ProfileToChooseCard({
    Key? key,
    required this.profileModel,
    required this.onChooseProfile,
    required this.active,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      children: [
        CustomCard(
          onTap: () => onChooseProfile(profileModel),
          border: Border.all(
            width: 1,
            color: themeProvider
                .getThemeColor(ThemeColors.kInactiveColor)
                .withOpacity(.5),
          ),
          height: 100,
          backgroundColor: active
              ? Colors.red
              : themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                profileModel.name,
                style: themeProvider
                    .getTextStyle(ThemeTextStyles.kHeadingTextStyle),
              )),
              Icon(
                Icons.arrow_forward_ios_outlined,
                size: kDefaultIconSize,
                color: themeProvider.getThemeColor(ThemeColors.kMainColor),
              )
            ],
          ),
        ),
        SizedBox(
          height: kDefaultPadding,
        ),
      ],
    );
  }
}
