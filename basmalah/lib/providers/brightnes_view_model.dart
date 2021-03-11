import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import '../services/btHelper.dart';
import 'memori.dart';

class BrightnesViewModel extends BaseViewModel {
  final jam = ["03:00", "09:00", "17:00", "21:00"];
  List<int> bright = [5, 5, 5, 5];
  BluetoothDriver bluetooth;
  Memori _eprom = new Memori();

  get warnaAppBar => Colors.pink;
  get warnaBackground => Colors.pink[100];
  get warnaJudul => Colors.redAccent[700];
  get warnaOdd => Colors.pink[50];
  get warnaEvent => Colors.pink[100];

  void kirim(BuildContext context, BluetoothDriver x) async {
    String kirim = '';

    // for (var i = 0; i < 5; i++) {
    //   kirim += fix[i].replaceAll(new RegExp(r':'), '');
    // }
    bluetooth.isConnected() == false
        ? bluetooth.hubungkan(context)
        : bluetooth.setting(context, "%X", kirim);
  }

  init(BluetoothDriver blue) async {
    this.bluetooth = blue;
    for (var i = 0; i < 5; i++) {
      bright[i] = await _eprom.getInt("brightnes" + i.toString()) ?? 5;
    }
    notifyListeners();
  }

  Future<void> save(int index, TimeOfDay waktu) async {
    // fix[index] =
    //     waktu.hour < 10 ? '0' + waktu.hour.toString() : waktu.hour.toString();
    // fix[index] += ':';
    // fix[index] += waktu.minute < 10
    //     ? '0' + waktu.minute.toString()
    //     : waktu.minute.toString();
    // await _eprom.setString("fix" + index.toString(), fix[index]);
    // notifyListeners();
    // await _eprom.setInt("koreksiJadwal" + i.toString(), 0);
  }

  // TimeOfDay getInit(int index) {
  // String jam = fix[index].substring(0, 2);
  // String menit = fix[index].substring(3);
  // TimeOfDay init = TimeOfDay(hour: int.parse(jam), minute: int.parse(menit));
  // return init;
  // }

  int brightnes(int index) {
    return bright[index];
  }

  void setBrightnes(int index, double value) {
    print(value);
    bright[index] = value.toInt();
    notifyListeners();
  }
}
