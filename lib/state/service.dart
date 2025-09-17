import 'package:flutter/foundation.dart';

class ServiceProvider extends ChangeNotifier {
  String _status = "未启动";
  String get status => _status;

  void updateStatus(String newStatus) {
    _status = newStatus;
    notifyListeners();
  }
}
