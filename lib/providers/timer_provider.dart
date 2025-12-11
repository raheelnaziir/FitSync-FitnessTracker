import 'package:flutter/material.dart';
import 'dart:async';

class TimerProvider extends ChangeNotifier {
  int _seconds = 0;
  Timer? _timer;
  bool _isRunning = false;

  int get seconds => _seconds;
  bool get isRunning => _isRunning;

  void startTimer() {
    if (_isRunning) return;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _seconds++;
      notifyListeners();
    });
    _isRunning = true;
    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    stopTimer();
    _seconds = 0;
    notifyListeners();
  }

  String formatTime() {
    int hours = _seconds ~/ 3600;
    int mins = (_seconds % 3600) ~/ 60;
    int secs = _seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
