import 'package:wallet_app/constants/types.dart';

class QuickAction {
  String id;
  String title;
  String description;
  DateTime createdAt;
  double amount;
  TransactionType transactionType;

  QuickAction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.transactionType,
  });
}
