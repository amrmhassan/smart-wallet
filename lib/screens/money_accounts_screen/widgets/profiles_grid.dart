import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/user_prefs_provider.dart';

import '../../../constants/sizes.dart';
import 'money_account_card.dart';

class ProfilesGrid extends StatelessWidget {
  const ProfilesGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var profilesData = Provider.of<ProfilesProvider>(context);
    var profiles = profilesData.profiles;
    var userPrefsProvider = Provider.of<UserPrefsProvider>(context);

    //* this is the main container that will hold the profiles cards
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.only(
        top: kDefaultPadding / 4,
        right: kDefaultPadding * 1.5,
        left: kDefaultPadding * 1.5,
        bottom: kCustomBottomNavBarHeight + kDefaultPadding / 4,
      ),
      decoration: const BoxDecoration(),
      //* the list of profiles cards
      child: ListView.builder(
        clipBehavior: Clip.none,
        physics: const BouncingScrollPhysics(),
        itemCount: profiles.length,
        itemBuilder: (ctx, index) => MoneyAccountCard(
          profileModel: profiles[index],
          activated: userPrefsProvider.activatedProfileId == profiles[index].id,
        ),
      ),
    );
  }
}
