import 'package:basmalah/services/btHelper.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  // bolean
  // integer
  // String
  // class

  BluetoothDriver btSerial = BluetoothDriver();
  // getter
  bool get bluetoothIsConnect => btSerial.isConnected();
  Future<void> bluetoothConnect(var context) async {
    setBusy(true);
    notifyListeners();
    await btSerial.hubungkan(context);
    setBusy(false);
    notifyListeners();
  }

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
      btSerial.hubungkan(context);
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
