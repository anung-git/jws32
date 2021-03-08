import 'package:basmalah/services/btHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:stacked/stacked.dart';

import '../screens/DiscoveryPage.dart';

class HomeViewModel extends BaseViewModel {
  // bolean
  // integer
  // String
  // class

  BluetoothDriver btSerial = BluetoothDriver();
  // getter
  bool get bluetoothIsConnect => btSerial.isConnected();
  //fungtion / method
  void init() {
    // BluetoothConnection.toAddress(null).then((koneksi) {
    //   koneksi.input.listen(_).onDone(() { })
    // });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  Future hubungkan(var context) async {
    await FlutterBluetoothSerial.instance.state.then((state) async {
      if (state.isEnabled == false) {
        await FlutterBluetoothSerial.instance.requestEnable();
        notifyListeners();
      }
    });
    final BluetoothDevice selectedDevice = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DiscoveryPage();
        },
      ),
    );

    if (selectedDevice != null) {
      print('Connect -> selected ' + selectedDevice.address);
      //menghubungkan ke devices
      await btSerial.connect(selectedDevice);
      await Future.delayed(const Duration(milliseconds: 500), () {
        notifyListeners();
      });
    } else {
      print('Connect -> no device selected');
      notifyListeners();
    }
  }

  // void showSnackBar(var context, String msg) {
  //   final snackBar = SnackBar(content: Text(msg));
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  void updateTime(var context) {
    DateTime waktu = DateTime.now();
    //('kkmmssddMMyyyy')
    String kirim = "";

    kirim = waktu.second < 10
        ? '0' + waktu.second.toString()
        : waktu.second.toString();

    kirim += waktu.minute < 10
        ? '0' + waktu.minute.toString()
        : waktu.minute.toString();

    kirim +=
        waktu.hour < 10 ? '0' + waktu.hour.toString() : waktu.hour.toString();

    kirim += waktu.day < 10 ? '0' + waktu.day.toString() : waktu.day.toString();
    kirim += waktu.month < 10
        ? '0' + waktu.month.toString()
        : waktu.month.toString();
    kirim += (waktu.year - 2000).toString();

    if (btSerial.isConnected() == false) {
      hubungkan(context);
    } else {
      btSerial.setting(context, "%J", kirim);
      // showSnackBar(context, "Waktu telah ter-update");
    }
    // print(kirim);
    // print("update time");
  }

  // btSerial.setting(context, "%J", "330920 060321");
  // btSerial.setting(context, "%T", "101010101026NYYNYY");
  // btSerial.setting(context, "%F", "0800000009");
  // btSerial.setting(context, "%X", "NNNNN12061203120712051833");
}
