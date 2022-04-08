// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/providers/profile_details_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/home_screen/widgets/background.dart';
import 'package:smart_wallet/screens/profile_details_screen/widgets/summary_chart.dart';
import 'package:smart_wallet/utils/general_utils.dart';
import 'package:smart_wallet/widgets/app_bar/my_app_bar.dart';

import '../../constants/sizes.dart';
import '../../constants/theme_constants.dart';
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

  bool showChart(int profileAge) {
    return profileAge > 0 &&
        Provider.of<TransactionProvider>(context).getAllTransactions.isNotEmpty;
  }

  void setLoading(bool l) {
    setState(() {
      loading = l;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      setLoading(true);

      await Provider.of<ProfileDetailsProvider>(context, listen: false)
          .fetchTransactions(widget.profileId);
      profile = Provider.of<ProfilesProvider>(
        context,
        listen: false,
      ).getProfileById(widget.profileId);
      profileAge = Provider.of<ProfilesProvider>(context, listen: false)
          .getProfileAgeInDays(profile);
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

class DeleteProfileIcon extends StatelessWidget {
  final String profileId;

  const DeleteProfileIcon({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  Future<void> deleteProfile(
      BuildContext context, String activeProfileId) async {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Delete a profile?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        try {
          Navigator.pop(context);
          await Provider.of<ProfilesProvider>(
            context,
            listen: false,
          ).deleteProfile(profileId);
          showSnackBar(context, 'Profile deleted', SnackBarType.info);
        } catch (error) {
          showSnackBar(context, error.toString(), SnackBarType.error);
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var activeProfileId = Provider.of<ProfilesProvider>(context, listen: false)
        .activatedProfileId;
    return GestureDetector(
      onTap: activeProfileId == profileId
          ? () {
              showSnackBar(
                context,
                'You can\'t delete the active profile',
                SnackBarType.error,
              );
            }
          : null,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: activeProfileId == profileId
                ? null
                : () async => deleteProfile(context, activeProfileId),
            child: Container(
              padding: EdgeInsets.all(kDefaultPadding / 2),
              child: Icon(
                Icons.delete,
                color: activeProfileId == profileId
                    ? themeProvider
                        .getThemeColor(ThemeColors.kOutcomeColor)
                        .withOpacity(0.5)
                    : themeProvider.getThemeColor(ThemeColors.kOutcomeColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
