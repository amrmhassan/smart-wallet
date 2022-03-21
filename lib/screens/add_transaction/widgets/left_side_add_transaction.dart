import 'package:flutter/material.dart';
import 'package:wallet_app/constants/colors.dart';
import 'package:wallet_app/constants/sizes.dart';
import 'package:wallet_app/screens/home_screen/widgets/summary_period_icon.dart';
import 'package:wallet_app/widgets/global/stylized_text_field.dart';

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
                    color: kMainColor.withOpacity(0.7),
                  ),
                  hintText: 'Enter a title',
                  onChanged: (value) {},
                  keyboardType: TextInputType.text,
                  fillColor: kTextFieldInputColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
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
                    color: kMainColor.withOpacity(0.7),
                  ),
                  maxLines: 3,
                  onChanged: (value) {},
                  keyboardType: TextInputType.text,
                  fillColor: kTextFieldInputColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      )),
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
