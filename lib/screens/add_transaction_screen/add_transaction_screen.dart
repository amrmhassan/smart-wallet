// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/models/debt_model.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/providers/debts_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/screens/add_transaction_screen/widgets/debt_controller.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';
import '../../constants/sizes.dart';
import '../../constants/types.dart';
import '../../models/quick_action_model.dart';
import '../../models/transaction_model.dart';
import '../../providers/quick_actions_provider.dart';
import '../../providers/transactions_provider.dart';
import '../../utils/general_utils.dart';
import '../../utils/transactions_utils.dart';
import '../../widgets/calculator/calculator.dart';
import '../../widgets/global/line.dart';

import '../../widgets/app_bar/my_app_bar.dart';
import '../home_screen/widgets/background.dart';
import 'widgets/left_side_add_transaction.dart';
import 'widgets/right_side_add_transaction.dart';

enum AddTransactionScreenOperations {
  addTransaction,
  addQuickAction,
  editTransaction,
  editQuickAction,
  addDebt,
  editDebt,
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
  DebtModel? editedDebt;
  double amount = 0;

  //* for setting the current active transaction type and it will be passed down to the widget that will use it
  void setcurrentActiveTransactionType(TransactionType transactionType) {
    setState(() {
      currentActiveTransactionType = transactionType;
    });
  }

