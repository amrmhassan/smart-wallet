// ignore_for_file: prefer_const_constructors

import 'package:uuid/uuid.dart';
import 'package:wallet_app/models/profile_model.dart';

enum MoneyAccountStatus {
  empty,
  good,
  moderate,
  critical,
}

ProfileModel defaultProfile = ProfileModel(
  id: Uuid().v4(),
  name: 'Default Money Profile',
  income: 0,
  outcome: 0,
  createdAt: DateTime.now(),
);

List<ProfileModel> dummyProfiles = [
  ProfileModel(
    id: Uuid().v4(),
    name: 'Suez Account',
    income: 600,
    outcome: 200,
    createdAt: DateTime.now().subtract(Duration(days: 10)),
  ),
  ProfileModel(
    id: Uuid().v4(),
    name: 'Private Account',
    income: 200,
    outcome: 200,
    activated: true,
    createdAt: DateTime.now().subtract(Duration(days: 100)),
  ),
  ProfileModel(
    id: Uuid().v4(),
    name: 'Marsafa Account',
    income: 250,
    outcome: 200,
    createdAt: DateTime.now().subtract(Duration(days: 365)),
  ),
];
