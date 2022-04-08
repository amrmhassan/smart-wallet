import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/types.dart';
import '../providers/profiles_provider.dart';
import '../screens/money_accounts_screen/widgets/add_profile_modal.dart';
import 'general_utils.dart';

Future<void> addProfile(
    BuildContext context, TextEditingController _profileNameController) async {
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

Future<void> showAddProfileModal(
    BuildContext context, TextEditingController _profileNameController) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => AddProfileModal(
      context: context,
      profileNameController: _profileNameController,
      onTap: () => addProfile(context, _profileNameController),
      clearProfileNewName: () => clearProfileName(_profileNameController),
    ),
  );
}

void clearProfileName(TextEditingController _profileNameController) {
  _profileNameController.text = '';
}
