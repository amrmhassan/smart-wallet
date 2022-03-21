import 'package:wallet_app/constants/types.dart';

class TransactionModel {
  String id;
  String title;
  String description;
  DateTime createdAt;
  double amount;
  TransactionType transactionType;

  TransactionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.transactionType,
  });
}
