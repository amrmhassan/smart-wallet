// ignore_for_file: prefer_const_constructors

import 'package:uuid/uuid.dart';
import 'package:wallet_app/constants/types.dart';

import '../models/transaction_model.dart';

List<TransactionModel> transactionsConstant = [
  TransactionModel(
    id: Uuid().v4(),
    title: 'Title 1',
    description: 'description 1',
    amount: 25.66,
    createdAt: DateTime.now(),
    transactionType: TransactionType.income,
    ratioToTotal: 0.3,
  ),
  TransactionModel(
    id: Uuid().v4(),
    title: 'Title 2',
    description: 'description 2',
    amount: 25.66,
    createdAt: DateTime.now(),
    transactionType: TransactionType.outcome,
    ratioToTotal: 0.1,
  ),
  TransactionModel(
    id: Uuid().v4(),
    title: 'Title 1',
    description: 'description 1',
    amount: 25.66,
    createdAt: DateTime.now(),
    transactionType: TransactionType.outcome,
    ratioToTotal: 0.6,
  ),
  TransactionModel(
    id: Uuid().v4(),
    title: 'Title 1',
    description: 'description 1',
    amount: 25.66,
    createdAt: DateTime.now(),
    transactionType: TransactionType.income,
    ratioToTotal: 0.3,
  ),
  TransactionModel(
    id: Uuid().v4(),
    title: 'Title 2',
    description: 'description 2',
    amount: 25.66,
    createdAt: DateTime.now(),
    transactionType: TransactionType.outcome,
    ratioToTotal: 0.1,
  ),
  TransactionModel(
    id: Uuid().v4(),
    title: 'Title 1',
    description: 'description 1',
    amount: 25.66,
    createdAt: DateTime.now(),
    transactionType: TransactionType.outcome,
    ratioToTotal: 0.6,
  ),
  TransactionModel(
    id: Uuid().v4(),
    title: 'Title 1',
    description: 'description 1',
    amount: 25.66,
    createdAt: DateTime.now(),
    transactionType: TransactionType.income,
    ratioToTotal: 0.3,
  ),
  TransactionModel(
    id: Uuid().v4(),
    title: 'Title 2',
    description: 'description 2',
    amount: 25.66,
    createdAt: DateTime.now(),
    transactionType: TransactionType.outcome,
    ratioToTotal: 0.1,
  ),
  TransactionModel(
    id: Uuid().v4(),
    title: 'Title 1',
    description: 'description 1',
    amount: 25.66,
    createdAt: DateTime.now(),
    transactionType: TransactionType.outcome,
    ratioToTotal: 0.6,
  ),
];
