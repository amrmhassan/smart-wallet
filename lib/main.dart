import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/statistics_provider.dart';
import 'package:smart_wallet/screens/loading_data_screen.dart';
import './providers/quick_actions_provider.dart';
import './providers/transactions_provider.dart';
import './screens/holder_screen.dart';
import './screens/quick_actions_screen/quick_actions_screen.dart';

void main() {
  runApp(const MyApp());
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
          HolderScreen.routeName: (ctx) => const HolderScreen(),
          QuickActionsScreen.routeName: (ctx) => const QuickActionsScreen(),
          LoadingDataScreen.routeName: (ctx) => const LoadingDataScreen(),
        },
      ),
    );
  }
}
