// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:wallet_app/constants/styles.dart';
import 'package:wallet_app/models/profile_model.dart';

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
      constraints: BoxConstraints(minHeight: 300, maxHeight: 450),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding / 4,
        vertical: kDefaultPadding / 2,
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
          ProfileStatusProgressBar(
            profileStatusColor: profileModel.profileStatusColor,
            incomeRatio: profileModel.incomeRatio,
          ),
          SizedBox(
            height: kDefaultPadding / 2,
          ),
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
