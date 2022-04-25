import 'package:smart_wallet/constants/profiles_constants.dart';
import 'package:smart_wallet/constants/types.dart';

const double _goodLimit = .70; // when it is from 70% to 100% it will be good
const double _moderateLimit =
    .55; // when it is from 55% to 70% it will be moderate

class ProfileModel {
  String id;
  String name;
  double income;
  double outcome;
  DateTime createdAt;
  DateTime? lastActivatedDate;
  String? userId;
  SyncFlags syncFlag;
  bool deleted;

  late MoneyAccountStatus moneyAccountStatus;
  late double totalMoney;
  late double incomeRatio;

  ProfileModel({
    required this.id,
    required this.name,
    required this.income,
    required this.outcome,
    required this.createdAt,
    this.lastActivatedDate,
    this.userId,
    this.syncFlag = SyncFlags.none,
    this.deleted = false,
  }) {
    //? for setting the total money
    //* the total money equals to income - outcome
    totalMoney = income - outcome;
    //* the incomeRatio may have 3 outcomes
    //* 1] income higher than the outcome
    //* -- a] the ratio will be greater than 0.6 => good
    //* -- b] the ratio will be between 0.5 and 0.6 => moderate
    //* 2] income is lower than outcome (totalMoney will be negative) => critical
    //? for setting the incomeRatio
    incomeRatio = income / (outcome + income);
    //? for setting the moneyAccountStatus
    if (income == 0 && outcome == 0) {
      moneyAccountStatus = MoneyAccountStatus.empty;
    } else if (incomeRatio >= _goodLimit) {
      moneyAccountStatus = MoneyAccountStatus.good;
    } else if (incomeRatio > _moderateLimit && incomeRatio < _goodLimit) {
      moneyAccountStatus = MoneyAccountStatus.moderate;
    } else {
      moneyAccountStatus = MoneyAccountStatus.critical;
    }
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'income': income,
      'outcome': outcome,
      'createdAt': createdAt.toIso8601String(),
      'lastActivatedDate': lastActivatedDate == null
          ? 'null'
          : lastActivatedDate!.toIso8601String(),
      'userId': userId,
      'deleted': deleted,
      'syncFlag': syncFlag.name,
    };
  }

  ProfileModel fromJSON(Map<String, dynamic> profileJSON) {
    String idJ = profileJSON['id'];
    String nameJ = profileJSON['name'];
    double incomeJ = profileJSON['income'];
    double outcomeJ = profileJSON['outcome'];
    DateTime createdAtJ = profileJSON['createdAt'];
    DateTime? lastActivatedDateJ = profileJSON['lastActivatedDate'];
    String? userIdJ = profileJSON['userId'];
    bool deletedJ = profileJSON['deleted'];
    SyncFlags syncFlagsJ = profileJSON['syncFlag'];

    return ProfileModel(
      id: idJ,
      name: nameJ,
      income: incomeJ,
      outcome: outcomeJ,
      createdAt: createdAtJ,
      deleted: deletedJ,
      lastActivatedDate: lastActivatedDateJ,
      userId: userIdJ,
      syncFlag: syncFlagsJ,
    );
  }
}
