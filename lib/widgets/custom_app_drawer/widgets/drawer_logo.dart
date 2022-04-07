import 'package:flutter/material.dart';

import '../../../themes/choose_color_theme.dart';
import '../../../constants/sizes.dart';

class DrawerLogo extends StatelessWidget {
  const DrawerLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Image.asset(
            'assets/images/whiteLogo-min.png',
            width: 200,
            fit: BoxFit.contain,
          ),
          Text(
            'Smart Wallet',
            style: TextStyle(
              color: ChooseColorTheme.kMainColor,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
