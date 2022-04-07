import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../themes/choose_color_theme.dart';

class PersonIcon extends StatelessWidget {
  final VoidCallback onTap;
  const PersonIcon({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: ChooseColorTheme.kMainColor,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.person,
              color: ChooseColorTheme.kMainColor,
              size: kDefaultIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
