//* this is the profile card

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/models/profile_data.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/utils/general_utils.dart';
import 'package:smart_wallet/utils/profile_utils.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';

import '../../../constants/colors.dart';
import '../../../constants/profiles_constants.dart';
import '../../../constants/sizes.dart';
import '../../../models/profile_model.dart';
import '../../../providers/profiles_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../profile_details_screen/profile_details_screen.dart';
import 'custom_button.dart';
import 'add_profile_modal.dart';
import 'edit_profile_button.dart';
import 'profile_details_button.dart';
import 'profile_money_summary.dart';
import 'profile_status.dart';
import 'profile_status_progress_bar.dart';

class MoneyAccountCard extends StatefulWidget {
  final ProfileModel profileModel;
  final bool activated;

  const MoneyAccountCard({
    Key? key,
    required this.profileModel,
    required this.activated,
  }) : super(key: key);

  @override
  State<MoneyAccountCard> createState() => _MoneyAccountCardState();
}

class _MoneyAccountCardState extends State<MoneyAccountCard> {
  final TextEditingController _editedProfileNameController =
      TextEditingController();
  bool _loading = false;
  double? income;
  double? outcome;
  double? totalMoney;
  late double incomeRatio;
  late MoneyAccountStatus moneyAccountStatus;

  void clearEditedProfileName() {
    _editedProfileNameController.text = '';
  }

  Future<void> changeActivatedProfile(BuildContext context) async {
    //? here set the loading to true and
    await Provider.of<ProfilesProvider>(context, listen: false)
        .setActivatedProfile(widget.profileModel.id);
    String activeProfileId =
        Provider.of<ProfilesProvider>(context, listen: false)
            .activatedProfileId;
    await Provider.of<TransactionProvider>(context, listen: false)
        .fetchAndUpdateProfileTransactions(activeProfileId);
    await Provider.of<QuickActionsProvider>(context, listen: false)
        .fetchAndUpdateProfileQuickActions(activeProfileId);
  }

//* showing the profile modal that will be responsible for changing the profile name
  Future<void> showEditProfileModal(
    BuildContext context,
  ) async {
    _editedProfileNameController.text = widget.profileModel.name;
    String oldName = widget.profileModel.name;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddProfileModal(
        context: context,
        profileNameController: _editedProfileNameController,
        onTap: () async {
          String newName = _editedProfileNameController.text.trim();
          await editProfileName(context, newName, oldName);
        },
        profileOperationType: ProfileOperationType.edit,
        clearEditedProfileName: clearEditedProfileName,
      ),
    );
  }

//* editing the profile name and applying some checks on it
  Future<void> editProfileName(
      BuildContext context, String newName, String oldName) async {
    //* checking if the old name is the same as the new name and return a warning in this function
    //* checking if another profile has the same name and return a warning will be in the profile editing name provider
    if (oldName == newName) {
      Navigator.pop(context);
      return showSnackBar(context, 'No change in the name!', SnackBarType.info);
    }
    try {
      //* editing the profile name
      await Provider.of<ProfilesProvider>(context, listen: false)
          .editProfile(id: widget.profileModel.id, name: newName);
      showSnackBar(
          context, "Profile Name edited Successfully", SnackBarType.success);
      Navigator.pop(context);
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
      Navigator.pop(context);
      showSnackBar(context, error.toString(), SnackBarType.error);
    }
  }

