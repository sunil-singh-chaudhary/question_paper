import 'package:flutter/material.dart';

class lastPageProvider extends ChangeNotifier {
  int? _kindex;
  int? get kindex => _kindex;

  Future<void> setKindex(int index) async {
    _kindex = index;
    notifyListeners();
    // return count;
  }
}
