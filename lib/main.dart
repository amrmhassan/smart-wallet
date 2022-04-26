// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/authentication_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/profile_details_provider.dart';
import 'package:smart_wallet/providers/synced_data_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/authentication_screen/authentication_screen.dart';
import 'package:smart_wallet/screens/loading_data_screen.dart';
import 'package:smart_wallet/screens/sync_data_screen/sync_data_screen.dart';
import 'package:smart_wallet/tests/testing_widget.dart';
import './providers/quick_actions_provider.dart';
import './providers/transactions_provider.dart';
import 'screens/holder_screen/holder_screen.dart';
import './screens/quick_actions_screen/quick_actions_screen.dart';

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize();
  await Firebase.initializeApp();

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
        ChangeNotifierProvider(create: (ctx) => ThemeProvider()),
        ChangeNotifierProvider(create: (ctx) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (ctx) => ProfilesProvider()),
        ChangeNotifierProvider(create: (ctx) => TransactionProvider()),
        ChangeNotifierProvider(create: (ctx) => QuickActionsProvider()),
        ChangeNotifierProvider(create: (ctx) => SyncedDataProvider()),
        ChangeNotifierProxyProvider2<ProfilesProvider, TransactionProvider,
            ProfileDetailsProvider>(
          create: (
            ctx,
          ) {
            return ProfileDetailsProvider(
              allTransactions: [],
              getProfileById: (String id) {},
            );
          },
          update: (
            ctx,
            profileData,
            transactions,
            oldStatistics,
          ) {
            return ProfileDetailsProvider(
              allTransactions: transactions.transactions,
              getProfileById: profileData.getProfileById,
            );
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: LoadingDataScreen.routeName,
        routes: {
          LoadingDataScreen.routeName: (ctx) => const LoadingDataScreen(),
          HolderScreen.routeName: (ctx) => const HolderScreen(),
          QuickActionsScreen.routeName: (ctx) => const QuickActionsScreen(),
          TestingWidget.routeName: (ctx) => TestingWidget(),
          AuthenticationScreen.routeName: (ctx) => AuthenticationScreen(),
          SyncDataScreen.routeName: (ctx) => SyncDataScreen(),
        },
      ),
    );
  }
}
