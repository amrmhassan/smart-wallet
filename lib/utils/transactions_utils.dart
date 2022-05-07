import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/models/debt_model.dart';
import 'package:smart_wallet/models/quick_action_model.dart';
import 'package:smart_wallet/models/transaction_model.dart';
import 'package:smart_wallet/providers/debts_provider.dart';
import 'package:smart_wallet/screens/debts_screen/widgets/choose_profile.dart';

import '../constants/types.dart';
import '../models/profile_model.dart';
import '../providers/profiles_provider.dart';
import '../providers/quick_actions_provider.dart';
import '../providers/transactions_provider.dart';
import 'general_utils.dart';

//? showing add transaction dialog(will appear if it is high)
Future<void> showAddHighTransactionDialog({
  required BuildContext context,
  required String title,
  required String description,
  required TransactionType transactionType,
  required ProfileModel activeProfile,
  required double amount,
}) async {
  addTransaction(
    context: context,
    title: title,
    description: description,
    transactionType: transactionType,
    activeProfile: activeProfile,
    amount: amount,
  );
}

//? showing apply quick action dialog
Future<void> showApplyQuickActionDialog(
    BuildContext context, QuickActionModel quickAction) async {
  // the problem here is that each quick action will have an id , so we can't add the same quick action with the same id to be multiple transactions with the same id
  // so i will make the add transaction provider decide the id of the newly added transaction

  await AwesomeDialog(
    context: context,
    dialogType: DialogType.INFO,
    animType: AnimType.BOTTOMSLIDE,
    title: 'Apply Quick Action?',
    btnCancelOnPress: () {},
    btnOkOnPress: () async => applyQuickAction(context, quickAction),
  ).show();
}

//? 1] adding transaction
Future<void> addTransaction({
  required BuildContext context,
  required String title,
  required String description,
  required TransactionType transactionType,
  required ProfileModel activeProfile,
  required double amount,
  bool allowSnackBar = true,
}) async {
  bool added = true;
  //* here the code for adding a new transaction
  String profileId =
      Provider.of<ProfilesProvider>(context, listen: false).activatedProfileId;

  try {
    var debtsProvider = Provider.of<DebtsProvider>(context, listen: false);
    var profilesProvider =
        Provider.of<ProfilesProvider>(context, listen: false);
    var transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    added = await transactionProvider.addTransaction(
      title: title,
      description: description,
      amount: amount,
      transactionType: transactionType,
      profileId: profileId,
      context: context,
      debtsProvider: debtsProvider,
      profilesProvider: profilesProvider,
    );

    if (!added) {
      return;
    }

    await recalculateProfilesData(context);
    if (allowSnackBar) {
      showSnackBar(context, 'Transaction Added', SnackBarType.success);
    }
    Navigator.pop(context);
  } catch (error, stackTrace) {
    CustomError.log(error: error, stackTrace: stackTrace);
    if (allowSnackBar) {
      showSnackBar(context, error.toString(), SnackBarType.error);
    }
  }
}

//? 2] adding quick action
Future<void> addQuickAction({
  required String title,
  required String description,
  required TransactionType transactionType,
  required BuildContext context,
  required double amount,
}) async {
  try {
    String profileId = Provider.of<ProfilesProvider>(context, listen: false)
        .activatedProfileId;
    //* here i will add the new quick action
    await Provider.of<QuickActionsProvider>(context, listen: false)
        .addQuickAction(title, description, amount, transactionType, profileId);

    showSnackBar(context, 'Quick Action Added', SnackBarType.success);
    Navigator.pop(context);
  } catch (error, stackTrace) {
    CustomError.log(error: error, stackTrace: stackTrace);
    showSnackBar(context, error.toString(), SnackBarType.error);
  }
}

//? 3] editing transaction
Future<void> editTransaction({
  required String title,
  required String description,
  required TransactionType transactionType,
  required ProfileModel activeProfile,
  required BuildContext context,
  required double amount,
  required TransactionModel oldTransaction,
}) async {
  String id = oldTransaction.id;
  DateTime createdAt = oldTransaction.createdAt;
  double ratioToTotal = oldTransaction.ratioToTotal;
  String profileId = oldTransaction.profileId;

  TransactionModel newTransaction = TransactionModel(
    id: id,
    title: title,
    description: description,
    amount: amount,
    createdAt: createdAt,
    transactionType: transactionType,
    ratioToTotal: ratioToTotal,
    profileId: profileId,
  );

  try {
    //* sending the updating info to the provider
    var transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    await transactionProvider.editTransaction(newTransaction: newTransaction);

    await recalculateProfilesData(context);

    showSnackBar(context, 'Transaction Updated', SnackBarType.success);
    Navigator.pop(context);
  } catch (error, stackTrace) {
    CustomError.log(error: error, stackTrace: stackTrace);
    showSnackBar(context, error.toString(), SnackBarType.error);
  }
}

