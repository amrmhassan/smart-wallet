//* this is the profile card
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/providers/quick_actions_provider.dart';
import 'package:wallet_app/providers/transactions_provider.dart';

import '../../../constants/profiles.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
import '../../../models/profile_model.dart';
import '../../../providers/profiles_provider.dart';
import 'activate_profile_button.dart';
import 'profile_details_button.dart';
import 'profile_money_summary.dart';
import 'profile_status.dart';
import 'profile_status_progress_bar.dart';

class MoneyAccountCard extends StatelessWidget {
  final ProfileModel profileModel;
  final bool activated;

  const MoneyAccountCard({
    Key? key,
    required this.profileModel,
    required this.activated,
  }) : super(key: key);
  Future<void> changeActivatedProfile(BuildContext context) async {
    //? here set the loading to true and
    await Provider.of<ProfilesProvider>(context, listen: false)
        .setActivatedProfile(profileModel.id);
    String activatedProfileId =
        Provider.of<ProfilesProvider>(context, listen: false)
            .activatedProfileId;
    await Provider.of<TransactionProvider>(context, listen: false)
        .fetchAndUpdateTransactions(activatedProfileId);
    await Provider.of<QuickActionsProvider>(context, listen: false)
        .fetchAndUpdateQuickActions(activatedProfileId);
    //? here set the loading to false
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //* these constrains are for the card holder
      constraints: BoxConstraints(
        minHeight: 300,
        maxHeight: profileModel.moneyAccountStatus == MoneyAccountStatus.empty
            ? 360
            : 460,
      ),
      padding: const EdgeInsets.only(
        right: kDefaultPadding / 4,
        left: kDefaultPadding / 4,
        top: kDefaultPadding / 2,
        bottom: 0,
      ),
      margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),
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
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          ProfileStatus(
            moneyAccountStatus: profileModel.moneyAccountStatus,
            profileStatusColor: profileModel.profileStatusColor,
          ),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          Text(
            profileModel.name,
            style: kHeadingTextStyle,
          ),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          activated
              ? const ActivatedProfileButton()
              : NotActivateProfileButton(
                  onTap: () async => await changeActivatedProfile(context),
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
            const SizedBox(
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
