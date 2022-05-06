// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/debts_screen/widgets/profile_to_choose_card.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';

class ChooseProfile extends StatelessWidget {
  final double? amount;
  final bool considerAmount;
  final String? title;

  const ChooseProfile({
    Key? key,
    this.amount,
    this.considerAmount = false,
    this.title,
  }) : super(key: key);

  bool active(double profileTotalMoney) {
    bool r = considerAmount && amount != null && (amount! > profileTotalMoney);
    return !r;
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    var profileProvider = Provider.of<ProfilesProvider>(context, listen: false);
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dy > 0) {
          //? this will be executed when ever the user swipes right
          Navigator.pop(context);
        } else {
          //? this will be executed when ever the user swipes left

        }
      },
      child: CustomCard(
        clipBehavior: Clip.hardEdge,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            if (title != null)
              Text(
                title.toString(),
                style: themeProvider
                    .getTextStyle(ThemeTextStyles.kParagraphTextStyle),
              ),
            SizedBox(
              height: title == null ? kDefaultPadding * 2 : kDefaultPadding,
            ),
            ...profileProvider.profiles
                .map((profile) => ProfileToChooseCard(
                      active: active(profile.totalMoney),
                      profileModel: profile,
                      onChooseProfile: (profile) {
                        //* this will return the profile id after popping this modal
                        Navigator.pop(context, profile.id);
                      },
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}


// Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         Navigator.pop(context);
            //       },
            //       child: Container(
            //         alignment: Alignment.centerRight,
            //         padding: EdgeInsets.symmetric(
            //           horizontal: kDefaultHorizontalPadding / 2,
            //           vertical: kDefaultVerticalPadding,
            //         ),
            //         child: Icon(
            //           Icons.close,
            //           color:
            //               themeProvider.getThemeColor(ThemeColors.kMainColor),
            //           size: kDefaultIconSize,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),