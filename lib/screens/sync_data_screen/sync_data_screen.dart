// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/data_card.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/user_info.dart';
import 'package:smart_wallet/widgets/global/line.dart';
import '../../constants/sizes.dart';

import '../../widgets/app_bar/my_app_bar.dart';
import '../home_screen/widgets/background.dart';

const bool loggedIn = false;

class SyncDataScreen extends StatefulWidget {
  static const String routeName = '/sync-data-screen';

  const SyncDataScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SyncDataScreen> createState() => _SyncDataScreenState();
}

class _SyncDataScreenState extends State<SyncDataScreen> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,

      //* this is the drawer
      drawer: Drawer(
        child: Container(
          color: Colors.white,
        ),
      ),
      //? this gesture detector will remove the focus whenever anything else is clicked in the screen
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            //* this is the background of the screen
            const Background(),

            SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                child: Column(
                  children: [
                    MyAppBar(
                      title: 'Sync Data',
                    ),
                    SizedBox(
                      height: kDefaultPadding,
                    ),
                    Column(
                      children: [
                        //* for showing the user info (picture and a name)
                        if (loggedIn) UserInfo(),
                        Column(
                          children: [
                            // Text(
                            //   'Please sign in first!',
                            //   style: themeProvider.getTextStyle(
                            //     ThemeTextStyles.kParagraphTextStyle,
                            //   ),
                            // ),
                            SizedBox(
                              height: kDefaultPadding / 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Line(
                                    lineType: LineType.horizontal,
                                    thickness: 1,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          kDefaultHorizontalPadding / 3),
                                  child: Text(
                                    'Sign In Using',
                                    style: themeProvider.getTextStyle(
                                      ThemeTextStyles
                                          .kInActiveParagraphTextStyle,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Line(
                                    lineType: LineType.horizontal,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: kDefaultPadding / 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GoogleSignInButton(
                                  onTap: () {},
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: kDefaultPadding,
                        ),

                        //* for showing the not synced data info
                        DataCard(
                          title: 'Not Synced Data',
                          data: {
                            'Profiles': 10,
                            'Transactions': 53,
                            'Quick Actions': 6,
                          },
                        ),
                        SizedBox(
                          height: kDefaultPadding,
                        ),
                        //* for showing the synced data info
                        if (loggedIn)
                          DataCard(
                            title: 'Synced Data',
                            data: {
                              'Profiles': 10,
                              'Transactions': 53,
                              'Quick Actions': 6,
                            },
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onTap;
  const GoogleSignInButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(5),
            child: Image.asset(
              'assets/icons/google.png',
              width: 35,
            ),
          ),
        ),
      ),
    );
  }
}
