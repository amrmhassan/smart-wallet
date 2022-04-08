import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/profiles_constants.dart';
import '../../../providers/theme_provider.dart';

class ProfileStatus extends StatelessWidget {
  final MoneyAccountStatus moneyAccountStatus;
  final Color profileStatusColor;
  const ProfileStatus({
    Key? key,
    required this.moneyAccountStatus,
    required this.profileStatusColor,
  }) : super(key: key);

  String get statusText {
    if (moneyAccountStatus == MoneyAccountStatus.good) {
      return 'Good';
    } else if (moneyAccountStatus == MoneyAccountStatus.moderate) {
      return 'Moderate';
    } else if (moneyAccountStatus == MoneyAccountStatus.critical) {
      return 'Critical';
    } else {
      return 'Empty';
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      alignment: Alignment.center,
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: profileStatusColor,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Text(
        statusText,
        style: themeProvider
            .getTextStyle(ThemeTextStyles.kWhiteProfileStatusTextStyle),
      ),
    );
  }
}
