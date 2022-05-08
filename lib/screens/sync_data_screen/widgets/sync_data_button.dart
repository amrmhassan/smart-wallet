// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/providers/user_prefs_provider.dart';

class SyncDataButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool syncing;
  final bool online;

  bool enableButton(BuildContext context) {
    return !syncing && enableSyncButton(context) && online;
  }

  const SyncDataButton({
    Key? key,
    required this.onTap,
    required this.syncing,
    required this.online,
  }) : super(key: key);

  bool enableSyncButton(BuildContext context) {
    var profiles =
        Provider.of<ProfilesProvider>(context, listen: false).notSyncedProfiles;
    var transactions = Provider.of<TransactionProvider>(context, listen: false)
        .notSyncedTransactions;
    var quickActions = Provider.of<QuickActionsProvider>(context, listen: false)
        .notSyncedQuickActions;
    var userPrefsNeedSyncing =
        Provider.of<UserPrefsProvider>(context, listen: false)
            .userPrefsNeedSyncing;

    return profiles.isNotEmpty ||
        transactions.isNotEmpty ||
        quickActions.isNotEmpty ||
        userPrefsNeedSyncing;
  }

  bool allDataSynced(BuildContext context) {
    var profiles =
        Provider.of<ProfilesProvider>(context, listen: false).notSyncedProfiles;
    var transactions = Provider.of<TransactionProvider>(context, listen: false)
        .notSyncedTransactions;
    var quickActions = Provider.of<QuickActionsProvider>(context, listen: false)
        .notSyncedQuickActions;

    return profiles.isEmpty && transactions.isEmpty && quickActions.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: enableButton(context)
              ? themeProvider.getThemeColor(ThemeColors.kActiveButtonColor)
              : themeProvider.getThemeColor(ThemeColors.kCardBackgroundColor),
          borderRadius: BorderRadius.circular(kDefaultBorderRadius / 4),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enableButton(context) ? onTap : null,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 3),
              alignment: Alignment.center,
              child: Text(
                syncing
                    ? 'Syncing...'
                    : allDataSynced(context)
                        ? 'Data Synced'
                        : 'Sync Data',
                style: enableButton(context)
                    ? themeProvider
                        .getTextStyle(ThemeTextStyles.kActivateProfileTextStyle)
                    : themeProvider.getTextStyle(
                        ThemeTextStyles.kActivatedProfileTextStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
