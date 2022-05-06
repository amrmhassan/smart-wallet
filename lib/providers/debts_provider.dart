// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:smart_wallet/constants/db_constants.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/helpers/db_helper.dart';
import 'package:smart_wallet/models/debt_model.dart';
import 'package:uuid/uuid.dart';

class DebtsProvider extends ChangeNotifier {
  List<DebtModel> _debts = [];
  List<DebtModel> get debts {
    return [..._debts].reversed.toList();
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

    //* here i will add the new transaction to the database
    try {
      await DBHelper.insert(debtsTableName, debtModel.toJSON());
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }

    _debts.add(debtModel);

    notifyListeners();
  }
}
