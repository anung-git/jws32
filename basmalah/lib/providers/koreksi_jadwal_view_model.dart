import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import '../services/btHelper.dart';
import 'memori.dart';

class KoreksiJadwalViewModel extends BaseViewModel {
  List<int> value = [0, 0, 0, 0, 0];
  final sholat = ['Subuh', 'Dzuhur', 'Ashar', "Maghrib", "Isya"];
  BluetoothDriver bluetooth;
  Memori _eprom = new Memori();

  get warnaAppBar => Colors.pink;
  get warnaBackground => Colors.pink[100];
  get warnaJudul => Colors.redAccent[700];
  get warnaOdd => Colors.pink[50];
  get warnaEvent => Colors.pink[100];

  void kirim(BuildContext context, BluetoothDriver x) async {
    String kirim = '';
    kirim += value[0] < 0 ? '0' : '1';
    kirim += value[0].abs().toString();
    kirim += value[1] < 0 ? '0' : '1';
    kirim += value[1].abs().toString();
    kirim += value[2] < 0 ? '0' : '1';
    kirim += value[2].abs().toString();
    kirim += value[3] < 0 ? '0' : '1';
    kirim += value[3].abs().toString();
    kirim += value[4] < 0 ? '0' : '1';
    kirim += value[4].abs().toString();
    bluetooth.isConnected() == false
        ? bluetooth.hubungkan(context)
        : bluetooth.setting(context, "%F", kirim);
  }

  init(BluetoothDriver blue) async {
    this.bluetooth = blue;
    for (var i = 0; i < 5; i++) {
      value[i] = await _eprom.getInt("koreksiJadwal" + i.toString()) ?? 0;
    }
    notifyListeners();
  }

  void incr(int index) async {
    value[index]++;
    if (value[index] > 9) {
      value[index] = -9;
    }
    await _eprom.setInt("koreksiJadwal" + index.toString(), value[index]);
    notifyListeners();
  }

  void decr(int index) async {
    value[index]--;
    if (value[index] < -9) {
      value[index] = 9;
    }
    await _eprom.setInt("koreksiJadwal" + index.toString(), value[index]);
    notifyListeners();
  }

  void restore() async {
    for (var i = 0; i < 5; i++) {
      value[i] = 0;
      await _eprom.setInt("koreksiJadwal" + i.toString(), 0);
    }
    notifyListeners();
  }
}