  void setAmount(double result) {
    if (result == double.infinity) {
      return showSnackBar(
          context, 'You can\'t add infinity number', SnackBarType.error);
    }

    setState(() {
      amount = result;
    });
  }

//* this method will be executed whenever the save button in the calculator is clicked
  Future<void> handleSaveButtonClick() async {
    //* preparing the needed info to add the new thing(transaction or quick action)
    String title = _titleController.text.isEmpty
        ? 'Empty Title'
        : _titleController.text.trim();
    String debtTitle = _debtTitleController.text.isEmpty
        ? 'Empty Title'
        : _debtTitleController.text.trim();
    String description = _descriptionController.text.isEmpty
        ? 'Empty Description'
        : _descriptionController.text.trim();
    TransactionType transactionType = currentActiveTransactionType;
    ProfileModel activeProfile =
        Provider.of<ProfilesProvider>(context, listen: false)
            .getActiveProfile();

    if (amount <= 0) {
      return;
    }

    if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.addQuickAction) {
      //* add quick action
      return addQuickAction(
        title: title,
        description: description,
        transactionType: transactionType,
        context: context,
        amount: amount,
      );
    } else if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.addTransaction) {
      //* add transaction
      return showAddHighTransactionDialog(
        title: title,
        description: description,
        activeProfile: activeProfile,
        transactionType: transactionType,
        context: context,
        amount: amount,
      );
    } else if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.editTransaction) {
      //* edit transaction
      return editTransaction(
        title: title,
        description: description,
        transactionType: transactionType,
        activeProfile: activeProfile,
        context: context,
        amount: amount,
        oldTransaction: editedTransaction!,
      );
    } else if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.editQuickAction) {
      //* edit quick action
      return editQuickAction(
        title: title,
        description: description,
        transactionType: transactionType,
        activeProfile: activeProfile,
        context: context,
        amount: amount,
        oldQuickaction: editedQuickAction!,
      );
    } else if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.addDebt) {
      //* add debt
      return addDebt(
        context: context,
        title: debtTitle,
        amount: amount,
        borrowingProfileId: borrowingProfileId,
      );
    } else if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.editDebt) {
      return editDebt(
        context: context,
        title: debtTitle,
        amount: amount,
        borrowingProfileId: borrowingProfileId,
        id: widget.editingId!,
      );
    }
  }

  //* text inputs controller
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _debtTitleController = TextEditingController();
  String borrowingProfileId = '';

  void setBorrowingProfileId(String profileId) {
    setState(() {
      borrowingProfileId = profileId;
    });
  }
  // final TextEditingController _priceController = TextEditingController();

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
              .getActiveProfileTransactionById(widget.editingId as String);
      //* setting the text controllers to the transaction info
      _titleController.text = editedTransaction!.title;
      _descriptionController.text = editedTransaction!.description;
      setState(() {
        amount = editedTransaction!.amount;
      });
      setcurrentActiveTransactionType(editedTransaction!.transactionType);
    } else if (widget.editingId != null &&
        widget.addTransactionScreenOperations ==
            AddTransactionScreenOperations.editQuickAction) {
      //* setting the transaction to edit
      editedQuickAction =
          Provider.of<QuickActionsProvider>(context, listen: false)
              .getActiveProfileQuickById(widget.editingId as String);

      //* setting the text controllers to the transaction info
      _titleController.text = editedQuickAction!.title;
      _descriptionController.text = editedQuickAction!.description;
      setState(() {
        amount = editedQuickAction!.amount;
      });
      setcurrentActiveTransactionType(editedQuickAction!.transactionType);
    } else if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.addDebt) {
      //* setting the borrowing profile id to the active profile
      String activeProfileId =
          Provider.of<ProfilesProvider>(context, listen: false)
              .activatedProfileId;
      setState(() {
        borrowingProfileId = activeProfileId;
      });
    } else if (widget.editingId != null &&
        widget.addTransactionScreenOperations ==
            AddTransactionScreenOperations.editDebt) {
      editedDebt = Provider.of<DebtsProvider>(context, listen: false)
          .getDebtById(widget.editingId as String);

      _debtTitleController.text = editedDebt!.title;
      setAmount(editedDebt!.amount);
      setBorrowingProfileId(editedDebt!.borrowingProfileId);
    } else {
      //* 1] setting the current active transaction type according to the user adding a transaction from the transactions screen
      //* if the current active transaction type is income then activate the income first else activate the outcome first
      var transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);
      if (transactionProvider.currentActiveTransactionType ==
          TransactionType.income) {
        setcurrentActiveTransactionType(TransactionType.income);
      } else if (transactionProvider.currentActiveTransactionType ==
          TransactionType.outcome) {
        setcurrentActiveTransactionType(TransactionType.outcome);
      }

      //* 2] making the current active transaction type to be income if the current active profile total money is lower 0
      String activeProfileId =
          Provider.of<ProfilesProvider>(context, listen: false)
              .activatedProfileId;
      double currentActiveProfileTotalMoney =
          Provider.of<ProfilesProvider>(context, listen: false)
              .getProfileDataById(activeProfileId)
              .totalMoney;
      if (currentActiveProfileTotalMoney <= 0) {
        setcurrentActiveTransactionType(TransactionType.income);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //* this argument to inform this widget that i need to add a quick action not a transaction
    //* when needing to add a quick action i will add the argument to this with the argument:true like in the add_quick_action_button.dart file

    return Scaffold(
      extendBodyBehindAppBar: true,
      //? this will prevent the screen to resize whenever keyboard is opened
      resizeToAvoidBottomInset: false,

      //* this is the drawer
      drawer: Drawer(
        child: Container(
          color: Colors.white,
        ),
      ),
      //? this gesture detector will remove the focus whenever anything else is clicked in the screen
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            //* this is the background of the screen
            const Background(),

            SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                child: Column(
                  children: [
                    //* my custom app bar and the mainAppBar is equal to false for adding the back button and remove the menu icon(side bar opener)
                    MyAppBar(
                      title: appBarTitle,
                    ),
                    //* space between the app bar and the next widget
                    const SizedBox(
                      height: 40,
                    ),
                    //* the main container of the adding new transaction cart which will have the main padding around the edges of the screen
                    widget.addTransactionScreenOperations ==
                                AddTransactionScreenOperations.addDebt ||
                            widget.addTransactionScreenOperations ==
                                AddTransactionScreenOperations.editDebt
                        ? DebtController(
                            borrowingProfileId: borrowingProfileId,
                            amount: amount,
                            debtTitleController: _debtTitleController,
                            setBorrowingProfileId: setBorrowingProfileId,
                          )
                        : CustomCard(
                            padding: const EdgeInsets.all(kDefaultPadding / 2),
                            height: 200,
                            //* the row which will have the main sides of the cart
                            child: Row(
                              children: [
                                //* the left side is for adding the title and description
                                LeftSideAddTransaction(
                                  titleController: _titleController,
                                  descriptionController: _descriptionController,
                                ),
                                const Line(lineType: LineType.vertical),
                                //* the right side is for adding the price and transaction type
                                RightSideAddTransaction(
                                  currentActiveTransactionType:
                                      currentActiveTransactionType,
                                  setCurrentActiveTransactionType:
                                      setcurrentActiveTransactionType,
                                  amount: amount,
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: kDefaultPadding,
                    ),
                    Expanded(
                      child: Calculator(
                        //? here editting the amount of get from the calculator
                        setResults: (result) => setAmount(result),
                        saveTransaction: handleSaveButtonClick,
                        initialAmount: amount.toString(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
    } else if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.addDebt) {
      return 'Add Debt';
    } else if (widget.addTransactionScreenOperations ==
        AddTransactionScreenOperations.editDebt) {
      return 'Edit Debt';
    } else {
      return 'Unknown Operation';
    }
  }
}
