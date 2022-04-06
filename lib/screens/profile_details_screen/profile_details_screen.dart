// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/providers/profile_details_provider.dart';
import 'package:smart_wallet/screens/home_screen/widgets/background.dart';
import 'package:smart_wallet/screens/profile_details_screen/widgets/summary_chart.dart';
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
  bool showChart(int profileAge) {
    return profileAge > 0 &&
        Provider.of<TransactionProvider>(context).getAllTransactions.isNotEmpty;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        loading = true;
      });
      var profileDetailsProvider =
          Provider.of<ProfileDetailsProvider>(context, listen: false);

      await profileDetailsProvider.fetchTransactions(widget.profileId);
      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileModel profileData = Provider.of<ProfilesProvider>(
      context,
    ).getProfileById(widget.profileId);
    int profileAge =
        Provider.of<ProfilesProvider>(context).getProfileAgeInDays(profileData);

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
                          title: profileData.name,
                        ),
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                        ProfileSummaryStatistics(
                          profileAge: profileAge,
                        ),
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                        if (showChart(profileAge))
                          const SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: SummaryChart(),
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
