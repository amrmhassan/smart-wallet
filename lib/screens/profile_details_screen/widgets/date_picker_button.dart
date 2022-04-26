import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/profile_details_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

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
        .getActiveProfile()
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
      Provider.of<ProfileDetailsProvider>(context, listen: false)
          .setDatesPeriod(newStartingDate: pickedDate, update: true);
    } else if (dateType == DateTypes.endDate) {
      Provider.of<ProfileDetailsProvider>(context, listen: false)
          .setDatesPeriod(newEndDate: pickedDate, update: true);
    }
    Provider.of<ProfileDetailsProvider>(context, listen: false)
        .setPeriod(TransPeriod.custom);

    //? here setting the starting or ending date
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    DateTime rawDate = dateType == DateTypes.startDate
        ? Provider.of<ProfileDetailsProvider>(context).startingDate
        : Provider.of<ProfileDetailsProvider>(context).endDate;
    String formattedDate = DateFormat('yyyy-MM-dd').format(rawDate);

    return GestureDetector(
      onTap: () async => await pickCustomDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding / 5,
        ),
        alignment: Alignment.center,
        width: 90,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(
            color: Provider.of<ProfileDetailsProvider>(context)
                        .currentActivePeriod ==
                    TransPeriod.custom
                ? themeProvider.getThemeColor(ThemeColors.kMainColor)
                : themeProvider.getThemeColor(ThemeColors.kInactiveColor),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(kDefaultBorderRadius / 4),
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            formattedDate,
            style: TextStyle(
              color: themeProvider.getThemeColor(ThemeColors.kMainColor),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
