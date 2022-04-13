// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/data_card.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/login_user_options.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/user_info_viewer.dart';
import '../../constants/sizes.dart';

import '../../widgets/app_bar/my_app_bar.dart';
import '../home_screen/widgets/background.dart';

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
                      enableTapping: false,
                    ),
                    SizedBox(
                      height: kDefaultPadding,
                    ),
                    StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Loading');
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else if (snapshot.hasData) {
                          User user = snapshot.data as User;

                          return Column(
                            children: [
                              //* for showing the user info (picture and a name)
                              UserInfoViewer(
                                photoUrl: user.photoURL,
                                userName: user.displayName,
                                userEmail: user.email,
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
                              DataCard(
                                title: 'Synced Data',
                                data: {
                                  'Profiles': 10,
                                  'Transactions': 53,
                                  'Quick Actions': 6,
                                },
                              ),
                            ],
                          );
                        } else {
                          var profiles =
                              Provider.of<ProfilesProvider>(context).profiles;

                          return Column(
                            children: [
                              LogInUserOptions(),
                              SizedBox(
                                height: kDefaultPadding,
                              ),

                              //* for showing the not synced data info
                              DataCard(
                                title: 'Not Synced Data',
                                data: {
                                  'Profiles': profiles.length,
                                  'Transactions': 9,
                                  'Quick Actions': 6,
                                },
                              ),
                            ],
                          );
                        }
                      },
                    ),
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
