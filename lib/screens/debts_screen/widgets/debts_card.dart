// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/helpers/responsive.dart';
import 'package:smart_wallet/models/debt_model.dart';
import 'package:smart_wallet/providers/debts_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/screens/debts_screen/widgets/choose_profile.dart';
import 'package:smart_wallet/utils/transactions_utils.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';

import '../../../providers/theme_provider.dart';
import '../../../constants/sizes.dart';
import '../../../constants/types.dart';
import '../../../utils/general_utils.dart';
import '../../add_transaction_screen/add_transaction_screen.dart';
import '../../../widgets/global/card_action_button.dart';

class DebtCard extends StatelessWidget {
  final DebtModel debtModel;
  const DebtCard({
    Key? key,
    required this.debtModel,
  }) : super(key: key);

//* this function will show a dialog to delete and after confirming deleting it will be deleted
//* or if cancel was clicked the card will come back and won't be deleted

  Future<bool> showDeleteCustomDialog(BuildContext context) async {
    bool confirmDelete = false;
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Delete A Debt?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        try {
          //* edit the borrowing profile to increase it's amount
          var profile = Provider.of<ProfilesProvider>(context, listen: false)
              .getProfileById(debtModel.borrowingProfileId);
          await Provider.of<ProfilesProvider>(context, listen: false)
              .editProfile(
            id: debtModel.borrowingProfileId,
            income: profile.income - debtModel.amount,
          );

          await Provider.of<DebtsProvider>(context, listen: false)
              .deleteDebt(debtModel.id);
          showSnackBar(
              context, 'Debt Deleted Successfully', SnackBarType.success);
        } catch (error, stackTrace) {
          showSnackBar(context, error.toString(), SnackBarType.error);
          CustomError.log(error: error, stackTrace: stackTrace);
        }
        confirmDelete = true;
      },
    ).show();

    return confirmDelete;
  }

  Future<void> fulfilDebt(BuildContext context) async {
    if (debtModel.fulFilled) {
      return;
    }
    var fulfillingProfileId = await showModalBottomSheet(
      context: context,
      builder: (ctx) => ChooseProfile(
        title: 'Fulfil A Debt',
        considerAmount: true,
        amount: debtModel.amount,
      ),
      backgroundColor: Colors.transparent,
    );
    if (fulfillingProfileId == null) {
      return;
    }
    try {
      //* editing the debt
      await Provider.of<DebtsProvider>(context, listen: false)
          .fulfilDebt(debtModel.id, fulfillingProfileId);

      //* editing the profile
      var profileProvider =
          Provider.of<ProfilesProvider>(context, listen: false);
      var fulfillingProfile =
          profileProvider.getProfileById(fulfillingProfileId);
      await profileProvider.editProfile(
          id: fulfillingProfile.id,
          outcome: fulfillingProfile.outcome + debtModel.amount);
      showSnackBar(
          context, 'Debt fulfilled successfully', SnackBarType.success);
    } catch (error) {
      CustomError.log(error: error);
      showSnackBar(context, error.toString(), SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    //* the main container of the card
    return Dismissible(
      direction: debtModel.fulFilled
          ? DismissDirection.none
          : DismissDirection.endToStart,
      confirmDismiss: (direction) => showDeleteCustomDialog(context),
      background: const DebtCardBackground(),
      key: Key(debtModel.id),
      child: CustomCard(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),
        padding: EdgeInsets.zero,

        //* the row that hold the main components of the card, ( circular leading icon, title buttons etc...)
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding / 2,
            vertical: kDefaultVerticalPadding / 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //* transaction type icon
              Container(
                alignment: Alignment.center,
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    width: 2,
                    color:
                        themeProvider.getThemeColor(ThemeColors.kIncomeColor),
                  ),
                ),
                child: Icon(
                  Icons.arrow_downward,
                  color: themeProvider.getThemeColor(ThemeColors.kIncomeColor),
                  size: kDefaultIconSize,
                ),
              ),
              const SizedBox(
                width: kDefaultPadding / 3,
              ),
              //* title and price column
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* title text widget
                  SizedBox(
                    width: Responsive.getWidth(context) / 3,
                    child: Text(
                      debtModel.title,
                      style: themeProvider
                          .getTextStyle(ThemeTextStyles.kParagraphTextStyle),
                      // style: kParagraphTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 4,
                  ),
                  //* price text widget
                  Text(
                    '${doubleToString(debtModel.amount)} $currency',
                    style: themeProvider.getTextStyle(
                        ThemeTextStyles.kSmallTextPrimaryColorStyle),
                  ),
                ],
              ),
              Expanded(
                //* the container of the actions button
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //* for opening the screen to edit the quick action
                    if (!debtModel.fulFilled)
                      CardActionButton(
                        iconData: FontAwesomeIcons.pen,
                        color:
                            themeProvider.getThemeColor(ThemeColors.kMainColor),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => AddTransactionScreen(
                                addTransactionScreenOperations:
                                    AddTransactionScreenOperations.editDebt,
                                editingId: debtModel.id,
                              ),
                            ),
                          );
                        },
                      ),

                    GestureDetector(
                      onTap: () async => await fulfilDebt(context),
                      child: Container(
                        alignment: Alignment.center,
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: debtModel.fulFilled
                              ? themeProvider
                                  .getThemeColor(ThemeColors.kIncomeColor)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(1000),
                          border: debtModel.fulFilled
                              ? null
                              : Border.all(
                                  width: 2,
                                  color: themeProvider.getThemeColor(
                                    ThemeColors.kMainColor,
                                  ),
                                ),
                        ),
                        child: debtModel.fulFilled
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                // size: kDefaultIconS
                                // ize,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(
                      width: kDefaultPadding / 4,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DebtCardBackground extends StatelessWidget {
  const DebtCardBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: kDefaultPadding / 2),
      margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),
      decoration: BoxDecoration(
        color: themeProvider.getThemeColor(ThemeColors.kOutcomeColor),
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      ),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: kDefaultIconSize,
      ),
    );
  }
}
