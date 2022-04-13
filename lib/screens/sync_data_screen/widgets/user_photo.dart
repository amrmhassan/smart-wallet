import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

class UserPhoto extends StatelessWidget {
  final double? raduis;
  final String photoUrl;

  const UserPhoto({
    Key? key,
    required this.photoUrl,
    this.raduis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      clipBehavior: Clip.hardEdge,
      width: raduis ?? 80,
      height: raduis ?? 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1000),
        border: Border.all(
          width: 2,
          color: themeProvider.getThemeColor(
            ThemeColors.kMainColor,
          ),
        ),
      ),
      child: Image.network(
        photoUrl,
        fit: BoxFit.contain,
      ),
    );
  }
}
