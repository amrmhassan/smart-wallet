import 'package:awesome_dialog/awesome_dialog.dart';
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

Future<void> showDeleteProfileModal(BuildContext context, String profileId,
    [String? msg, bool exitAfterDeleting = false]) async {
  await AwesomeDialog(
    context: context,
    dialogType: DialogType.WARNING,
    animType: AnimType.BOTTOMSLIDE,
    title: msg ?? 'Delete a profile?',
    btnCancelOnPress: () {},
    btnOkOnPress: () async {
      try {
        //* this will check if i am deleting the profile from the details screen or from
        //* after clicking the empty profile
        if (exitAfterDeleting) {
          Navigator.pop(context);
        }
        await Provider.of<ProfilesProvider>(
          context,
          listen: false,
        ).deleteProfile(profileId);
        showSnackBar(context, 'Profile deleted', SnackBarType.info);
      } catch (error) {
        showSnackBar(context, error.toString(), SnackBarType.error);
      }
    },
  ).show();
}

void clearProfileName(TextEditingController _profileNameController) {
  _profileNameController.text = '';
}
