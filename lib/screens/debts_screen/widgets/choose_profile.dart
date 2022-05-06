// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/home_screen/widgets/background.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';

class ChooseProfile extends StatelessWidget {
  final double? amount;
  final bool? considerAmount;

  const ChooseProfile({
    Key? key,
    this.amount,
    this.considerAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var profileProvider = Provider.of<ProfilesProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Background(),
          SafeArea(
            child: Column(
              children: [
                Container(
                  height: kDefaultPadding * 2,
                ),
                Expanded(
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      if (details.delta.dy > 0) {
                        //? this will be executed when ever the user swipes right
                        Navigator.pop(context);
                      } else {
                        //? this will be executed when ever the user swipes left

                      }
                    },
                    child: CustomCard(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: kDefaultHorizontalPadding / 2,
                                    vertical: kDefaultVerticalPadding,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: themeProvider
                                        .getThemeColor(ThemeColors.kMainColor),
                                    size: kDefaultIconSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ...profileProvider.profiles
                              .map((profile) => ProfileToChoose(
                                    profileModel: profile,
                                    onChooseProfile: (profile) {
                                      print(profile.name);
                                      print(profile.id);
                                    },
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileToChoose extends StatelessWidget {
  final ProfileModel profileModel;
  final Function(ProfileModel profileModel) onChooseProfile;
  const ProfileToChoose({
    Key? key,
    required this.profileModel,
    required this.onChooseProfile,
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
          backgroundColor:
              themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
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
