import '../constants/types.dart';

//! remove the needSync property from the transaction model and it's followers
class TransactionModel {
  String id;
  String title;
  String description;
  DateTime createdAt;
  double amount;
  TransactionType transactionType;
  //* this property i will need to provide the ratio of this transaction to the total amount of money i have right now in this profile
  double ratioToTotal;
  String profileId;
  String? userId;
  bool deleted;
  SyncFlags syncFlag;

  TransactionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.transactionType,
    required this.ratioToTotal,
    required this.profileId,
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
      'ratioToTotal': ratioToTotal,
      'profileId': profileId,
      'userId': userId,
      'deleted': deleted,
    };
  }
}
