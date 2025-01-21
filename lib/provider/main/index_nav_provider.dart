import 'package:flutter/widgets.dart';

class IndexNavProvider with ChangeNotifier {
  var _indexBottomNavBar = 0;
  int get indexBottomNavBar => _indexBottomNavBar;

  set setIndexBottomNavBar(int index) {
    _indexBottomNavBar = index;
    notifyListeners();
  }
}
