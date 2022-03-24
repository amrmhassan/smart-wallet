import 'package:flutter/material.dart';

import '../../constants/sizes.dart';

class CardActionButton extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final Color? backgroundColor;
  final VoidCallback onTap;

  const CardActionButton({
    Key? key,
    required this.color,
    required this.iconData,
    required this.onTap,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(
            1000,
          ),
        ),
        child: Icon(
          iconData,
          size: kUltraSmallIconSize,
          color: color,
        ),
      ),
    );
  }
}
