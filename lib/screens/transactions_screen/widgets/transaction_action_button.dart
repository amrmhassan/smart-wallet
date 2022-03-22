import 'package:flutter/material.dart';

import '../../../constants/sizes.dart';

class TransactionActionButton extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final VoidCallback onTap;
  const TransactionActionButton({
    Key? key,
    required this.color,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.grey[100],
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
