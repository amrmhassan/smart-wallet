// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/models/quick_action_model.dart';
import 'package:smart_wallet/models/transaction_model.dart';
import 'package:smart_wallet/providers/profile_details_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/user_prefs_provider.dart';
import 'package:smart_wallet/screens/home_screen/widgets/background.dart';
import 'package:smart_wallet/screens/profile_details_screen/widgets/delete_profile_icon.dart';
import 'package:smart_wallet/screens/profile_details_screen/widgets/summary_chart.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/data_card.dart';
import 'package:smart_wallet/utils/charts_utils.dart';
import 'package:smart_wallet/widgets/app_bar/my_app_bar.dart';
import 'package:smart_wallet/widgets/global/main_loading.dart';

import '../../constants/sizes.dart';
import '../../providers/profiles_provider.dart';
import '../../providers/transactions_provider.dart';
import 'widgets/profile_summary_statistics.dart';

class ProfileDetailsScreen extends StatefulWidget {
  final String profileId;
  const ProfileDetailsScreen({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  bool loading = true;
  late ProfileModel profile;
  late int profileAge;
  late List<TransactionModel> profileTransactions;
  bool showChart = false;
  late List<TransactionModel> activeProfileTransactions;
  late List<QuickActionModel> activeProfileQuickActions;
  late List<CustomChartData> customChartData;
  CustomChartType activeChartType = CustomChartType.outcome;

//? setting the active chart type
  void setActiveChartType(CustomChartType chartType) {
    setState(() {
      activeChartType = chartType;
    });
    getCustomChartData();
  }

//? setting the chart data
  void getCustomChartData() {
    late List<CustomChartData> data;

    TransactionsDatesUtils t = TransactionsDatesUtils(
      transactions: profileTransactions,
      firstDate: profile.createdAt,
    );

    if (activeChartType == CustomChartType.income) {
      data = t.getEachDayIncomeData();
    } else if (activeChartType == CustomChartType.outcome) {
      data = t.getEachDayOutcomeData();
    } else if (activeChartType == CustomChartType.savings) {
      data = t.getTotalSavingsData();
    }
    setState(() {
      customChartData = data;
    });
    if (data.length > 1) {
      setState(() {
        showChart = true;
      });
    } else {
      setState(() {
        showChart = false;
      });
    }
  }

//? getting the active profile data(transactions)
  Future<void> setActiveProfileData() async {
    String activeProfileId =
        Provider.of<UserPrefsProvider>(context, listen: false)
            .activatedProfileId;
    List<TransactionModel> activePTransactions =
        await Provider.of<TransactionProvider>(context, listen: false)
            .getProfileTransations(activeProfileId);

    List<QuickActionModel> activePQuickActions =
        await Provider.of<QuickActionsProvider>(context, listen: false)
            .getProfileQuickActions(activeProfileId);

    activeProfileQuickActions = activePQuickActions;
    activeProfileTransactions = activePTransactions;
  }

//? showing the chart or not
  Future<void> doShowChart(int profileAge) async {
    if (profileAge >= 1 &&
        (await Provider.of<TransactionProvider>(context, listen: false)
                .getProfileTransations(profile.id))
            .isNotEmpty) {
      setState(() {
        showChart = true;
      });
    }
  }

  void setLoading(bool l) {
    setState(() {
      loading = l;
    });
  }

  @override
  void initState() {
    setLoading(true);
    Future.delayed(Duration.zero).then((value) async {
      List<TransactionModel> pTransactions =
          await Provider.of<TransactionProvider>(context, listen: false)
              .getProfileTransations(widget.profileId);

      setState(() {
        profile = Provider.of<ProfilesProvider>(
          context,
          listen: false,
        ).getProfileById(widget.profileId);
        profileTransactions = pTransactions;
      });
      final userPrefsProvider =
          Provider.of<UserPrefsProvider>(context, listen: false);

      await Provider.of<ProfileDetailsProvider>(context, listen: false)
          .fetchTransactions(
              pTransactions, profile, userPrefsProvider.dayStart);

      profileAge = Provider.of<ProfilesProvider>(context, listen: false)
          .getProfileAgeInDays(profile);
      await doShowChart(profileAge);
      await setActiveProfileData();
      getCustomChartData();

      setLoading(false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: loading
          ? MainLoading(
              message: 'Loading Profile Data',
            )
          : Stack(
              children: [
                const Background(),
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding / 2),
                    child: Column(
                      children: [
                        MyAppBar(
                          title: profile.name,
                          rightIcon: DeleteProfileIcon(
                            profileId: widget.profileId,
                          ),
                        ),
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                        ProfileSummaryStatistics(
                          profileAge: profileAge,
                        ),
                        SizedBox(
                          height: kDefaultPadding,
                        ),
                        DataCard(
                          title: 'Profile Data',
                          data: {
                            'Transactions': activeProfileTransactions.length,
                            'Quick Actions': activeProfileQuickActions.length,
                          },
                        ),
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                        SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: SummaryChart(
                            profile: profile,
                            profileTransactions: profileTransactions,
                            showChart: showChart,
                            chartData: customChartData,
                            activeChartType: activeChartType,
                            setActiveChartType: setActiveChartType,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
