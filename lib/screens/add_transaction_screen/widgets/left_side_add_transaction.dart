import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../constants/sizes.dart';
import '../../../widgets/global/stylized_text_field.dart';

class LeftSideAddTransaction extends StatelessWidget {
  //* widget needed controllers from the parent
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const LeftSideAddTransaction({
    Key? key,
    required this.titleController,
    required this.descriptionController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    //* this is the left side container , it is expanded cause it will take the 3/5 of the width
    return Expanded(
      flex: 3,
      //* this row is for giving a right padding by adding sized box of the same padding as the main container
      child: Row(
        children: [
          //* that expanded will have the textFields title and description
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //* this is the title holder and it will take 2/5 of the column
                StylizedTextField(
                  controller: titleController,
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeProvider.getThemeColor(ThemeColors.kMainColor),
                  ),
                  maxLines: 1,
                  hintText: 'Enter a title',
                  onChanged: (value) {},
                  keyboardType: TextInputType.text,
                  textStyle: TextStyle(
                    color: themeProvider.getThemeColor(ThemeColors.kMainColor),
                  ),
                  fillColor: themeProvider
                      .getThemeColor(ThemeColors.kTextFieldInputColor),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(kDefaultBorderRadius / 2),
                    borderSide: BorderSide(
                      color: themeProvider
                          .getThemeColor(ThemeColors.kMainBackgroundColor),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(kDefaultBorderRadius / 2),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),

                //* this is the description input
                StylizedTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: themeProvider.getThemeColor(ThemeColors.kMainColor),
                  ),
                  maxLines: 3,
                  onChanged: (value) {},
                  keyboardType: TextInputType.multiline,
                  textStyle: TextStyle(
                    color: themeProvider.getThemeColor(ThemeColors.kMainColor),
                  ),
                  fillColor: themeProvider
                      .getThemeColor(ThemeColors.kTextFieldInputColor),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(kDefaultBorderRadius / 2),
                    borderSide: BorderSide(
                      color: themeProvider
                          .getThemeColor(ThemeColors.kMainBackgroundColor),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(kDefaultBorderRadius / 2),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //* this is for adding a virtual padding next to the title and description and the vertical line
          const SizedBox(
            width: kDefaultPadding / 2,
          ),
        ],
      ),
    );
  }
}
