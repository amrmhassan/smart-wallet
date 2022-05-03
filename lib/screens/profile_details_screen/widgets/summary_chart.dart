// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/models/transaction_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_wallet/utils/charts_utils.dart';
import 'package:smart_wallet/constants/sizes.dart';

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
  ProfileDetailsChartTypes activeChartType = ProfileDetailsChartTypes.savings;

  void setActiveChartType(ProfileDetailsChartTypes active) {
    setState(() {
      activeChartType = active;
    });
  }

  List<CustomChartData> getViewedData() {
    //? here swap the data when changing the active chart data
    return TransactionsDatesUtils(
      transactions: widget.profileTransactions,
      firstDate: widget.profile.createdAt,
    ).getTotalSavingsData();
  }

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
          ChartTypesFilter(),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              tooltipBehavior: _tooltipBehavior,
              series: <SplineSeries<CustomChartData, String>>[
                SplineSeries<CustomChartData, String>(
                  dataSource: getViewedData(),
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

class ChartTypesFilter extends StatelessWidget {
  const ChartTypesFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ChartTypeElement(
          title: 'Savings',
          active: true,
        ),
        ChartTypeElement(
          title: 'Income',
          active: false,
        ),
        ChartTypeElement(
          title: 'Outcome',
          active: false,
        ),
      ],
    );
  }
}

class ChartTypeElement extends StatelessWidget {
  final String title;
  final bool active;
  const ChartTypeElement({
    Key? key,
    required this.title,
    required this.active,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Text(
      title,
      style: active
          ? themeProvider
              .getTextStyle(ThemeTextStyles.kSmallTextPrimaryColorStyle)
          : themeProvider.getTextStyle(
              ThemeTextStyles.kSmallInActiveParagraphTextStyle,
            ),
    );
  }
}
