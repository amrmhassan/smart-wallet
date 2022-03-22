import 'package:wallet_app/constants/types.dart';

class TransactionModel {
  String id;
  String title;
  String description;
  DateTime createdAt;
  double amount;
  TransactionType transactionType;
  //* this property i will need to provide the ratio of this transaction to the total amount of money i have right now in this profile
  double ratioToTotal;

  TransactionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.transactionType,
    required this.ratioToTotal,
  });
}
