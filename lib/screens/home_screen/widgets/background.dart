import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

class Background extends StatelessWidget {
  final String? backgroundPath;
  const Background({
    Key? key,
    this.backgroundPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: themeProvider.currentTheme == Themes.dark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                    themeProvider.getThemeColor(
                      ThemeColors.kMainBackgroundColor,
                    ),
                    themeProvider.getThemeColor(
                      ThemeColors.kCardBackgroundColor,
                    ),
                  ])
            : null,
        image: themeProvider.currentTheme == Themes.basic
            ? DecorationImage(
                image: AssetImage(
                  backgroundPath ?? 'assets/images/background.jpg',
                ),
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }
}
