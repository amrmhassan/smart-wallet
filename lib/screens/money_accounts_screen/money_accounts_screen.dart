import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/sizes.dart';
import '../../constants/types.dart';
import '../../providers/profiles_provider.dart';
import '../../themes/choose_color_theme.dart';
import '../../utils/general_utils.dart';
import '../../widgets/app_bar/home_heading.dart';
import 'widgets/add_profile_modal.dart';
import 'widgets/profiles_grid.dart';

class MoneyAccountsScreen extends StatefulWidget {
  const MoneyAccountsScreen({Key? key}) : super(key: key);

  @override
  State<MoneyAccountsScreen> createState() => _MoneyAccountsScreenState();
}

class _MoneyAccountsScreenState extends State<MoneyAccountsScreen> {
//* this is the build method of this widget
  @override
  Widget build(BuildContext context) {
    //* the main container of the money accounts screen
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Column(
          children: const [
            HomeHeading(
              title: 'Money Accounts',
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            Expanded(
              child: ProfilesGrid(),
            ),
          ],
        ),
      ],
    );
  }
}
