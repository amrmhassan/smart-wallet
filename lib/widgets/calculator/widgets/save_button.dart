import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/responsive.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onTap;

  const SaveButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      width: Responsive.getWidth(context) / 7,
      height: Responsive.getWidth(context) / 7,
      decoration: BoxDecoration(
        color: themeProvider.getThemeColor(ThemeColors.kActiveButtonColor),
        boxShadow: [themeProvider.getBoxShadow(ThemeBoxShadow.kIconBoxShadow)],
        borderRadius: BorderRadius.circular(
          kDefaultBorderRadius / 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            child: const Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
