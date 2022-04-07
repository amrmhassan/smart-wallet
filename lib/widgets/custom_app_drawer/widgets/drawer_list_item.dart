import 'package:flutter/material.dart';

import '../../../themes/choose_color_theme.dart';
import '../../../constants/sizes.dart';

class DrawerlistItem extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final String title;
  final Color? color;

  const DrawerlistItem({
    Key? key,
    required this.iconData,
    required this.onTap,
    required this.title,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: kDefaultVerticalPadding / 2,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: color ?? ChooseColorTheme.kMainColor,
              size: kDefaultIconSize,
            ),
            const SizedBox(
              width: kDefaultPadding / 2,
            ),
            Text(
              title,
              style: TextStyle(
                color: ChooseColorTheme.kMainColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
