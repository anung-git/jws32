import 'dart:convert';
import 'dart:typed_data';
import 'package:basmalah/screens/DiscoveryPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDriver {
  final command = [
    "OKJ\n", //jam
    "OKI\n", //Iqomah
    "OKT\n", //tarhim
    "OKB\n", //brightness
    "OKF\n", //offsite
    "OKX\n", //fix
    "OKK\n", //kota
    "OKA\n", //adzan
    "OKW\n", //mp3
    "OKS\n",
  ];
  final cmdOK = [
    "SINKRON WAKTU SUKSES",
    "SET IQOMAH SUKSES",
    "SET TARHIM SUKSES",
    "SET BRIGTNES SUKSES",
    "SET OFFSITE SUKSES",
    "SET FIX SUKSES",
    "SET KOTA SUKSES",
    "SET TIMEOUT ADZAN SUKSES",
    "SUKSES",
    "SUKSES",
  ];
  final datafinish = [
    "SetTime\n",
    "SetIqom\n",
    "SetTrkm\n",
    "SetBrns\n",
    "SetOffs\n",
    "SetFixx\n", //SetFixx\n"
    "SetKoor\n",
    "SetAlrm\n",
    "SetPlay\n",
  ];
//boolean
  bool isConnecting = true;
  bool isDisconnecting = false;
  //integer
  // int _discoverableTimeoutSecondsLeft = 0;
  static final clientID = 0;

  //String
  String cmd = "";
  String data = "";
  String terimaData = "";
  BuildContext context;
  //class
  // BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothConnection connection;

  //getter
  bool isConnected() {
    // if (connection == null) {
    //   return false;
    // } else {
    //   if (connection.isConnected == null) {
    //     return false;
    //   } else {
    //     return connection.isConnected;
    //   }
    // }
    return connection == null ? false : connection.isConnected;
  }

//constructor
  BluetoothDriver() {
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) async {
      // _bluetoothState = state;
      if (state.isEnabled == false) {
        await FlutterBluetoothSerial.instance.requestEnable();
      }
    });

    // Future.doWhile(() async {
    //   // Wait if adapter not enabled
    //   if (await FlutterBluetoothSerial.instance.isEnabled) {
    //     return false;
    //   }
    //   await Future.delayed(Duration(milliseconds: 0xDD));
    //   return true;
    // }).then((_) {
    // Update the address field
    // FlutterBluetoothSerial.instance.address.then((address) {
    //   String _address = address;
    //   // setState(() {
    //   // });
    // });
    // });

    // FlutterBluetoothSerial.instance.name.then((name) {
    //   String _name = name;
    //   // setState(() {
    //   // });
    // });

    // Listen for futher state changes
    // FlutterBluetoothSerial.instance
    //     .onStateChanged()
    //     .listen((BluetoothState state) {
    // _bluetoothState = state;
    // Discoverable mode is disabled when Bluetooth gets disabled
    // _discoverableTimeoutTimer = null;
    // _discoverableTimeoutSecondsLeft = 0;
    // setState(() {
    // });
    // });
  }

  Future<bool> hubungkan(var context) async {
    await FlutterBluetoothSerial.instance.state.then((state) async {
      if (state.isEnabled == false) {
        await FlutterBluetoothSerial.instance.requestEnable();
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
      // print('Connect -> selected ' + selectedDevice.address);
      //menghubungkan ke devices
      await this.connect(selectedDevice);
      return true;
    } else {
      return false;
    }
  }

  //method / Fungsi
  Future sendMessage(String text) async {
    text = text.trim();
    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text));
        await connection.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
        // setState(() {});
      }
    }
  }

  Future setting(BuildContext context, String cmd, String data) async {
    this.context = context;
    this.cmd = cmd;
    this.data = data;
    await this.sendMessage("1234");
  }

  void request(String data) {
    //start command
    if (data == "OK\n") {
      this.sendMessage(this.cmd);
    }
    // instruction command
    else if (command.contains(data)) {
      command.forEach((element) {
        if (element == data) {
          this.sendMessage(this.data);
        }
      });
    }
    //finish command
    // erer
    else if (datafinish.contains(data)) {
      datafinish.forEach((element) {
        if (element == data) {
          String msg = cmdOK[datafinish.indexOf(element)];
          showSnackBar(this.context, msg);
        }
      });
    } else {
      showSnackBar(this.context, "COMMAND ERROR");
    }
  }

  void showSnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
        content: Text(
      msg,
      textAlign: TextAlign.center,
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }
    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);

    terimaData += dataString;
    if (terimaData.contains('\n')) {
      request(terimaData);
      terimaData = "";
    }
  }

  Future connect(final BluetoothDevice server) async {
    if (connection != null && connection.isConnected == true) {
      await connection.close();
    }
    await BluetoothConnection.toAddress(server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      isConnecting = false;
      isDisconnecting = false;

      // connection.input.any((element) => false);
      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        // if (this.mounted) {
        //   setState(() {});
        // }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }
}
