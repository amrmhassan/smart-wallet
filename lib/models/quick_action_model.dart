import '../constants/types.dart';

class QuickActionModel {
  String id;
  String title;
  String description;
  double amount;
  DateTime createdAt;
  TransactionType transactionType;
  bool isFavorite;
  int? quickActionIndex;
  String? userId;
  String profileId;
  bool needSync;

  QuickActionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.transactionType,
    this.isFavorite = false,
    required this.profileId,
    this.quickActionIndex,
    this.userId,
    this.needSync = true,
  });
}
