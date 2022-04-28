// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/authentication_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

class UserPhoto extends StatefulWidget {
  final double? raduis;
  // final File photoFile;

  const UserPhoto({
    Key? key,
    // required this.photoFile,
    this.raduis,
  }) : super(key: key);

  @override
  State<UserPhoto> createState() => _UserPhotoState();
}

class _UserPhotoState extends State<UserPhoto> {
  // bool _loadingUserPhoto = false;
  // @override
  // void initState() {
  //   setState(() {
  //     _loadingUserPhoto = true;
  //   });
  //   Future.delayed(Duration.zero).then((value) async {
  //     try {
  //       var setUserPhoto =
  //           Provider.of<AuthenticationProvider>(context, listen: false)
  //               .setUserPhoto;

  //       await handleGetUserPhoto(setUserPhoto);
  //     } catch (error) {
  //       CustomError.log(
  //         errorType: ErrorTypes.noUserPhoto,
  //         logType: LogTypes.info,
  //       );
  //     }

  //     setState(() {
  //       _loadingUserPhoto = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var authProvider = Provider.of<AuthenticationProvider>(context);

    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: themeProvider.getThemeColor(ThemeColors.kMainColor),
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
        ),
        width: widget.raduis ?? 80,
        height: widget.raduis ?? 80,
        child: authProvider.userPhoto != null
            ? Image.file(
                authProvider.userPhoto!,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return Container(
                    color: Colors.red,
                  );
                },
              )
            : NoUserPhoto(),
      ),
    );
  }
}

class NoUserPhoto extends StatelessWidget {
  const NoUserPhoto({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/anxiety.png',
      fit: BoxFit.contain,
    );
  }
}
