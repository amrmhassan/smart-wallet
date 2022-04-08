import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/sizes.dart';

import '../../../providers/theme_provider.dart';

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
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: kFiltersRowHeight,
          alignment: Alignment.center,
          child: Text(
            title,
            style: active
                ? themeProvider
                    .getTextStyle(ThemeTextStyles.kParagraphTextStyle)
                : themeProvider
                    .getTextStyle(ThemeTextStyles.kInActiveParagraphTextStyle),
          ),
        ),
      ),
    );
  }
}
