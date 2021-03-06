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
  name: 'Default Profile',
  createdAt: DateTime.now(),
);
