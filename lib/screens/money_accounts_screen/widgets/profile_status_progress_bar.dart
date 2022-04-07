import 'package:flutter/material.dart';

import '../../../themes/choose_color_theme.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';

class ProfileStatusProgressBar extends StatelessWidget {
  final double incomeRatio;
  final Color profileStatusColor;

  const ProfileStatusProgressBar({
    Key? key,
    required this.incomeRatio,
    required this.profileStatusColor,
  }) : super(key: key);

  String get incomeRatioString {
    return '${(incomeRatio * 100).toStringAsFixed(0)}%';
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Income',
                style: kSmallTextPrimaryColorStyle,
              ),
              Text(
                incomeRatioString,
                style: kSmallTextPrimaryColorStyle,
              ),
            ],
          ),
          const SizedBox(
            height: kDefaultPadding / 6,
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              color: ChooseColorTheme.kInactiveColor.withOpacity(0.3),
            ),
            child: FractionallySizedBox(
                widthFactor: incomeRatio,
                child: Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    color: profileStatusColor,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
