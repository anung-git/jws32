import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import '../services/btHelper.dart';
import 'memori.dart';

class TartilViewModel extends BaseViewModel {
  final sholat = ['Subuh', 'Dzuhur', 'Ashar', "Maghrib", "Isya"];
  List<String> tartil = ["00", "00", "00", "00", "00"];
  List<bool> flag = [false, false, false, false, false];
  BluetoothDriver bluetooth;
  Memori _eprom = new Memori();

  get warnaAppBar => Colors.pink;
  get warnaBackground => Colors.pink[100];
  get warnaJudul => Colors.redAccent[700];
  get warnaOdd => Colors.pink[50];
  get warnaEvent => Colors.pink[100];

  // get getflag => null;

  void kirim(BuildContext context, BluetoothDriver x) async {
    String kirim = '';
    // kirim += value[0] < 0 ? '0' : '1';
    // kirim += value[0].abs().toString();
    // kirim += value[1] < 0 ? '0' : '1';
    // kirim += value[1].abs().toString();
    // kirim += value[2] < 0 ? '0' : '1';
    // kirim += value[2].abs().toString();
    // kirim += value[3] < 0 ? '0' : '1';
    // kirim += value[3].abs().toString();
    // kirim += value[4] < 0 ? '0' : '1';
    // kirim += value[4].abs().toString();

    // NYNYN12061203120712051833

    // for (var i = 0; i < 5; i++) {
    //   kirim += flag[i] == true ? 'Y' : 'N';
    // }
    // for (var i = 0; i < 5; i++) {
    //   kirim += tartil[i].replaceAll(new RegExp(r':'), '');
    // }
    bluetooth.isConnected() == false
        ? bluetooth.hubungkan(context)
        : bluetooth.setting(context, "%X", kirim);
  }

  init(BluetoothDriver blue) async {
    this.bluetooth = blue;
    for (var i = 0; i < 5; i++) {
      tartil[i] = await _eprom.getString("tartil" + i.toString()) ?? "00";
      if (tartil[i] == '') {
        tartil[i] = '00';
      }
      flag[i] = await _eprom.getBool("flagtartil" + i.toString()) ?? false;
    }
    notifyListeners();
  }

  Future<void> save(int index, TimeOfDay waktu) async {
    tartil[index] =
        waktu.hour < 10 ? '0' + waktu.hour.toString() : waktu.hour.toString();
    tartil[index] += ':';
    tartil[index] += waktu.minute < 10
        ? '0' + waktu.minute.toString()
        : waktu.minute.toString();
    await _eprom.setString("tartil" + index.toString(), tartil[index]);
    notifyListeners();
    // await _eprom.setInt("koreksiJadwal" + i.toString(), 0);
  }

  Future<void> enable(int index, bool value) async {
    flag[index] = value;
    await _eprom.setBool("flagtartil" + index.toString(), value);
    notifyListeners();
  }

  TimeOfDay getInit(int index) {
    String jam = tartil[index].substring(0, 2);
    String menit = tartil[index].substring(3);
    TimeOfDay init = TimeOfDay(hour: int.parse(jam), minute: int.parse(menit));
    return init;
  }
}
