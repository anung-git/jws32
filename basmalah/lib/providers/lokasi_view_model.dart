import 'package:basmalah/providers/memori.dart';
import 'package:basmalah/services/btHelper.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:stacked/stacked.dart';
import 'package:location/location.dart';

class LokasiViewModel extends BaseViewModel {
  BluetoothDriver bluetooth;

  double latitude = 0; // _locationData.latitude;
  double longitude = 0; // _locationData.longitude;
  String alamat = "";

  final latitudeTextControler = TextEditingController();
  final longitudeTextControler = TextEditingController();
  final alamatTextControler = TextEditingController();
  // Memori _eprom = new Memori();

  get warnaAppBar => Colors.pink;
  get warnaBackground => Colors.pink[100];
  get warnaJudul => Colors.redAccent[700];
  get warnaOdd => Colors.pink[50];
  get warnaEvent => Colors.pink[100];

  get latitudeControler => latitudeTextControler;
  get longitudeControler => longitudeTextControler;
  get alamatControler => alamatTextControler;

  void init(BluetoothDriver blue) {
    bluetooth = blue;
  }

  void kirim(BuildContext context, BluetoothDriver blue) {}

  Future<void> searchLokasi() async {
    setBusy(true);
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    latitude = _locationData.latitude;
    longitude = _locationData.longitude;

    final coordinates = new Coordinates(1.10, 45.50);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // var first = addresses.first;
    // print("${first.featureName} : ${first.addressLine}");
    // alamat = addresses.first.featureName;
    alamat = addresses.first.addressLine + ',' + addresses.first.featureName;

    setBusy(false);
    latitudeTextControler.text = latitude.toString();
    longitudeTextControler.text = longitude.toString();
    alamatTextControler.text = alamat;
    notifyListeners();
  }
}
