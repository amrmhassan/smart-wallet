// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wallet_app/providers/profiles_provider.dart';
import 'package:wallet_app/utils/charts_utils.dart';
import 'package:wallet_app/constants/sizes.dart';
import 'package:wallet_app/providers/transactions_provider.dart';

import '../../../constants/styles.dart';

class SummaryChart extends StatefulWidget {
  const SummaryChart({Key? key}) : super(key: key);

  @override
  State<SummaryChart> createState() => _SummaryChartState();
}

class _SummaryChartState extends State<SummaryChart> {
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius / 2),
        boxShadow: [
          kDefaultBoxShadow,
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Income'),
              Text('Outcone'),
              Text('Savings'),
            ],
          ),
          SizedBox(
            height: kDefaultPadding / 2,
          ),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              tooltipBehavior: _tooltipBehavior,
              series: <SplineSeries<CustomChartData, String>>[
                SplineSeries<CustomChartData, String>(
                  dataSource: TransactionsDatesUtils(
                    transactions: Provider.of<TransactionProvider>(
                      context,
                      listen: false,
                    ).getAllTransactions,
                    firstDate: Provider.of<ProfilesProvider>(
                      context,
                      listen: false,
                    ).getActiveProfile.createdAt,
                  ).getTotalSavingsData(),
                  xValueMapper: (CustomChartData chartData, ctx) =>
                      chartData.date,
                  yValueMapper: (CustomChartData chartData, _) =>
                      chartData.amount,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
