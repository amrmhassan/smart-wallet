import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:wallet_app/constants/db_constants.dart';
import 'package:wallet_app/constants/types.dart';
import 'package:wallet_app/helpers/db_helper.dart';

class QuickActionModel extends ChangeNotifier {
  String id;
  String title;
  String description;
  double amount;
  DateTime createdAt;
  TransactionType transactionType;
  bool isFavorite;

  QuickActionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.transactionType,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    //* update it on the provider
    isFavorite = !isFavorite;
    notifyListeners();

    //* update it on the database
    try {
      await DBHelper.insert(quickActionsTableName, {
        'id': id,
        'title': title,
        'description': description,
        'amount': amount.toString(),
        'createdAt': createdAt.toIso8601String(),
        'transactionType':
            transactionType == TransactionType.income ? 'income' : 'outcome',
        'isFavorite': (!isFavorite).toString(),
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error loving the quick Action , check the quickAction provider');
      }
      rethrow;
    }
  }
}
