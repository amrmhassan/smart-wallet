import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/statistics_provider.dart';

import 'summary_period_icon.dart';

class SammeryPeriodContainer extends StatefulWidget {
  const SammeryPeriodContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<SammeryPeriodContainer> createState() => _SammeryPeriodContainerState();
}

class _SammeryPeriodContainerState extends State<SammeryPeriodContainer> {
  void setPeriod(TransPeriod transPeriod) {
    Provider.of<StatisticsProvider>(
      context,
      listen: false,
    ).setPeriod(transPeriod);
  }

  @override
  Widget build(BuildContext context) {
    TransPeriod currenActivePeriod =
        Provider.of<StatisticsProvider>(context).currentActivePeriod;
    int profileAgeInDays = Provider.of<ProfilesProvider>(
      context,
      listen: false,
    ).getProfileAgeInDays();

    List<PeriodIcon> periodIcons = [
      const PeriodIcon(
        transPeriod: TransPeriod.today,
        letter: 'D',
        showFrom: 0,
      ),
      const PeriodIcon(
        transPeriod: TransPeriod.week,
        letter: 'W',
        showFrom: 1,
      ),
      const PeriodIcon(
        transPeriod: TransPeriod.month,
        letter: 'M',
        showFrom: 8,
      ),
      const PeriodIcon(
        transPeriod: TransPeriod.all,
        letter: 'A',
        showFrom: 0,
      ),
    ];
    return SizedBox(
      width: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: periodIcons.map((e) {
          return SummaryPeriodIcon(
            title: e.letter,
            onTap: () => setPeriod(e.transPeriod),
            active: currenActivePeriod == e.transPeriod,
            enabled: profileAgeInDays >= e.showFrom,
          );
        }).toList(),
      ),
    );
  }
}

class PeriodIcon {
  final TransPeriod transPeriod;
  final String letter;
  final double showFrom;

  const PeriodIcon({
    required this.transPeriod,
    required this.letter,
    required this.showFrom,
  });
}
