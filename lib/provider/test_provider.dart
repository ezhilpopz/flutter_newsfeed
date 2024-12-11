import 'package:flutter/material.dart';

class TestProvider extends ChangeNotifier {
  String? _currenttime;
  String? get currenttime => _currenttime;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void getDateTime() async {
    while (true) {
      setLoading(true);
      await Future.delayed(const Duration(seconds: 3));

      _currenttime = DateTime.now().toString();
      print(_currenttime);
      notifyListeners();
      setLoading(false);
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
