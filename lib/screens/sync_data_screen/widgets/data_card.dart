// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/synced_data_element.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';
import 'package:smart_wallet/widgets/global/line.dart';

class DataCard extends StatelessWidget {
  final String title;
  final Map<String, int> data;

  const DataCard({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var keys = data.keys.toList();

    return CustomCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: themeProvider.getTextStyle(
            ThemeTextStyles.kParagraphTextStyle,
          ),
        ),
        SizedBox(
          height: kDefaultPadding,
        ),
        Column(
          children: keys
              .map((key) => Column(
                    children: [
                      SyncedDataElement(
                        title: key,
                        amount: data[key] as int,
                      ),
                      SizedBox(
                        height: kDefaultPadding / 3,
                      ),
                      if (key != keys.last)
                        Line(
                          lineType: LineType.horizontal,
                          thickness: 1,
                          color: themeProvider
                              .getThemeColor(
                                ThemeColors.kMainColor,
                              )
                              .withOpacity(.2),
                        ),
                      if (key != keys.last)
                        SizedBox(
                          height: kDefaultPadding / 3,
                        ),
                    ],
                  ))
              .toList(),
        ),
      ],
    ));
  }
}
