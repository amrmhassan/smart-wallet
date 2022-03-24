import 'package:wallet_app/constants/types.dart';

class QuickActionModel {
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
}
