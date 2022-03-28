import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';

class ProfileDetailsButton extends StatelessWidget {
  final String profileId;
  const ProfileDetailsButton({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding / 2,
            vertical: kDefaultPadding / 5,
          ),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: kInactiveColor.withOpacity(.2),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: const [
              Text(
                'Details',
                style: kSmallTextPrimaryColorStyle,
              ),
              Icon(
                Icons.keyboard_double_arrow_right_outlined,
                color: kMainColor,
                size: kMediumIconSize,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
