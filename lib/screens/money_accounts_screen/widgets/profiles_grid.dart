// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/providers/profiles_provider.dart';

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

    //* this is the main container that will hold the profiles cards
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.only(
        top: kDefaultPadding / 4,
        right: kDefaultPadding * 1.5,
        left: kDefaultPadding * 1.5,
        bottom: bottomNavBarHeight + kDefaultPadding / 4,
      ),
      decoration: BoxDecoration(),
      //* the list of profiles cards
      child: ListView.builder(
        clipBehavior: Clip.none,
        physics: BouncingScrollPhysics(),
        itemCount: profiles.length,
        itemBuilder: (ctx, index) => MoneyAccountCard(
          profileModel: profiles[index],
          activated: profilesData.activatedProfileId == profiles[index].id,
        ),
      ),
    );
  }
}