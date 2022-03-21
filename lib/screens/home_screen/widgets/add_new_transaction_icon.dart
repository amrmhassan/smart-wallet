import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class AddNewTransactionIcon extends StatelessWidget {
  final VoidCallback onTap;
  const AddNewTransactionIcon({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          width: 4,
          color: kMainColor.withOpacity(.5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(
              kDefaultPadding / 3,
            ),
            child: Icon(
              FontAwesomeIcons.plus,
              size: kDefaultIconSize,
              color: kMainColor.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}
