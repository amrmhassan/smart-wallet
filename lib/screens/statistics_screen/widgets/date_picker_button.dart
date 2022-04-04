// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';

class DatePickerButton extends StatelessWidget {
  final String title;
  const DatePickerButton({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding / 5,
      ),
      alignment: Alignment.center,
      width: 110,
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(
          color: kInactiveColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(kDefaultBorderRadius / 4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title: ',
            style: kInActiveParagraphTextStyle,
          ),
          Text(
            '22/3/4',
          ),
        ],
      ),
    );
  }
}
