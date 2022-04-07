import 'package:flutter/material.dart';

import '../../../themes/choose_color_theme.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';

class NotActivateProfileButton extends StatelessWidget {
  final VoidCallback onTap;

  const NotActivateProfileButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: ChooseColorTheme.kMainColor,
          borderRadius: BorderRadius.circular(kDefaultBorderRadius / 4),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 3),
              alignment: Alignment.center,
              child: const Text(
                'Activate',
                style: kActivateProfileTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ActivatedProfileButton extends StatelessWidget {
  const ActivatedProfileButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: ChooseColorTheme.kInactiveColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(kDefaultBorderRadius / 4),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 3),
              alignment: Alignment.center,
              child: Text(
                'Activated',
                style: kActivatedProfileTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
