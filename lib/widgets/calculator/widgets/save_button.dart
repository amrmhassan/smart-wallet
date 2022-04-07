import 'package:flutter/material.dart';
import '../../../themes/choose_color_theme.dart';
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
    return Container(
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      width: Responsive.getWidth(context) / 7,
      height: Responsive.getWidth(context) / 7,
      decoration: BoxDecoration(
        color: ChooseColorTheme.kMainColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            color: ChooseColorTheme.kMainColor.withOpacity(0.2),
            blurRadius: 6,
          )
        ],
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
