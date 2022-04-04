import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

const double width = 30;
const double height = 30;
const double borderRadius = 10;

class SummaryPeriodIcon extends StatelessWidget {
  final String title;
  final bool active;
  final VoidCallback onTap;
  final bool enabled;

  const SummaryPeriodIcon({
    Key? key,
    required this.title,
    this.active = false,
    required this.onTap,
    this.enabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color kIconColor() {
      if (enabled) {
        if (active) {
          return Colors.white;
        } else {
          return kMainColor;
        }
      } else {
        return kInactiveColor;
      }
    }

    return Container(
      clipBehavior: Clip.hardEdge,
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? kMainColor : kMainColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Container(
            alignment: Alignment.center,
            width: 30,
            height: 30,
            child: Text(
              title,
              style: TextStyle(
                color: kIconColor(),
                fontSize: kDefaultInfoTextSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
