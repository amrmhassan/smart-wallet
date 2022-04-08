// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

import '../../../helpers/responsive.dart';
import '../../../themes/choose_color_theme.dart';
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
                      color:
                          themeProvider.getThemeColor(ThemeColors.kMainColor),
                    ),
                    hintText: 'Enter The Profile Name',
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
            AddProfileButton(onTap: onTap)
          ],
        ),
      ),
    );
  }
}

class AddProfileButton extends StatelessWidget {
  const AddProfileButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      width: Responsive.getWidth(context) / 7,
      height: Responsive.getWidth(context) / 7,
      decoration: BoxDecoration(
        color: themeProvider.getThemeColor(ThemeColors.kButtonColor),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            color: ChooseColorTheme.kMainColor.withOpacity(0.2),
            blurRadius: 6,
          )
        ],
        borderRadius: BorderRadius.circular(
          kDefaultBorderRadius / 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            child: Icon(
              Icons.save,
              color: themeProvider.getThemeColor(ThemeColors.kMainColor),
            ),
          ),
        ),
      ),
    );
  }
}

class ClearProfileNameIcon extends StatelessWidget {
  final VoidCallback onTap;
  const ClearProfileNameIcon({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.only(
            right: kDefaultPadding / 4,
          ),
          decoration: BoxDecoration(
            color:
                themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
            borderRadius: BorderRadius.circular(kDefaultBorderRadius / 2),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Container(
                alignment: Alignment.center,
                width: 40,
                height: 40,
                child: Icon(
                  Icons.close,
                  color: themeProvider.getThemeColor(ThemeColors.kDeleteColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
