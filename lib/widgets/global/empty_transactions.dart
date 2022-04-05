import 'package:flutter/material.dart';

import '../../constants/sizes.dart';

class EmptyTransactions extends StatelessWidget {
  final Widget? title;
  final bool showImage;
  final String imagePath;
  final Widget? trainling;
  const EmptyTransactions({
    Key? key,
    this.title,
    this.showImage = true,
    this.imagePath = 'assets/icons/empty.png',
    this.trainling,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        title ?? const SizedBox(),
        const SizedBox(
          height: kDefaultPadding,
        ),
        if (showImage)
          SizedBox(
            width: 300,
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        if (trainling != null) trainling ?? const SizedBox(),
      ],
    );
  }
}
