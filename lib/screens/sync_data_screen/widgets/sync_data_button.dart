// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';

class SyncDataButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool syncing;

  const SyncDataButton({
    Key? key,
    required this.onTap,
    required this.syncing,
  }) : super(key: key);

  bool enableSyncButton(BuildContext context) {
    var profiles =
        Provider.of<ProfilesProvider>(context, listen: false).notSyncedProfiles;
    var transactions = Provider.of<TransactionProvider>(context, listen: false)
        .notSyncedTransactions;
    var quickActions = Provider.of<QuickActionsProvider>(context, listen: false)
        .notSyncedQuickActions;

    return profiles.isNotEmpty ||
        transactions.isNotEmpty ||
        quickActions.isNotEmpty;
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
          color: themeProvider.getThemeColor(ThemeColors.kButtonColor),
          borderRadius: BorderRadius.circular(kDefaultBorderRadius / 4),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (syncing || !enableSyncButton(context)) ? null : onTap,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 3),
              alignment: Alignment.center,
              child: Text(
                syncing ? 'Syncing...' : 'Sync Data',
                style: themeProvider
                    .getTextStyle(ThemeTextStyles.kActivateProfileTextStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
