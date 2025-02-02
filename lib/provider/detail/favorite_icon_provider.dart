import 'package:flutter/widgets.dart';

class FavoriteIconProvider with ChangeNotifier {
  var _isFavored = false;
  get isFavored => _isFavored;
  set isFavored(value) {
    _isFavored = value;
    notifyListeners();
  }
}
