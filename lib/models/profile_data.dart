import 'package:smart_wallet/constants/profiles_constants.dart';
import 'package:smart_wallet/models/profile_model.dart';

class ProfilesData {
  late String profileId;
  final ProfileModel profileModel;
  final double totalMoney;
  final double income;
  final double outcome;
  final MoneyAccountStatus moneyAccountStatus;
  final double incomeRatio;

  ProfilesData({
    required this.income,
    required this.profileModel,
    required this.totalMoney,
    required this.outcome,
    required this.incomeRatio,
    required this.moneyAccountStatus,
  }) {
    profileId = profileModel.id;
  }
}
