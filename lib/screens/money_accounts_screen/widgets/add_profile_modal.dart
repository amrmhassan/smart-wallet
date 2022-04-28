// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/money_accounts_screen/widgets/add_profile_button.dart';
import 'package:smart_wallet/screens/money_accounts_screen/widgets/clear_profile_name_icon.dart';

import '../../../constants/sizes.dart';
import '../../../widgets/global/stylized_text_field.dart';

enum ProfileOperationType {
  add,
  edit,
}

class AddProfileModal extends StatelessWidget {
  final BuildContext context;
  final TextEditingController profileNameController;
  final ProfileOperationType profileOperationType;
  final VoidCallback onTap;
  final VoidCallback? clearProfileNewName;
  final VoidCallback? clearEditedProfileName;

  const AddProfileModal({
    Key? key,
    required this.context,
    required this.profileNameController,
    required this.onTap,
    this.profileOperationType = ProfileOperationType.add,
    this.clearProfileNewName,
    this.clearEditedProfileName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: kDefaultVerticalPadding,
        ),
        height: 150,
        decoration: BoxDecoration(
          color: themeProvider.getThemeColor(ThemeColors.kCardBackgroundColor),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kDefaultBorderRadius),
            topRight: Radius.circular(kDefaultBorderRadius),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              //? i added this column to prevent the stylized text field to take the whole height of the expanded
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StylizedTextField(
                    suffixIcon: ClearProfileNameIcon(onTap: () {
                      if (profileOperationType == ProfileOperationType.add) {
                        //* this should be provided when adding a new profile name from the money accounts screen
                        clearProfileNewName!();
                      } else {
                        //* this should be provided when editing a profile name from the profile card
                        clearEditedProfileName!();
                      }
                    }),
                    controller: profileNameController,
                    maxLines: 1,
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: themeProvider
                          .getThemeColor(ThemeColors.kMainColor)
                          .withOpacity(0.3),
                    ),
                    hintText: 'Enter A Profile Name',
                    autoFocus: true,
                    textStyle: TextStyle(
                      color:
                          themeProvider.getThemeColor(ThemeColors.kMainColor),
                    ),
                    onChanged: (value) {},
                    keyboardType: TextInputType.text,
                    fillColor: themeProvider
                        .getThemeColor(ThemeColors.kTextFieldInputColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                      borderSide: BorderSide(
                        color: themeProvider
                            .getThemeColor(ThemeColors.kMainBackgroundColor),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: kDefaultPadding / 2,
            ),
            AddProfileButton(onTap: onTap),
          ],
        ),
      ),
    );
  }
}
