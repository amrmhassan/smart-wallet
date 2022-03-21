// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:wallet_app/constants/colors.dart';
import 'package:wallet_app/constants/sizes.dart';
import 'package:wallet_app/constants/styles.dart';
import 'package:wallet_app/constants/types.dart';
import 'package:wallet_app/widgets/global/line.dart';

import '../../widgets/app_bar/my_app_bar.dart';
import '../home_screen/widgets/background.dart';
import 'widgets/left_side_add_transaction.dart';
import 'widgets/right_side_add_transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  static const String routeName = '/add-transaction-screen';
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  //* That is the default active transaction type (outcome) cause it is the common one
  TransactionType currentActiveTransactionType = TransactionType.outcome;
  //* for setting the current active transaction type and it will be passed down to the widget that will use it
  void setcurrentActiveTransactionType(TransactionType transactionType) {
    setState(() {
      currentActiveTransactionType = transactionType;
    });
  }

  //* text inputs controller
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      //* this is the drawer
      drawer: Drawer(
        child: Container(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          //* this is the background of the screen
          Background(),

          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: Column(
                children: [
                  //* my custom app bar and the mainAppBar is equal to false for adding the back button and remove the menu icon(side bar opener)
                  MyAppBar(
                    mainAppBar: false,
                  ),
                  //* space between the app bar and the next widget
                  SizedBox(
                    height: 40,
                  ),
                  //* the main container of the adding new transaction cart which will have the main padding around the edges of the screen
                  Container(
                    padding: EdgeInsets.all(kDefaultPadding / 2),
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                      color: Colors.white,
                      boxShadow: [kDefaultBoxShadow],
                    ),
                    //* the row which will have the main sides of the cart
                    child: Row(
                      children: [
                        //* the left side is for adding the title and description
                        LeftSideAddTransaction(
                          titleController: _titleController,
                          descriptionController: _descriptionController,
                        ),
                        Line(lineType: LineType.vertical),
                        //* the right side is for adding the price and transaction type
                        RightSideAddTransaction(
                          currentActiveTransactionType:
                              currentActiveTransactionType,
                          setCurrentActiveTransactionType:
                              setcurrentActiveTransactionType,
                          priceController: _priceController,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: kMainColor),
                      onPressed: () {
                        //? here i will add the adding new transaction logic (for the providers)
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
