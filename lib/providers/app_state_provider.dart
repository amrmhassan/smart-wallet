import 'package:flutter/cupertino.dart';

class AppStateProvider extends ChangeNotifier {
  bool firstTimeRunApp = false;
  void setFirstTimeRunApp(bool v) {
    firstTimeRunApp = v;
    notifyListeners();
  }
}
