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
  bool deleted;
  SyncFlags syncFlag;

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
    this.deleted = false,
    this.syncFlag = SyncFlags.none,
  });

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'createdAt': createdAt,
      'transactionType': transactionType.name,
      'isFavorite': isFavorite,
      'profileId': profileId,
      'quickActionIndex': quickActionIndex,
      'userId': userId,
      'deleted': deleted,
    };
  }
}
