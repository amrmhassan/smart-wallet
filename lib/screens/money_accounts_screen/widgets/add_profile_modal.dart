import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../widgets/calculator/widgets/save_button.dart';
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
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding,
          vertical: kDefaultVerticalPadding,
        ),
        height: 150,
        decoration: const BoxDecoration(
          color: Colors.white,
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
                      color: kMainColor.withOpacity(0.7),
                    ),
                    hintText: 'Enter The Profile Name',
                    onChanged: (value) {},
                    keyboardType: TextInputType.text,
                    fillColor: kTextFieldInputColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3),
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
            SaveButton(onTap: onTap),
          ],
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.only(
            right: kDefaultPadding / 4,
          ),
          decoration: BoxDecoration(
            color: kInactiveColor.withOpacity(.4),
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
                child: const Icon(
                  Icons.close,
                  color: kOutcomeColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
