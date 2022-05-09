// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/models/home_summary_model.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/settings_screen/widgets/home_summary_settings.dart';
import 'package:smart_wallet/widgets/app_bar/my_app_bar.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';

class HomeSummarySettingsButton extends StatelessWidget {
  final BuildContext ctx;

  const HomeSummarySettingsButton({
    Key? key,
    required this.ctx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return CustomCard(
      onTap: () async {
        //? here handle showing the arranging modal of the home summary
        Navigator.pop(ctx);
        await showModalBottomSheet(
            //? this is the modal of the home summary settings
            backgroundColor: Colors.transparent,
            context: context,
            builder: (contexxxxxt) {
              return HomeSummarySettings(
                ctx: contexxxxxt,
              );
            });

        // Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        //   return HomeSummarySettingsPage();
        // }));
      },
      border: Border.all(
        width: 1,
        color:
            themeProvider.getThemeColor(ThemeColors.kMainColor).withOpacity(.4),
      ),
      child: Row(
        children: [
          Text(
            'Home Summary',
            style: themeProvider.getTextStyle(
              ThemeTextStyles.kSmallTextOpaqueColorStyle,
            ),
          ),
        ],
      ),
    );
  }
}

//! this class is only for testing in case the reorder don't work in the modal
class HomeSummarySettingsPage extends StatelessWidget {
  const HomeSummarySettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor:
          themeProvider.getThemeColor(ThemeColors.kCardBackgroundColor),
      body: SafeArea(
        child: CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              MyAppBar(title: 'Settings'),
              SizedBox(
                height: kDefaultPadding,
              ),
              Text(
                'Drag & drop to change',
                style: themeProvider
                    .getTextStyle(ThemeTextStyles.kHeadingTextStyle),
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              ReorderableList(
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
                  // print(oldIndex);
                  // print(newIndex);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
