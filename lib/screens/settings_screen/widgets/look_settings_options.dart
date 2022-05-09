import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/settings_screen/widgets/home_summary_settings.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';

class LookSettingsOptions extends StatelessWidget {
  final BuildContext ctx;
  const LookSettingsOptions({
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
            backgroundColor: Colors.transparent,
            context: context,
            builder: (contexxxxxt) {
              // ignore: prefer_const_constructors
              return HomeSummarySettings(
                ctx: contexxxxxt,
              );
            });
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
