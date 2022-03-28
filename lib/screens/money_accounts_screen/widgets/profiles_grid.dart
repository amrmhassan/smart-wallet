// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/constants/colors.dart';
import 'package:wallet_app/constants/styles.dart';
import 'package:wallet_app/models/profile_model.dart';
import 'package:wallet_app/providers/profiles_provider.dart';

import '../../../constants/profiles.dart';
import '../../../constants/sizes.dart';
import 'profile_details_button.dart';
import 'profile_money_summary.dart';
import 'profile_status.dart';
import 'profile_status_progress_bar.dart';

class ProfilesGrid extends StatelessWidget {
  const ProfilesGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var profilesData = Provider.of<ProfilesProvider>(context);
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
        itemCount: profilesData.profiles.length,
        itemBuilder: (ctx, index) => MoneyAccountCard(
          profileModel: profilesData.profiles[index],
        ),
      ),
    );
  }
}

//* this is the profile card
class MoneyAccountCard extends StatelessWidget {
  final ProfileModel profileModel;
  const MoneyAccountCard({
    Key? key,
    required this.profileModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //* these constrains are for the card holder
      constraints: BoxConstraints(
        minHeight: 300,
        maxHeight: profileModel.moneyAccountStatus == MoneyAccountStatus.empty
            ? 350
            : 460,
      ),
      padding: EdgeInsets.only(
        right: kDefaultPadding / 4,
        left: kDefaultPadding / 4,
        top: kDefaultPadding / 2,
        bottom: 0,
      ),
      margin: EdgeInsets.only(bottom: kDefaultPadding / 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        color: Colors.white,
        boxShadow: [
          kCardBoxShadow,
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfileDetailsButton(
            profileId: profileModel.id,
          ),
          SizedBox(
            height: kDefaultPadding / 2,
          ),
          ProfileStatus(
            moneyAccountStatus: profileModel.moneyAccountStatus,
            profileStatusColor: profileModel.profileStatusColor,
          ),
          SizedBox(
            height: kDefaultPadding / 2,
          ),
          Text(
            profileModel.name,
            style: kHeadingTextStyle,
          ),
          SizedBox(
            height: kDefaultPadding / 2,
          ),
          ActivateProfileButton(
            onTap: () {},
            activated: profileModel.activated,
          ),
          SizedBox(
            height: profileModel.moneyAccountStatus == MoneyAccountStatus.empty
                ? kDefaultPadding
                : kDefaultPadding / 2,
          ),
          if (profileModel.moneyAccountStatus != MoneyAccountStatus.empty)
            ProfileStatusProgressBar(
              profileStatusColor: profileModel.profileStatusColor,
              incomeRatio: profileModel.incomeRatio,
            ),
          if (profileModel.moneyAccountStatus != MoneyAccountStatus.empty)
            SizedBox(
              height: kDefaultPadding / 2,
            ),
          if (profileModel.moneyAccountStatus != MoneyAccountStatus.empty)
            ProfileMoneySummary(
              income: profileModel.income,
              outcome: profileModel.outcome,
              totalMoney: profileModel.totalMoney,
            ),
        ],
      ),
    );
  }
}

class ActivateProfileButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool activated;

  const ActivateProfileButton({
    Key? key,
    required this.activated,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: activated ? kInactiveColor.withOpacity(0.3) : kMainColor,
          borderRadius: BorderRadius.circular(kDefaultBorderRadius / 4),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: activated ? null : onTap,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 3),
              alignment: Alignment.center,
              child: Text(
                activated ? 'Activated' : 'Activate',
                style: activated
                    ? kActivatedProfileTextStyle
                    : kActivateProfileTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
