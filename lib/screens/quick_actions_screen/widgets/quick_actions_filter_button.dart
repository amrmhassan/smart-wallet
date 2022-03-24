import 'package:flutter/material.dart';
import 'package:wallet_app/constants/sizes.dart';

import '../../../constants/styles.dart';

class QuickActionsFilterButton extends StatelessWidget {
  final bool active;
  final String title;
  final VoidCallback onTap;
  const QuickActionsFilterButton({
    Key? key,
    this.active = false,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: kFiltersRowHeight,
          alignment: Alignment.center,
          child: Text(
            title,
            style: active ? kParagraphTextStyle : kInActiveParagraphTextStyle,
          ),
        ),
      ),
    );
  }
}
