// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/models/quick_action_model.dart';
import 'package:smart_wallet/models/transaction_model.dart';
import 'package:smart_wallet/providers/profile_details_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/screens/home_screen/widgets/background.dart';
import 'package:smart_wallet/screens/profile_details_screen/widgets/delete_profile_icon.dart';
import 'package:smart_wallet/screens/profile_details_screen/widgets/summary_chart.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/data_card.dart';
import 'package:smart_wallet/widgets/app_bar/my_app_bar.dart';

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

  Future<void> setActiveProfileData() async {
    String activeProfileId =
        Provider.of<ProfilesProvider>(context, listen: false)
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

      await Provider.of<ProfileDetailsProvider>(context, listen: false)
          .fetchTransactions(pTransactions, profile);

      profileAge = Provider.of<ProfilesProvider>(context, listen: false)
          .getProfileAgeInDays(profile);
      await doShowChart(profileAge);
      await setActiveProfileData();

      setLoading(false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: loading
          ? Text('Loading')
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
                        if (showChart)
                          SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: SummaryChart(
                              profile: profile,
                              profileTransactions: profileTransactions,
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
