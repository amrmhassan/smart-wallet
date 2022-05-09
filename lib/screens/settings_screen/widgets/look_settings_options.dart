// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/screens/settings_screen/widgets/home_summary_settings_button.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';

class LookSettingsOptions extends StatelessWidget {
  final BuildContext ctx;
  const LookSettingsOptions({
    Key? key,
    required this.ctx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          HomeSummarySettingsButton(
            ctx: ctx,
          )
        ],
      ),
    );
  }
}
