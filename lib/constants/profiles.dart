// ignore_for_file: prefer_const_constructors

import 'package:uuid/uuid.dart';

enum MoneyAccountStatus {
  good,
  moderate,
  critical,
}

List<Map<String, dynamic>> profiles = [
  {
    'id': Uuid().v4(),
    'name': 'My main account Money',
    'status': MoneyAccountStatus.good,
    'incomePercent': 0.75,
    'income': 600,
    'outcome': 200,
    'currentMoney': 400,
  },
  {
    'id': Uuid().v4(),
    'name': 'My main account Money',
    'status': MoneyAccountStatus.moderate,
    'income': 200,
    'outcome': 200,
    'currentMoney': 0,
  },
  {
    'id': Uuid().v4(),
    'name': 'My main account Money',
    'status': MoneyAccountStatus.critical,
    'income': 100,
    'outcome': 200,
    'currentMoney': -100,
  },
];
