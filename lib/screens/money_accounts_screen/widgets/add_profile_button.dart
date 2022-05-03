import 'package:flutter/material.dart';
import 'package:smart_wallet/widgets/calculator/widgets/save_button.dart';

class AddProfileButton extends StatelessWidget {
  const AddProfileButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SaveButton(onTap: onTap);
  }
}
