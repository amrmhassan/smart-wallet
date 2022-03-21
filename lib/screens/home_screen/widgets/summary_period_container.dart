import 'package:flutter/material.dart';

import 'summary_period_icon.dart';

class SammeryPeriodContainer extends StatefulWidget {
  const SammeryPeriodContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<SammeryPeriodContainer> createState() => _SammeryPeriodContainerState();
}

class _SammeryPeriodContainerState extends State<SammeryPeriodContainer> {
  int _currentActivePeriodIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> summaryPeriodsTypes = [
      {'title': 'D'},
      {'title': 'W'},
      {'title': 'M'},
      {'title': 'Y'},
    ];
    return SizedBox(
      width: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: summaryPeriodsTypes.map((e) {
          int index = summaryPeriodsTypes.indexOf(e);
          return SummaryPeriodIcon(
            title: e['title'],
            onTap: () {
              setState(() {
                _currentActivePeriodIndex = index;
              });
            },
            active: _currentActivePeriodIndex == index,
          );
        }).toList(),
      ),
    );
  }
}
