import 'package:flutter/material.dart';

import '../../../themes/choose_color_theme.dart';
import '../../../constants/sizes.dart';

class EditProfileButton extends StatelessWidget {
  final VoidCallback onTap;
  const EditProfileButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: ChooseColorTheme.kInactiveColor.withOpacity(.2),
        borderRadius: BorderRadius.circular(
          kDefaultBorderRadius,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              Icons.edit,
              color: ChooseColorTheme.kMainColor,
              size: kSmallIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
