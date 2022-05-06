// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/debts_screen/widgets/choose_profile.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';

class ChooseBorrowingProfile extends StatelessWidget {
  final String borrowingProfileId;
  final Function(String profileId) setBorrowingProfileId;

  const ChooseBorrowingProfile({
    Key? key,
    required this.borrowingProfileId,
    required this.setBorrowingProfileId,
  }) : super(key: key);

  Future<void> handleShowModal(BuildContext context) async {
    var result = await showModalBottomSheet(
      context: context,
      builder: (ctx) => ChooseProfile(),
      backgroundColor: Colors.transparent,
    );
    //* this result is what is returned from the modal popping
    if (result != null) {
      setBorrowingProfileId(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    var profileProvider = Provider.of<ProfilesProvider>(context, listen: false);
    var borrowingProfile = profileProvider.getProfileById(borrowingProfileId);
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      children: [
        Expanded(
            child: Text(
          'Profile: ',
          style: themeProvider.getTextStyle(ThemeTextStyles.kHeadingTextStyle),
        )),
        Expanded(
          flex: 2,
          child: CustomCard(
            onTap: () async => await handleShowModal(context),
            border: Border.all(
              width: 1,
              color: themeProvider
                  .getThemeColor(ThemeColors.kInactiveColor)
                  .withOpacity(.5),
            ),
            backgroundColor:
                themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
            child: Text(
              borrowingProfile.name,
              overflow: TextOverflow.ellipsis,
              style: themeProvider
                  .getTextStyle(ThemeTextStyles.kParagraphTextStyle),
            ),
          ),
        ),
      ],
    );
  }
}
