import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/profile_details_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/loading_data_screen.dart';
import './providers/quick_actions_provider.dart';
import './providers/transactions_provider.dart';
import './screens/holder_screen.dart';
import './screens/quick_actions_screen/quick_actions_screen.dart';

void main() {
  runApp(Phoenix(child: const MyApp()));
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
            ProfileDetailsProvider>(
          create: (
            ctx,
          ) {
            return ProfileDetailsProvider(
              getTransactionsByProfileId: (String id) {},
              getProfileById: (String id) {},
            );
          },
          update: (
            ctx,
            transactions,
            profileData,
            oldStatistics,
          ) {
            return ProfileDetailsProvider(
              getTransactionsByProfileId:
                  transactions.getTransactionsByProfileId,
              getProfileById: profileData.getProfileById,
            );
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) => ThemeProvider(),
        )
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
