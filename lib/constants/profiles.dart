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
);

List<ProfileModel> profilesConstant = [
  ProfileModel(
    id: Uuid().v4(),
    name: 'Empty Account',
    income: 0,
    outcome: 0,
  ),
  ProfileModel(
    id: Uuid().v4(),
    name: 'Suez Account',
    income: 600,
    outcome: 200,
  ),
  ProfileModel(
    id: Uuid().v4(),
    name: 'Private Account',
    income: 200,
    outcome: 200,
    activated: true,
  ),
  ProfileModel(
    id: Uuid().v4(),
    name: 'Marsafa Account',
    income: 250,
    outcome: 200,
  ),
];
