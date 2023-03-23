import 'package:flutter/cupertino.dart';
import 'package:smart_wallet/constants/user_helpers_constants.dart';

class UserHelpersProvider extends ChangeNotifier {
  GlobalKey currentActiveKey = addTransactionKey;
  String currentHelperString = addTransactionHelperString;
  bool active = true;

  //? settings active
  void setActive(bool v) {
    active = v;
    notifyListeners();
  }

//? setting the current helper string
  void setCurrentHelperString(String s) {
    currentHelperString = s;
    notifyListeners();
  }

//? setting the current active key
  void setCurrentActiveKey(GlobalKey key) {
    currentActiveKey = key;
    notifyListeners();
  }

  //? add transaction button helper
  // bool addTransactionHelper = true;
  // void setAddTransactionHelper(bool v) {
  //   addTransactionHelper = v;
  //   notifyListeners();
  // }

  //? add quick action button helper
}
