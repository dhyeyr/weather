import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../model/connect_model.dart';

class ConnectivityProvider extends ChangeNotifier {
  Connectivity connectivity = Connectivity();

  ConnectivityModel connection = ConnectivityModel(status: "Waiting");

  checkInternetConnectivity() {
    connection.connectivityStream = connectivity.onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      switch (connectivityResult) {
        case ConnectivityResult.wifi:
          connection.status = "WIFI";
          notifyListeners();
          break;

        case ConnectivityResult.mobile:
          connection.status = "MOBILE DATA";
          notifyListeners();
          break;

        default:
          connection.status = "Waiting";
          notifyListeners();
          break;
      }
    });
  }
}


