//* 1] this method will add a new transaction
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/models/quick_action_model.dart';
import 'package:wallet_app/models/transaction_model.dart';

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
  double totalMoney = Provider.of<ProfilesProvider>(context, listen: false)
      .getActiveProfile
      .totalMoney;

  if (transactionType == TransactionType.outcome && amount > totalMoney) {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Your balance is lower, add a debt instead?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        //! here i will add the ability to add a debt to the debts providers which will be shown in the debts screen in the sidebar
        showSnackBar(context, 'Dept added(Soon)', SnackBarType.success);
      },
    ).show();
  } else {
    addTransaction(
      context: context,
      title: title,
      description: description,
      transactionType: transactionType,
      activeProfile: activeProfile,
      amount: amount,
    );
  }
}

//? showing apply quick action dialog
Future<void> showApplyQuickActionDialog(
    BuildContext context, QuickActionModel quickAction) async {
  // the problem here is that each quick action will have an id , so we can't add the same quick action with the same id to be multiple transactions with the same id
  // so i will make the add transaction provider decide the id of the newly added transaction

  await AwesomeDialog(
    context: context,
    dialogType: DialogType.SUCCES,
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
  //* here the code for adding a new transaction
  String profileId =
      Provider.of<ProfilesProvider>(context, listen: false).activatedProfileId;

  try {
    await Provider.of<TransactionProvider>(context, listen: false)
        .addTransaction(
      title,
      description,
      amount,
      transactionType,
      profileId,
    );

    //* here i will edit the current active profile
    //* checking the added transaction type and then update the profile depending on that
    if (transactionType == TransactionType.income) {
      //* if income then update income

      await Provider.of<ProfilesProvider>(context, listen: false)
          .editActiveProfile(income: activeProfile.income + amount);
    } else if (transactionType == TransactionType.outcome) {
      //* if outcome then update the outcome
      await Provider.of<ProfilesProvider>(context, listen: false)
          .editActiveProfile(outcome: activeProfile.outcome + amount);
    }
    if (allowSnackBar) {
      showSnackBar(context, 'Transaction Added', SnackBarType.success);
    }
    Navigator.pop(context);
  } catch (error) {
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
  } catch (error) {
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
  double oldAmount = oldTransaction.amount;
  double newAmount = amount;

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
    await Provider.of<TransactionProvider>(context, listen: false)
        .editTransaction(id, newTransaction);

    //* editing the current money profile when editing a transaction
    if (transactionType == TransactionType.income) {
      await Provider.of<ProfilesProvider>(context, listen: false)
          .editActiveProfile(
              income: activeProfile.income - oldAmount + newAmount);
    } else if (transactionType == TransactionType.outcome) {
      await Provider.of<ProfilesProvider>(context, listen: false)
          .editActiveProfile(
              outcome: activeProfile.outcome - oldAmount + newAmount);
    }

    showSnackBar(context, 'Transaction Updated', SnackBarType.success);
    Navigator.pop(context);
  } catch (error) {
    showSnackBar(context, error.toString(), SnackBarType.error);
  }
}

//? 4] editing a quick action
Future<void> editQuickAction(
    {required String title,
    required String description,
    required TransactionType transactionType,
    required ProfileModel activeProfile,
    required BuildContext context,
    required double amount,
    required QuickActionModel oldQuickaction}) async {
  //* here i will add edit a quick action
  String id = oldQuickaction.id;
  DateTime createdAt = oldQuickaction.createdAt;
  bool isFavorite = oldQuickaction.isFavorite;
  String profileId = oldQuickaction.profileId;
  QuickActionModel newQuickAction = QuickActionModel(
    id: id,
    title: title,
    description: description,
    amount: amount,
    createdAt: createdAt,
    transactionType: transactionType,
    isFavorite: isFavorite,
    profileId: profileId,
    // isFavorite:
  );

  try {
    //* sending the updating info to the provider
    await Provider.of<QuickActionsProvider>(context, listen: false)
        .editQuickAction(id, newQuickAction);
    showSnackBar(context, 'Quick Action Updated', SnackBarType.success);
    Navigator.pop(context);
  } catch (error) {
    showSnackBar(context, error.toString(), SnackBarType.error);
  }
}

//? 5] deleting a transaction
Future<void> deleteTransaction(
    BuildContext context, TransactionModel transaction) async {
  //* update the profile before deleting the transaction
  //* getting the current deleted transaction amount and transaction type

  try {
    await Provider.of<TransactionProvider>(context, listen: false)
        .deleteTransaction(transaction.id);
    showSnackBar(context, 'Transaction Deleted', SnackBarType.info);

    //* getting the curret active profile to update it
    ProfileModel activeProfile =
        Provider.of<ProfilesProvider>(context, listen: false).getActiveProfile;
    //* checking the transaction type to update the profile according to that
    if (transaction.transactionType == TransactionType.income) {
      await Provider.of<ProfilesProvider>(context, listen: false)
          .editActiveProfile(income: activeProfile.income - transaction.amount);
    } else if (transaction.transactionType == TransactionType.outcome) {
      await Provider.of<ProfilesProvider>(context, listen: false)
          .editActiveProfile(
              outcome: activeProfile.outcome - transaction.amount);
    }
  } catch (error) {
    showSnackBar(context, error.toString(), SnackBarType.error);
  }
}

//? 6] applying a quick action
Future<void> applyQuickAction(
    BuildContext context, QuickActionModel quickAction) async {
  try {
    await Provider.of<TransactionProvider>(context, listen: false)
        .addTransaction(
      quickAction.title,
      quickAction.description,
      quickAction.amount,
      quickAction.transactionType,
      quickAction.profileId,
    );

    //* here i will edit the current active profile
    ProfileModel activeProfile =
        Provider.of<ProfilesProvider>(context, listen: false).getActiveProfile;
    //* cheching the added transaction type and then update the profile depending on that

    if (quickAction.transactionType == TransactionType.income) {
      //* if income then update income

      await Provider.of<ProfilesProvider>(context, listen: false)
          .editActiveProfile(income: activeProfile.income + quickAction.amount);
    } else if (quickAction.transactionType == TransactionType.outcome) {
      //* if outcome then update the outcome
      await Provider.of<ProfilesProvider>(context, listen: false)
          .editActiveProfile(
              outcome: activeProfile.outcome + quickAction.amount);
    }
    showSnackBar(context, 'Transaction Added', SnackBarType.success, true);
  } catch (error) {
    showSnackBar(context, error.toString(), SnackBarType.error, true);
  }
}
