import 'package:flutter/material.dart';

import '../../constants/styles.dart';

class HomeHeading extends StatelessWidget {
  final String title;
  const HomeHeading({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        title,
        style: kHeadingTextStyle,
      ),
    );
  }
}
