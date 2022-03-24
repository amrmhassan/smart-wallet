// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/constants/colors.dart';
import 'package:wallet_app/constants/sizes.dart';
import 'package:wallet_app/constants/styles.dart';
import 'package:wallet_app/constants/types.dart';
import 'package:wallet_app/models/quick_action_model.dart';
import 'package:wallet_app/models/transaction_model.dart';
import 'package:wallet_app/providers/quick_actions_provider.dart';
import 'package:wallet_app/providers/transactions_provider.dart';
import 'package:wallet_app/utils/transactions_utils.dart';
import 'package:wallet_app/widgets/global/line.dart';

import '../../widgets/app_bar/my_app_bar.dart';
import '../home_screen/widgets/background.dart';
import 'widgets/left_side_add_transaction.dart';
import 'widgets/right_side_add_transaction.dart';

enum AddTransactionScreenOperations {
  addTransaction,
  addQuickAction,
  editTransaction,
  editQuickAction,
}

class AddTransactionScreen extends StatefulWidget {
  static const String routeName = '/add-transaction-screen';
  //* to differentiate between adding new transaction and editting existing one
  final AddTransactionScreenOperations addTransactionScreenOperations;
  final String? editingId;

  const AddTransactionScreen({
    Key? key,
    required this.addTransactionScreenOperations,
    this.editingId,
  }) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  //* That is the default active transaction type (outcome) cause it is the common one
  TransactionType currentActiveTransactionType = TransactionType.outcome;
  TransactionModel? editedTransaction;
  QuickActionModel? editedQuickAction;

  //* for setting the current active transaction type and it will be passed down to the widget that will use it
  void setcurrentActiveTransactionType(TransactionType transactionType) {
    setState(() {
      currentActiveTransactionType = transactionType;
    });
  }

//? this function may add a transaction or a quick action depending on the value of addQuickAction
  void addTransaction() async {
    //* preparing the needed info to add the new thing(transaction or quick action)
    String title =
        _titleController.text.isEmpty ? 'Empty Title' : _titleController.text;
    double amount = double.tryParse(_priceController.text) ?? 0;
    String description = _descriptionController.text.isEmpty
        ? 'Empty Description'
        : _descriptionController.text;
    TransactionType transactionType = currentActiveTransactionType;

    //* adding quick action
    if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.addQuickAction) {
      try {
        //* here i will add the new quick action
        await Provider.of<QuickActionsProvider>(context, listen: false)
            .addQuickAction(title, description, amount, transactionType);
        showSnackBar(context, 'Quick Action Added', SnackBarType.success);
      } catch (error) {
        showSnackBar(context, error.toString(), SnackBarType.error);
      }
      //* adding transaction
    } else if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.addTransaction) {
      try {
        //* here the code for adding a new transaction
        await Provider.of<TransactionProvider>(context, listen: false)
            .addTransaction(title, description, amount, transactionType);
        showSnackBar(context, 'Transaction Added', SnackBarType.success);
      } catch (error) {
        showSnackBar(context, error.toString(), SnackBarType.error);
      }
      //* editting transaction
    } else if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.editTransaction) {
      String id = editedTransaction!.id;
      DateTime createdAt = editedTransaction!.createdAt;
      double ratioToTotal = editedTransaction!.ratioToTotal;
      TransactionModel newTransaction = TransactionModel(
        id: id,
        title: title,
        description: description,
        amount: amount,
        createdAt: createdAt,
        transactionType: transactionType,
        ratioToTotal: ratioToTotal,
      );

      try {
        //* sending the updating info to the provider
        await Provider.of<TransactionProvider>(context, listen: false)
            .editTransaction(id, newTransaction);
        showSnackBar(context, 'Transaction Updated', SnackBarType.success);
        Navigator.pop(context);
      } catch (error) {
        showSnackBar(context, error.toString(), SnackBarType.error);
      }
    }
  }

  //* text inputs controller
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

//* this initState will provide the required data for this scree to edit
  @override
  void initState() {
    super.initState();
    //* checking if the widget that opened this screen wants to edit a transaction
    if (widget.editingId != null &&
        widget.addTransactionScreenOperations ==
            AddTransactionScreenOperations.editTransaction) {
      //* setting the transaction to edit
      editedTransaction =
          Provider.of<TransactionProvider>(context, listen: false)
              .getTransactionById(widget.editingId as String);
      //* setting the text controllers to the transaction info
      _titleController.text = editedTransaction!.title;
      _descriptionController.text = editedTransaction!.description;
      _priceController.text = editedTransaction!.amount.toString();
      setcurrentActiveTransactionType(editedTransaction!.transactionType);
    }
  }

  @override
  Widget build(BuildContext context) {
    //* this argument to inform this widget that i need to add a quick action not a transaction
    //* when needing to add a quick action i will add the argument to this with the argument:true like in the add_quick_action_button.dart file

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
                    title: appBarTitle,
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
                      onPressed: addTransaction,
                      child: Text(
                        saveButtonText,
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

  String get saveButtonText {
    if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.addQuickAction) {
      return 'Add Quick Action';
    } else if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.addTransaction) {
      return 'Add Transaction';
    } else if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.editQuickAction) {
      return 'Edit Quick Action';
    } else {
      return 'Edit Transaction';
    }
  }

  String get appBarTitle {
    if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.addQuickAction) {
      return 'Add Quick Action';
    } else if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.addTransaction) {
      return 'Add Transaction';
    } else if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.editQuickAction) {
      return 'Edit Quick Action';
    } else {
      return 'Edit Transaction';
    }
  }
}
