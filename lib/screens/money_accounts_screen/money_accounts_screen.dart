import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../constants/types.dart';
import '../../providers/profiles_provider.dart';
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
  final TextEditingController _profileNameController = TextEditingController();

  void clearProfileName() {
    _profileNameController.text = '';
  }

  Future<void> showAddProfileModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddProfileModal(
        context: context,
        profileNameController: _profileNameController,
        onTap: addProfile,
        clearProfileNewName: clearProfileName,
      ),
    );
  }

  Future<void> addProfile() async {
    String profileName = _profileNameController.text;
    //* checking if the profile name isn't empty
    if (profileName.isEmpty) {
      return showSnackBar(
        context,
        'Add a profile Name',
        SnackBarType.error,
      );
    }
    if (profileName.length < 3) {
      return showSnackBar(
        context,
        'A profile name must be at least 3 letters',
        SnackBarType.error,
      );
    }
    //* adding a profile
    try {
      //* adding the profile name
      await Provider.of<ProfilesProvider>(
        context,
        listen: false,
      ).addProfile(profileName);
      //* closing the modal
      Navigator.pop(context);
      //* clearing the text field content
      _profileNameController.text = '';
      //* showing a success snack bar
      showSnackBar(
        context,
        'Profile Added',
        SnackBarType.success,
      );
    } catch (error) {
      Navigator.pop(context);
      showSnackBar(
        context,
        error.toString(),
        SnackBarType.error,
      );
    }
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
        // //? i will add an add button here
        // CustomFloatingActionButton(
        //   title: 'Add Profile',
        //   onTap: () => showAddProfileModal(),
        // ),
        Positioned(
          bottom: kCustomBottomNavBarHeight + kDefaultPadding / 4,
          right: kDefaultPadding / 2,
          child: FloatingActionButton(
            onPressed: () async => showAddProfileModal(),
            backgroundColor: kMainColor,
            child: const Icon(
              Icons.add,
              size: kDefaultIconSize,
            ),
          ),
        ),
      ],
    );
  }
}
