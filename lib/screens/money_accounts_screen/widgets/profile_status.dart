import 'package:flutter/material.dart';

import '../../../constants/profiles.dart';
import '../../../constants/styles.dart';

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
    } else {
      return 'Critical';
    }
  }

  @override
  Widget build(BuildContext context) {
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
        style: kWhiteProfileStatusTextStyle,
      ),
    );
  }
}
