// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:smart_wallet/constants/db_constants.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/helpers/db_helper.dart';
import 'package:smart_wallet/models/debt_model.dart';
import 'package:uuid/uuid.dart';

class DebtsProvider extends ChangeNotifier {
  List<DebtModel> _debts = [];

  List<DebtModel> get debts {
    return _debts
        .where((debt) => debt.deleted == false)
        .toList()
        .reversed
        .toList();
  }

  Future<void> fetchAndUpdateDebts() async {
    try {
      List<Map<String, dynamic>> data = await DBHelper.getData(debtsTableName);
      List<DebtModel> fetchDebts = data.map(
        (debt) {
          return DebtModel.fromJSON(debt);
        },
      ).toList();

      fetchDebts.sort((a, b) {
        return a.createdAt.difference(b.createdAt).inSeconds;
      });
      _debts = fetchDebts;
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }
    notifyListeners();
  }

  Future<void> addDebt(
      String title, double amount, String borrowingProfileId) async {
    String id = Uuid().v4();
    DateTime createdAt = DateTime.now();
    DebtModel debtModel = DebtModel(
      id: id,
      title: title,
      amount: amount,
      createdAt: createdAt,
      borrowingProfileId: borrowingProfileId,
    );

    //* here i will add the new debt to the database
    try {
      await DBHelper.insert(debtsTableName, debtModel.toJSON());
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }

    _debts.add(debtModel);

    notifyListeners();
  }

  DebtModel getDebtById(String id) {
    return _debts.firstWhere((element) => element.id == id);
  }

  Future<void> fulfilDebt(String debtId, String fulfillingProfileId) async {
    return editDebt(
        id: debtId, fulfilled: true, fullfillingProfileId: fulfillingProfileId);
  }

  Future<void> deleteDebt(String id) async {
    DebtModel deletedDebt = getDebtById(id);

    if (deletedDebt.syncFlag == SyncFlags.add) {
      return editDebt(id: id, deleted: true);
    } else {
      return editDebt(
        id: id,
        syncFlags: SyncFlags.delete,
        deleted: true,
      );
    }
  }

  Future<void> editDebt({
    required String id,
    double? amount,
    String? borrowingProfileId,
    bool? deleted,
    String? fullfillingProfileId,
    SyncFlags? syncFlags,
    bool? fulfilled,
    String? title,
  }) async {
    //* returning if no thing is edited
    if (title == null &&
        amount == null &&
        borrowingProfileId == null &&
        deleted == null &&
        fullfillingProfileId == null &&
        syncFlags == null &&
        fulfilled == null) {
      return;
    }
    DebtModel debtModel = getDebtById(id);
    //? if debt is fulfilled, it can't be changed, nor deleted
    if (debtModel.fulFilled) {
      CustomError.log(
          error: 'You can\'t edit a fulfilled debt', rethrowError: true);
    }

    String newTitle = title ?? debtModel.title;
    DateTime newCreatedAt = debtModel.createdAt;
    double newAmount = amount ?? debtModel.amount;
    String newBorrowingProfileId =
        borrowingProfileId ?? debtModel.borrowingProfileId;
    bool newDeleted = deleted ?? debtModel.deleted;
    String? newFullfillingProfileId =
        fullfillingProfileId ?? debtModel.fullfillingProfileId;
    SyncFlags newSyncFlag = syncFlags ??
        (debtModel.syncFlag == SyncFlags.add ? SyncFlags.add : SyncFlags.edit);

    bool newFulfilled = fulfilled ?? debtModel.fulFilled;
    DebtModel editedDebt = DebtModel(
      id: id,
      title: newTitle,
      createdAt: newCreatedAt,
      amount: newAmount,
      borrowingProfileId: newBorrowingProfileId,
      deleted: newDeleted,
      fulFilled: newFulfilled,
      fullfillingProfileId: newFullfillingProfileId,
      syncFlag: newSyncFlag,
      userId: debtModel.userId,
    );
    try {
      await DBHelper.insert(debtsTableName, editedDebt.toJSON());
      int index = _debts.indexOf(debtModel);
      _debts.removeAt(index);

      _debts.insert(index, editedDebt);
      notifyListeners();
    } catch (error) {
      CustomError.log(error: error, rethrowError: true);
    }
  }
}
