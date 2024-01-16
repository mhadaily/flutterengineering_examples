import 'package:flutter/foundation.dart';

typedef CommandAction = Future<void> Function();

class Command extends ChangeNotifier {
  final CommandAction _action;
  bool _isExecuting = false;

  Command(this._action);

  bool get isExecuting => _isExecuting;

  Future<void> execute() async {
    if (_isExecuting) return;
    _isExecuting = true;
    // Notify listeners when starting execution
    notifyListeners();

    try {
      await _action();
    } finally {
      _isExecuting = false;
      // Notify listeners when execution ends
      notifyListeners();
    }
  }
}
