// ignore_for_file: prefer_const_constructors

import 'package:uuid/uuid.dart';

import '../models/transaction_model.dart';
import 'types.dart';

List<TransactionModel> dummyTransactions = [
  TransactionModel(
    id: Uuid().v4(),
    title: 'title',
    description: 'description',
    amount: 200,
    createdAt: DateTime.now().subtract(Duration(days: 0)),
    transactionType: TransactionType.income,
    ratioToTotal: 0,
    profileId: '0',
  ),
  TransactionModel(
    id: Uuid().v4(),
    title: 'title',
    description: 'description',
    amount: 130,
    createdAt: DateTime.now().subtract(Duration(days: 0)),
    transactionType: TransactionType.income,
    ratioToTotal: 0,
    profileId: '0',
  ),
  TransactionModel(
    id: Uuid().v4(),
    title: 'title',
    description: 'description',
    amount: 200,
    createdAt: DateTime.now().subtract(Duration(days: 0)),
    transactionType: TransactionType.outcome,
    ratioToTotal: 0,
    profileId: '0',
  ),
  //************************************************** */ 130
  TransactionModel(
    id: Uuid().v4(),
    title: 'title',
    description: 'description',
    amount: 300,
    createdAt: DateTime.now().subtract(Duration(days: 1)),
    transactionType: TransactionType.income,
    ratioToTotal: 0,
    profileId: '0',
  ),
  TransactionModel(
    id: Uuid().v4(),
    title: 'title',
    description: 'description',
    amount: 200,
    createdAt: DateTime.now().subtract(Duration(days: 1)),
    transactionType: TransactionType.income,
    ratioToTotal: 0,
    profileId: '0',
  ),
  TransactionModel(
    id: Uuid().v4(),
    title: 'title',
    description: 'description',
    amount: 100,
    createdAt: DateTime.now().subtract(Duration(days: 1)),
    transactionType: TransactionType.outcome,
    ratioToTotal: 0,
    profileId: '0',
  ),
  //************************************************** */ 400
  TransactionModel(
    id: Uuid().v4(),
    title: 'title',
    description: 'description',
    amount: 500,
    createdAt: DateTime.now().subtract(Duration(days: 2)),
    transactionType: TransactionType.income,
    ratioToTotal: 0,
    profileId: '0',
  ),
  TransactionModel(
    id: Uuid().v4(),
    title: 'title',
    description: 'description',
    amount: 200,
    createdAt: DateTime.now().subtract(Duration(days: 2)),
    transactionType: TransactionType.income,
    ratioToTotal: 0,
    profileId: '0',
  ),
  TransactionModel(
    id: Uuid().v4(),
    title: 'title',
    description: 'description',
    amount: 200,
    createdAt: DateTime.now().subtract(Duration(days: 2)),
    transactionType: TransactionType.outcome,
    ratioToTotal: 0,
    profileId: '0',
  ),
  //************************************************** */ 500
];
