import 'package:flutter/material.dart';

class TestingElement extends StatelessWidget {
  final String title;
  final dynamic value;
  const TestingElement({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toString(),
        ),
        Text(
          value.toString(),
        ),
      ],
    );
  }
}
