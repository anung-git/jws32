import 'package:basmalah/services/btHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:stacked/stacked.dart';

import '../screens/DiscoveryPage.dart';

class HomeViewModel extends BaseViewModel {
  BluetoothDriver btSerial = BluetoothDriver();
  int _counter = 0;
  int get counter => _counter;

  void hubungkan(var context) async {
    final BluetoothDevice selectedDevice = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DiscoveryPage();
        },
      ),
    );

    if (selectedDevice != null) {
      print('Connect -> selected ' + selectedDevice.address);
      btSerial.connect(selectedDevice);
    } else {
      print('Connect -> no device selected');
    }
  }

  void init() {}
  void incrementCounter(var context) {
    _counter++;

    if (btSerial.terhubung == false) {
      hubungkan(context);
    } else {
      btSerial.setting("%J", "330920060321");
      // btSerial.setting("%T", "101010101026NYYNYY");
      // btSerial.setting("%F", "0800000009");
      // btSerial.setting("%X", "NNNNN12061203120712051833");
    }
    notifyListeners();
  }
}
