//* 1] this method will add a new transaction
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/models/quick_action_model.dart';
import 'package:wallet_app/models/transaction_model.dart';

import '../constants/types.dart';
import '../models/profile_model.dart';
import '../providers/profiles_provider.dart';
import '../providers/quick_actions_provider.dart';
import '../providers/transactions_provider.dart';
import 'general_utils.dart';

Future<void> addTransaction({
  required BuildContext context,
  required String title,
  required String description,
  required TransactionType transactionType,
  required ProfileModel activeProfile,
  required double amount,
}) async {
  try {
    //* here the code for adding a new transaction
    String profileId = Provider.of<ProfilesProvider>(context, listen: false)
        .activatedProfileId;

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
    showSnackBar(context, 'Transaction Added', SnackBarType.success);
    Navigator.pop(context);
  } catch (error) {
    showSnackBar(context, error.toString(), SnackBarType.error);
  }
}

//* 2] this method will add a new quick action
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

//* 3] this method will edit an existing transaction
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

//* 4] this method will edit an existing quick action
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
