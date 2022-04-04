// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/providers/profiles_provider.dart';
import 'package:wallet_app/providers/statistics_provider.dart';
import 'package:wallet_app/screens/loading_data_screen.dart';
import './providers/quick_actions_provider.dart';
import './providers/transactions_provider.dart';
import './screens/holder_screen.dart';
import './screens/quick_actions_screen/quick_actions_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => TransactionProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => QuickActionsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProfilesProvider(),
        ),
        ChangeNotifierProxyProvider2<TransactionProvider, ProfilesProvider,
            StatisticsProvider>(
          create: (
            ctx,
          ) {
            return StatisticsProvider(
              allProfileTransactions: [],
              currentActivePeriod: TransPeriod.today,
              activeProfile: null,
            );
          },
          update: (
            ctx,
            transactions,
            profileData,
            oldStatistics,
          ) {
            return StatisticsProvider(
              allProfileTransactions: transactions.getAllTransactions,
              currentActivePeriod: oldStatistics == null
                  ? TransPeriod.today
                  : oldStatistics.currentActivePeriod,
              activeProfile: profileData.getActiveProfile,
            );
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: LoadingDataScreen.routeName,
        routes: {
          HolderScreen.routeName: (ctx) => HolderScreen(),
          QuickActionsScreen.routeName: (ctx) => QuickActionsScreen(),
          LoadingDataScreen.routeName: (ctx) => LoadingDataScreen(),
        },
      ),
    );
  }
}
