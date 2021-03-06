import 'package:flutter/material.dart';
import '../../constants/sizes.dart';
import '../../widgets/app_bar/home_heading.dart';
import 'widgets/profiles_grid.dart';

class MoneyAccountsScreen extends StatefulWidget {
  const MoneyAccountsScreen({Key? key}) : super(key: key);

  @override
  State<MoneyAccountsScreen> createState() => _MoneyAccountsScreenState();
}

class _MoneyAccountsScreenState extends State<MoneyAccountsScreen> {
  @override
  void initState() {
    super.initState();
  }

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
              title: 'Money Profiles',
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
