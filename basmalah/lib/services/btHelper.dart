import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDriver {
  List<String> command = [
    "OKJ\n",
    "OKS\n",
    "OKI\n",
    "OKT\n",
    "OKB\n",
    "OKF\n",
    "OKX\n",
    "OKK\n",
    "OKA\n",
    "OKW\n",
  ];
  List<String> datafinish = [
    "SetPlay\n",
    "SetTime\n",
    "SetIqom\n",
    "SetTrkm\n",
    "SetBrns\n",
    "SetOffs\n",
    "SetFixx\n",
    "SetKoor\n",
    "SetAlrm\n",
  ];
  String cmd = "";
  String data = "";
  String terimaData = "";

  int _discoverableTimeoutSecondsLeft = 0;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothConnection connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;
  bool koneksi = false;
  bool get terhubung => koneksi;
  bool isDisconnecting = false;
  String _address = "...";
  String _name = "...";
  String _messageBuffer = '';
  static final clientID = 0;
  BluetoothDriver() {
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) async {
      _bluetoothState = state;
      // setState(() {
      // });
      if (state.isEnabled == false) {
        await FlutterBluetoothSerial.instance.requestEnable();
      }
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        _address = address;
        // setState(() {
        // });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      _name = name;
      // setState(() {
      // });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      _bluetoothState = state;
      // Discoverable mode is disabled when Bluetooth gets disabled
      // _discoverableTimeoutTimer = null;
      _discoverableTimeoutSecondsLeft = 0;
      // setState(() {
      // });
    });
  }

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

  Future setting(String cmd, String data) async {
    this.cmd = cmd;
    this.data = data;
    await this.sendMessage("1234");
  }

  void request(String data) {
    // print(data);
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
    else if (datafinish.contains(data)) {
      datafinish.forEach((element) {
        if (element == data) {
          print("setting suksess");
        }
      });
    } else {
      print("command error");
    }
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

  void connect(final BluetoothDevice server) {
    BluetoothConnection.toAddress(server.address).then((_connection) {
      print('Connected to the device');
      koneksi = true;
      connection = _connection;
      isConnecting = false;
      isDisconnecting = false;
      // setState(() {
      // });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          koneksi = false;
          print('Disconnecting locally!');
        } else {
          koneksi = false;
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
