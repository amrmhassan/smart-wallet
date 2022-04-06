import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final String? backgroundPath;
  const Background({
    Key? key,
    this.backgroundPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            backgroundPath ?? 'assets/images/background.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
