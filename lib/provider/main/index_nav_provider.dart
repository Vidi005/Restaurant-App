import 'package:flutter/widgets.dart';

class IndexNavProvider with ChangeNotifier {
  var _indexBottomNavBar = 0;
  get indexBottomNavBar => _indexBottomNavBar;

  set setIndexBottomNavBar(index) {
    _indexBottomNavBar = index;
    notifyListeners();
  }
}
