import 'package:uuid/uuid.dart';
import 'package:smart_wallet/models/profile_model.dart';

enum MoneyAccountStatus {
  empty,
  good,
  moderate,
  critical,
}

ProfileModel defaultProfile = ProfileModel(
  id: const Uuid().v4(),
  name: 'Pro 1',
  income: 0,
  outcome: 0,
  createdAt: DateTime.now(),
);

List<ProfileModel> dummyProfiles = [
  ProfileModel(
    id: const Uuid().v4(),
    name: 'Suez Account',
    income: 600,
    outcome: 200,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
  ),
  ProfileModel(
    id: const Uuid().v4(),
    name: 'Private Account',
    income: 200,
    outcome: 200,
    activated: true,
    createdAt: DateTime.now().subtract(const Duration(days: 100)),
  ),
  ProfileModel(
    id: const Uuid().v4(),
    name: 'Marsafa Account',
    income: 250,
    outcome: 200,
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
  ),
];
