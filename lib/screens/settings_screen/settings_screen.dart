// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/models/day_start_model.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/providers/user_prefs_provider.dart';
import 'package:smart_wallet/screens/settings_screen/widgets/appearance_settings_row.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';
import '../../constants/sizes.dart';
import '../../widgets/app_bar/home_heading.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late DayStartModel timeToView;

  void changeTheme() {
    //? this will toggle the theme from dark to basic and vice versa
    Themes theme =
        Provider.of<ThemeProvider>(context, listen: false).currentTheme;
    if (theme == Themes.basic) {
      Provider.of<ThemeProvider>(context, listen: false).setTheme(Themes.dark);
    } else {
      Provider.of<ThemeProvider>(context, listen: false).setTheme(Themes.basic);
    }
  }

  @override
  void initState() {
    timeToView = defaultDayStart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var userPrefsProvider = Provider.of<UserPrefsProvider>(context);

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Column(
            children: [
              HomeHeading(
                title: 'Settings',
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              Expanded(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.all(kDefaultPadding / 2),
                  child: ListView(
                    // mainAxisSize: MainAxisSize.min,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      AppearanceSettingsRow(changeTheme: changeTheme),
                      SizedBox(height: kDefaultPadding),
                      Row(
                        children: [
                          Expanded(
                            child: CustomCard(
                                onTap: () async {
                                  TimeOfDay? timeOfDay = await showTimePicker(
                                    context: context,
                                    initialTime: userPrefsProvider.dayStart,
                                  );
                                  if (timeOfDay != null) {
                                    setState(() {
                                      timeToView = DayStartModel(
                                          hour: timeOfDay.hour,
                                          minute: timeOfDay.minute);
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Day Start',
                                      style: themeProvider.getTextStyle(
                                          ThemeTextStyles.kParagraphTextStyle),
                                    ),
                                    Text(
                                      timeToView.toString(),
                                      style: themeProvider.getTextStyle(
                                          ThemeTextStyles.kHeadingTextStyle),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
