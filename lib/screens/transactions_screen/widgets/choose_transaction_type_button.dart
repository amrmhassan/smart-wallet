import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';

class ChooseTransactionTypeButton extends StatelessWidget {
  final String title;
  final bool active;
  final VoidCallback onTap;

  const ChooseTransactionTypeButton({
    Key? key,
    required this.title,
    this.active = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding / 1.5,
          vertical: kDefaultVerticalPadding / 3,
        ),
        decoration: BoxDecoration(
          color: active ? kMainColor : Colors.white,
          borderRadius: BorderRadius.circular(
            kDefaultBorderRadius,
          ),
          border: Border.all(
            width: 1.5,
            color: kMainColor,
          ),
        ),
        child: Text(
          title,
          style:
              active ? kSmallTextWhiteColorStyle : kSmallTextPrimaryColorStyle,
        ),
      ),
    );
  }
}
