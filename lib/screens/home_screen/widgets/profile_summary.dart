import 'package:flutter/material.dart';

import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
import '../../../widgets/global/line.dart';
import 'left_side_summary.dart';
import 'right_side_sammary.dart';

//* constants that matter to this widget only
const double height = 215;

class ProfileSummary extends StatelessWidget {
  const ProfileSummary({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.symmetric(
        vertical: kDefaultVerticalPadding,
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(
          vertical: kDefaultVerticalPadding,
        ),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          boxShadow: [
            kDefaultBoxShadow,
          ],
        ),
        child: Row(
          children: const [
            LeftSideSummary(),
            Line(
              lineType: LineType.vertical,
            ),
            RightSideSammary(),
          ],
        ),
      ),
    );
  }
}
