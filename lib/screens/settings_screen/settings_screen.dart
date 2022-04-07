// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/colors.dart';
import 'package:smart_wallet/constants/styles.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import '../../constants/sizes.dart';
import '../../themes/choose_color_theme.dart';
import '../../widgets/app_bar/home_heading.dart';
import '../../widgets/global/custom_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
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
                  child: GridView(
                    clipBehavior: Clip.none,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: kDefaultPadding / 2,
                      mainAxisSpacing: kDefaultPadding / 2,
                      childAspectRatio: 2 / 3,
                    ),
                    children: [
                      //! type the theme name and preview it
                      GestureDetector(
                        onTap: () {
                          //? this will toggle the theme from dark to basic and vice versa
                          Themes theme =
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .currentTheme;
                          if (theme == Themes.basic) {
                            Provider.of<ThemeProvider>(context, listen: false)
                                .setTheme(Themes.dark);
                          } else {
                            Provider.of<ThemeProvider>(context, listen: false)
                                .setTheme(Themes.basic);
                          }
                        },
                        child: CustomCard(
                          backgroundImage: DecorationImage(
                            image: AssetImage(
                              'assets/images/background.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/themes.png',
                                    width: 30,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(
                                    width: kDefaultPadding / 2,
                                  ),
                                  Text(
                                    'Themes',
                                    style: kSmallTextPrimaryColorStyle,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: kDefaultPadding / 2,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Light',
                                    style: TextStyle(
                                      color: ChooseColorTheme.kMainColor
                                          .withOpacity(0.5),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CustomCard(
                        child: Text('Appearance'),
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
