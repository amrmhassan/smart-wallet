import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../widgets/calculator/widgets/save_button.dart';
import '../../../widgets/global/stylized_text_field.dart';

class AddProfileModal extends StatelessWidget {
  final BuildContext context;
  final TextEditingController _profileNameController;
  final VoidCallback onTap;
  const AddProfileModal({
    Key? key,
    required this.context,
    required TextEditingController profileNameController,
    required this.onTap,
  })  : _profileNameController = profileNameController,
        super(key: key);

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
                    controller: _profileNameController,
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
            SaveButton(onTap: onTap)
          ],
        ),
      ),
    );
  }
}
