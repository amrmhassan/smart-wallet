import 'package:flutter/material.dart';
import 'package:smart_wallet/screens/logging_screen/logging_screen.dart';

class OpenLoggingScreen extends StatelessWidget {
  const OpenLoggingScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, LoggingScreen.routeName);
      },
      child: Container(
        width: 20,
        height: 100,
        color: Colors.red,
      ),
    );
  }
}
