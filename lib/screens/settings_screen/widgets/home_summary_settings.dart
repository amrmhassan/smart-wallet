// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/models/home_summary_model.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';

class HomeSummarySettings extends StatelessWidget {
  final BuildContext ctx;
  const HomeSummarySettings({
    Key? key,
    required this.ctx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: ReorderableList(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return HomeSummarySettingsElement(
            index: index,
            key: UniqueKey(),
          );
        },
        itemCount: allHomeSummaries.length,
        onReorder: (int oldIndex, int newIndex) {
          print(oldIndex);
          print(newIndex);
        },
      ),
    );
  }
}

class HomeSummarySettingsElement extends StatelessWidget {
  final int index;
  const HomeSummarySettingsElement({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Opacity(
      opacity: index + 1 > 3 ? .5 : 1,
      child: CustomCard(
        onTap: () {},
        key: UniqueKey(),
        margin: EdgeInsets.only(bottom: kDefaultPadding / 2),
        border: Border.all(
          width: 1,
          color: themeProvider.getThemeColor(ThemeColors.kMainColor),
        ),
        child: Text(
          allHomeSummaries[index].fullName,
          style: themeProvider
              .getTextStyle(ThemeTextStyles.kSmallTextPrimaryColorStyle),
        ),
      ),
    );
  }
}
