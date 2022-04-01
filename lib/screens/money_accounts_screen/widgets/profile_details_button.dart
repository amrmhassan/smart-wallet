import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class ProfileDetailsButton extends StatelessWidget {
  final String profileId;
  final VoidCallback onTap;
  const ProfileDetailsButton({
    Key? key,
    required this.profileId,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: kInactiveColor.withOpacity(.2),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding / 2,
                  vertical: kDefaultPadding / 5,
                ),
                child: Row(
                  children: const [
                    // Text(
                    //   'Details',
                    //   style: kSmallTextPrimaryColorStyle,
                    // ),
                    Icon(
                      Icons.keyboard_double_arrow_right_outlined,
                      color: kMainColor,
                      size: kMediumIconSize,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