//* for navigating to the clicked profile card details
  void goToProfileDetailsPage(BuildContext context) {
    if (moneyAccountStatus != MoneyAccountStatus.empty) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) =>
                ProfileDetailsScreen(profileId: widget.profileModel.id),
          ));
    } else {
      showDeleteProfileModal(
          context, widget.profileModel.id, 'This profile is empty, Delete it?');
    }
  }

  Color getStatusColor(ThemeProvider _themeProvider) {
    //? for setting the profileStatusColor
    if (moneyAccountStatus == MoneyAccountStatus.good) {
      return kGoodProfileStatusColor;
    } else if (moneyAccountStatus == MoneyAccountStatus.moderate) {
      return kModerateProfileStatusColor;
    } else if (moneyAccountStatus == MoneyAccountStatus.critical) {
      return kCriticalProfileStatusColor;
    } else {
      //! this is an exception , try to find a solution for this
      if (_themeProvider.currentTheme == Themes.basic) {
        return _themeProvider.getThemeColor(ThemeColors.kMainColor);
      } else {
        return _themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor);
      }
    }
  }

  Future<void> fetchData() async {
    setState(() {
      _loading = true;
    });
    try {
      ProfilesData profileData =
          Provider.of<ProfilesProvider>(context, listen: false)
              .getProfileDataById(widget.profileModel.id);
      setState(() {
        income = profileData.income;
        outcome = profileData.outcome;
        totalMoney = profileData.totalMoney;
        moneyAccountStatus = profileData.moneyAccountStatus;
        incomeRatio = profileData.incomeRatio;
      });
    } catch (error) {
      CustomError.log(error: error);
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fetchData();
    var themeProvider = Provider.of<ThemeProvider>(context);

    //? if any confusion when clicking the card and go to the details page just remove that and make it only happen when clicking on the status circle
    return _loading
        ? CustomCard(
            width: 100,
            height: 300,
            child: Text(
              'Loading',
              style: themeProvider.getTextStyle(
                ThemeTextStyles.kHeadingTextStyle,
              ),
            ))
        : GestureDetector(
            onTap: () => goToProfileDetailsPage(context),
            child: CustomCard(
              //* these constrains are for the card holder
              constraints: BoxConstraints(
                minHeight: 300,
                maxHeight:
                    moneyAccountStatus == MoneyAccountStatus.empty ? 370 : 460,
              ),
              padding: const EdgeInsets.only(
                right: kDefaultPadding / 4,
                left: kDefaultPadding / 4,
                top: kDefaultPadding / 2,
                bottom: 0,
              ),
              margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //? that was for previewing the lastActivated date on each profile card for testing
                  // Text(
                  //   profileModel.lastActivatedDate == null
                  //        ? dbFalse
                  //       : profileModel.lastActivatedDate!.toIso8601String(),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      EditProfileButton(
                        onTap: () async {
                          await showEditProfileModal(context);
                        },
                      ),
                      const SizedBox(
                        width: kDefaultPadding / 2,
                      ),
                      ProfileDetailsButton(
                        profileId: widget.profileModel.id,
                        onTap: () => goToProfileDetailsPage(context),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  ProfileStatus(
                    moneyAccountStatus: moneyAccountStatus,
                    profileStatusColor: getStatusColor(themeProvider),
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.7,
                    child: Text(
                      widget.profileModel.name,
                      style: themeProvider
                          .getTextStyle(ThemeTextStyles.kHeadingTextStyle),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  // activated
                  //     ? const ActivatedProfileButton()
                  //     : NotActivateProfileButton(
                  //         onTap: () async {
                  //           await changeActivatedProfile(context);
                  //         },
                  //       ),
                  CustomButton(
                    onTap: () async {
                      await changeActivatedProfile(context);
                    },
                    title: widget.activated ? 'Activated' : 'Activate',
                    active: !widget.activated,
                  ),
                  SizedBox(
                    height: moneyAccountStatus == MoneyAccountStatus.empty
                        ? kDefaultPadding
                        : kDefaultPadding / 2,
                  ),
                  if (moneyAccountStatus != MoneyAccountStatus.empty)
                    ProfileStatusProgressBar(
                      profileStatusColor: getStatusColor(themeProvider),
                      incomeRatio: incomeRatio,
                    ),
                  if (moneyAccountStatus != MoneyAccountStatus.empty)
                    const SizedBox(
                      height: kDefaultPadding / 2,
                    ),
                  if (moneyAccountStatus != MoneyAccountStatus.empty)
                    ProfileMoneySummary(
                      income: income,
                      outcome: outcome,
                      totalMoney: totalMoney,
                      loading: _loading,
                    ),
                ],
              ),
            ),
          );
  }
}
