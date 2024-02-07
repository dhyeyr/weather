import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool isNet = true;
  ConnectivityResult connectivityResult = ConnectivityResult.none;

  void addNetListener() {
    Connectivity().onConnectivityChanged.listen((event) {
      connectivityResult = event;
      // Notify listeners only when there's a change in connectivity status
      if ((isNet && event == ConnectivityResult.none) ||
          (!isNet && event != ConnectivityResult.none)) {
        changeNetConnection(event != ConnectivityResult.none);
        notifyListeners();
      }
    });
  }

  void changeNetConnection(bool isNet) {
    this.isNet = isNet;
  }
}
