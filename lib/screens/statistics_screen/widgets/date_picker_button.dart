// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/providers/profiles_provider.dart';
import 'package:wallet_app/providers/statistics_provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

enum DateTypes { startDate, endDate }

class DatePickerButton extends StatelessWidget {
  final DateTypes dateType;

  const DatePickerButton({
    Key? key,
    required this.dateType,
  }) : super(key: key);

  Future<void> pickCustomDate(BuildContext context) async {
    DateTime firstDate = Provider.of<ProfilesProvider>(context, listen: false)
        .getActiveProfile
        .createdAt;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );
    //* returning if the user didn't choose any date
    if (pickedDate == null) {
      return;
    }
    //* setting the date
    if (dateType == DateTypes.startDate) {
      Provider.of<StatisticsProvider>(context, listen: false)
          .setDatesPeriod(newStartingDate: pickedDate, update: true);
    } else if (dateType == DateTypes.endDate) {
      Provider.of<StatisticsProvider>(context, listen: false)
          .setDatesPeriod(newEndDate: pickedDate, update: true);
    }
    Provider.of<StatisticsProvider>(context, listen: false)
        .setPeriod(TransPeriod.custom);

    //? here setting the starting or ending date
  }

  @override
  Widget build(BuildContext context) {
    DateTime rawDate = dateType == DateTypes.startDate
        ? Provider.of<StatisticsProvider>(context).startingDate
        : Provider.of<StatisticsProvider>(context).endDate;
    String formattedDate = DateFormat('yyyy-MM-dd').format(rawDate);

    return GestureDetector(
      onTap: () async => await pickCustomDate(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding / 5,
        ),
        alignment: Alignment.center,
        width: 90,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                Provider.of<StatisticsProvider>(context).currentActivePeriod ==
                        TransPeriod.custom
                    ? kMainColor
                    : kInactiveColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(kDefaultBorderRadius / 4),
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            formattedDate,
            style: TextStyle(
              color: kMainColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
