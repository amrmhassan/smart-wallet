import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/models/transaction_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/utils/charts_utils.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';

import '../../../providers/theme_provider.dart';

class SummaryChart extends StatefulWidget {
  final ProfileModel profile;
  final List<TransactionModel> profileTransactions;
  const SummaryChart({
    Key? key,
    required this.profile,
    required this.profileTransactions,
  }) : super(key: key);

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
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: themeProvider.getThemeColor(ThemeColors.kCardBackgroundColor),
        borderRadius: BorderRadius.circular(kDefaultBorderRadius / 2),
        boxShadow: [
          themeProvider.getBoxShadow(ThemeBoxShadow.kDefaultBoxShadow),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Income',
                style: themeProvider.getTextStyle(
                  ThemeTextStyles.kSmallInActiveParagraphTextStyle,
                ),
              ),
              Text(
                'Outcome',
                style: themeProvider.getTextStyle(
                  ThemeTextStyles.kSmallInActiveParagraphTextStyle,
                ),
              ),
              Text(
                'Savings',
                style: themeProvider.getTextStyle(
                  ThemeTextStyles.kSmallInActiveParagraphTextStyle,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              tooltipBehavior: _tooltipBehavior,
              series: <SplineSeries<CustomChartData, String>>[
                SplineSeries<CustomChartData, String>(
                  dataSource: TransactionsDatesUtils(
                    transactions: widget.profileTransactions,
                    firstDate: widget.profile.createdAt,
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
