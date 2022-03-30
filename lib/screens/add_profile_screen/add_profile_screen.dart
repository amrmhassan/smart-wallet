// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/constants/types.dart';
import 'package:wallet_app/providers/profiles_provider.dart';
import 'package:wallet_app/widgets/global/stylized_text_field.dart';
import '../../constants/sizes.dart';

import '../../utils/general_utils.dart';
import '../../widgets/app_bar/my_app_bar.dart';
import '../home_screen/widgets/background.dart';

class AddProfileScreen extends StatefulWidget {
  static const String routeName = '/add-profile-screen';

  const AddProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  String profileName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      //* this is the drawer
      drawer: Drawer(
        child: Container(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          //* this is the background of the screen
          Background(),

          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: Column(
                children: [
                  //* my custom app bar and the mainAppBar is equal to false for adding the back button and remove the menu icon(side bar opener)
                  MyAppBar(
                    title: 'Add Profile',
                  ),
                  //* space between the app bar and the next widget
                  SizedBox(
                    height: 40,
                  ),
                  StylizedTextField(onChanged: (value) {
                    setState(() {
                      profileName = value;
                    });
                  }),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<ProfilesProvider>(
                        context,
                        listen: false,
                      ).addProfile(profileName);
                      Navigator.pop(context);
                      showSnackBar(
                          context, 'Profile Added', SnackBarType.success);
                    },
                    child: Text('Add Profile'),
                  ),

                  SizedBox(
                    height: kDefaultPadding,
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
