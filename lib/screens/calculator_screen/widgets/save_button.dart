import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
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
      width: Responsive.getWidth(context) / 3.5,
      height: Responsive.getWidth(context) / 7,
      decoration: BoxDecoration(
        color: kMainColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            color: kMainColor.withOpacity(0.2),
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
          onTap: () {},
          child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Save',
                    style: kWhiteTextStyle,
                  ),
                  SizedBox(
                    width: kDefaultPadding / 3,
                  ),
                  Icon(
                    FontAwesomeIcons.solidSave,
                    color: Colors.white,
                    size: kSmallIconSize,
                  )
                ],
              )),
        ),
      ),
    );
  }
}
