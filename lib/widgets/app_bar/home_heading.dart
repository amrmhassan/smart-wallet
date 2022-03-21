// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../constants/styles.dart';

class HomeHeading extends StatelessWidget {
  const HomeHeading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Current Profile Name',
        style: kHeadingTextStyle,
      ),
    );
  }
}