//? 4] editing a quick action
Future<void> editQuickAction({
  required String title,
  required String description,
  required TransactionType transactionType,
  required ProfileModel activeProfile,
  required BuildContext context,
  required double amount,
  required QuickActionModel oldQuickaction,
}) async {
  //* here i will add edit a quick action
  String id = oldQuickaction.id;
  DateTime createdAt = oldQuickaction.createdAt;
  bool isFavorite = oldQuickaction.isFavorite;
  String profileId = oldQuickaction.profileId;
  int? quickActionIndex = oldQuickaction.quickActionIndex;
  QuickActionModel newQuickAction = QuickActionModel(
    id: id,
    title: title,
    description: description,
    amount: amount,
    createdAt: createdAt,
    transactionType: transactionType,
    isFavorite: isFavorite,
    profileId: profileId,
    quickActionIndex: quickActionIndex,
  );

  try {
    //* sending the updating info to the provider
    await Provider.of<QuickActionsProvider>(context, listen: false)
        .editQuickAction(
      newQuickAction: newQuickAction,
    );
    showSnackBar(context, 'Quick Action Updated', SnackBarType.success);
    Navigator.pop(context);
  } catch (error, stackTrace) {
    CustomError.log(error: error, stackTrace: stackTrace);
    showSnackBar(context, error.toString(), SnackBarType.error);
  }
}

//? 5] deleting a transaction
Future<void> deleteTransaction(
    BuildContext context, TransactionModel transaction) async {
  //* update the profile before deleting the transaction
  //* getting the current deleted transaction amount and transaction type

  await Provider.of<TransactionProvider>(context, listen: false)
      .deleteTransaction(transaction.id);

  await recalculateProfilesData(context);
  showSnackBar(context, 'Transaction Deleted', SnackBarType.info);
}

//? 6] applying a quick action
Future<void> applyQuickAction(
    BuildContext context, QuickActionModel quickAction) async {
  bool added = true;
  try {
    var debtsProvider = Provider.of<DebtsProvider>(context, listen: false);
    var profilesProvider =
        Provider.of<ProfilesProvider>(context, listen: false);

    added = await Provider.of<TransactionProvider>(context, listen: false)
        .addTransaction(
      title: quickAction.title,
      description: quickAction.description,
      amount: quickAction.amount,
      transactionType: quickAction.transactionType,
      profileId: quickAction.profileId,
      context: context,
      debtsProvider: debtsProvider,
      profilesProvider: profilesProvider,
    );
    if (!added) {
      return;
    }

    await recalculateProfilesData(context);

    showSnackBar(context, 'Transaction Added', SnackBarType.success, true);
  } catch (error, stackTrace) {
    CustomError.log(error: error, stackTrace: stackTrace);
    showSnackBar(context, error.toString(), SnackBarType.error, true);
  }
}

//? 7] add a debt
Future<void> addDebt({
  required BuildContext context,
  required String title,
  required double amount,
  required String borrowingProfileId,
}) async {
  try {
    //* adding the debt
    await Provider.of<DebtsProvider>(context, listen: false).addDebt(
      title,
      amount,
      borrowingProfileId,
    );

    await recalculateProfilesData(context);

    var profileName = Provider.of<ProfilesProvider>(context, listen: false)
        .getProfileById(borrowingProfileId)
        .name;
    showSnackBar(context, 'Debt amount added to "$profileName" profile',
        SnackBarType.success);
    Navigator.of(context).pop();
  } catch (error) {
    CustomError.log(error: error);
  }
}

//? 8] editing a debt
Future<void> editDebt({
  required BuildContext context,
  required String title,
  required double amount,
  required String borrowingProfileId,
  required String id,
}) async {
  var oldDebt =
      Provider.of<DebtsProvider>(context, listen: false).getDebtById(id);
  if (oldDebt.fulFilled) {
    //? show a warning snack bar
    return showSnackBar(
        context, 'You can\'t edit a fulfilled debt', SnackBarType.error);
  }
  try {
    await Provider.of<DebtsProvider>(context, listen: false).editDebt(
      id: id,
      title: title,
      amount: amount,
      borrowingProfileId: borrowingProfileId,
    );

    await recalculateProfilesData(context);

    showSnackBar(context, 'Debt edited Successfully', SnackBarType.success);
    Navigator.pop(context);
  } catch (error) {
    CustomError.log(error: error);
    showSnackBar(context, error.toString(), SnackBarType.error);
  }
}

//?9] fulfil debt
Future<void> fulfilDebt(BuildContext context, DebtModel debtModel) async {
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
    await recalculateProfilesData(context);

    showSnackBar(context, 'Debt fulfilled successfully', SnackBarType.success);
  } catch (error) {
    CustomError.log(error: error);
    showSnackBar(context, error.toString(), SnackBarType.error);
  }
}

//? 10] delete a debt
Future<bool> showDeleteCustomDialog(
    BuildContext context, DebtModel debtModel) async {
  bool confirmDelete = false;
  await AwesomeDialog(
    context: context,
    dialogType: DialogType.WARNING,
    animType: AnimType.BOTTOMSLIDE,
    title: 'Delete A Debt?',
    btnCancelOnPress: () {},
    btnOkOnPress: () async {
      try {
        await Provider.of<DebtsProvider>(context, listen: false)
            .deleteDebt(debtModel.id);
        await recalculateProfilesData(context);

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

Future<void> recalculateProfilesData(BuildContext context) async {
  var transactionProvider =
      Provider.of<TransactionProvider>(context, listen: false);
  var profilesProvider = Provider.of<ProfilesProvider>(context, listen: false);
  var debtsProvider = Provider.of<DebtsProvider>(context, listen: false);
  await profilesProvider.calcProfilesData(transactionProvider, debtsProvider);
}
