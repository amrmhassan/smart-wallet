// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/models/transaction_model.dart';
import 'package:smart_wallet/screens/profile_details_screen/widgets/chart_type_filters.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_wallet/utils/charts_utils.dart';
import 'package:smart_wallet/constants/sizes.dart';

import '../../../providers/theme_provider.dart';

class SummaryChart extends StatefulWidget {
  final ProfileModel profile;
  final List<TransactionModel> profileTransactions;
  final bool showChart;
  final List<CustomChartData> chartData;
  final CustomChartType activeChartType;
  final void Function(CustomChartType chartType) setActiveChartType;

  const SummaryChart(
      {Key? key,
      required this.profile,
      required this.profileTransactions,
      required this.showChart,
      required this.chartData,
      required this.activeChartType,
      required this.setActiveChartType})
      : super(key: key);

  @override
  State<SummaryChart> createState() => _SummaryChartState();
}

class _SummaryChartState extends State<SummaryChart> {
  TooltipBehavior? _tooltipBehavior;
  ProfileDetailsChartTypes activeChartType = ProfileDetailsChartTypes.savings;
  //* this var is used to show the chart if there is 2 days of usage or not
  //* it must be true at first
  bool manyData = true;

  // void setActiveChartType(ProfileDetailsChartTypes active) {
  //   setState(() {
  //     activeChartType = active;
  //   });
  // }

  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return widget.showChart && manyData
        ? Container(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultHorizontalPadding,
              vertical: kDefaultVerticalPadding,
            ),
            decoration: BoxDecoration(
              color:
                  themeProvider.getThemeColor(ThemeColors.kCardBackgroundColor),
              borderRadius: BorderRadius.circular(kDefaultBorderRadius / 2),
              boxShadow: [
                themeProvider.getBoxShadow(ThemeBoxShadow.kDefaultBoxShadow),
              ],
            ),
            child: Column(
              children: [
                ChartTypesFilter(
                  activeChartType: widget.activeChartType,
                  setActiveChartType: widget.setActiveChartType,
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
                        dataSource: widget.chartData,
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
          )
        : Container(
            alignment: Alignment.center,
            child: Text(
              'A stat chart will be here after 2 days of usage',
              style: themeProvider
                  .getTextStyle(ThemeTextStyles.kInActiveParagraphTextStyle),
            ),
          );
  }
}
