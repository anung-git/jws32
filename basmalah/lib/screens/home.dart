import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basmalah/providers/home_view_model.dart';
import 'package:basmalah/screens/brightnes.dart';
import 'package:basmalah/screens/iqomah.dart';
import 'package:basmalah/screens/lokasi.dart';
import 'package:basmalah/screens/runingtext.dart';
import 'package:basmalah/screens/set_fix.dart';
import 'package:basmalah/screens/settings_screen.dart';
import 'package:basmalah/screens/tartil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:grafpix/icons.dart';
import 'koreksi_jadwal.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onModelReady: (model) => null,
        builder: (context, model, chaild) {
          return Scaffold(
            appBar: AppBar(
              // backgroundColor: Colors.orange,
              title: Text(widget.title),
              actions: [
                model.isBusy
                    ? FittedBox(
                        child: Container(
                          margin: new EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : IconButton(
                        // hoverColor: Colors.yellow,
                        color: model.bluetoothIsConnect == true
                            ? Colors.green
                            : Colors.red,
                        splashColor: Colors.red,
                        icon: Icon(model.bluetoothIsConnect == true
                            ? Icons.bluetooth
                            : Icons.bluetooth_disabled),
                        onPressed: () async {
                          await model.bluetoothConnect(context);
                          // bool hasil = await model.btSerial.hubungkan(context);
                          // if (hasil == true) {
                          //   setState(() {});
                          // }
                        })
              ],
            ),
            body: Container(
              margin: EdgeInsets.only(top: 7),
              child: Padding(
                padding: const EdgeInsets.only(left: 7, right: 7),
                child: GridView.count(
                  crossAxisCount: 3,
                  children: <Widget>[
                    Menu(
                      gambar: Icons.sync, //PixIcon.fa_sync,
                      text: 'Sinkronisasi waktu',
                      warna: Colors.green,
                      onClick: () async {
                        if (model.bluetoothIsConnect == false) {
                          bool connect =
                              await model.btSerial.hubungkan(context);
                          if (connect == true) {
                            setState(() {});
                          }
                        } else {
                          AwesomeDialog(
                              context: context,
                              headerAnimationLoop: false,
                              dialogType: DialogType.NO_HEADER,
                              title: 'Sinkron waktu',
                              desc:
                                  'Samakan waktu di perangkat dengan waktu di android',
                              btnOkOnPress: () {
                                model.updateTime(context);
                              },
                              btnCancelOnPress: () {
                                print("Cancel");
                              }).show();
                        }
                      },
                    ),
                    Menu(
                      gambar: PixIcon.pix_file_text2,
                      warna: Colors.blue,
                      text: 'Edit Text',
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RunningText(
                                    blue: model.btSerial,
                                  )),
                        );
                      },
                    ),
                    Menu(
                      gambar: PixIcon.fa_map_marked_alt,
                      text: 'Seting Kota',
                      warna: Colors.red,
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Lokasi(
                              blue: model.btSerial,
                            ),
                          ),
                        );
                      },
                    ),
                    Menu(
                      gambar: PixIcon.pix_brightness_contrast,
                      warna: Colors.yellow,
                      text: 'Kecerahan',
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Brightnes(
                              blue: model.btSerial,
                            ),
                          ),
                        );
                      },
                    ),
                    Menu(
                      gambar: PixIcon.pix_alarm,
                      warna: Colors.pink,
                      text: 'Alarm',
                      onClick: () {},
                    ),
                    Menu(
                      gambar: PixIcon.fa_mosque,
                      warna: Colors.purple,
                      text: 'Iqomah',
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Iqomah(
                                    blue: model.btSerial,
                                  )),
                        );
                      },
                    ),
                    Menu(
                      gambar: PixIcon.typcn_sort_numerically_outline,
                      warna: Colors.pink,
                      text: 'Fix Jadwal',
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetFix(
                                    blue: model.btSerial,
                                  )),
                        );
                      },
                    ),
                    Menu(
                      gambar: PixIcon.calendar_wall,
                      warna: Colors.brown,
                      text: 'Koreksi Jadwal',
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => KoreksiJadwal(
                                    blue: model.btSerial,
                                  )),
                        );
                      },
                    ),
                    Menu(
                      gambar: PixIcon.pix_stopwatch,
                      warna: Colors.greenAccent,
                      text: 'Lama Adzan',
                      onClick: () {},
                    ),
                    Menu(
                      gambar: Icons.settings_backup_restore,
                      warna: Colors.blueAccent,
                      text: 'Reset Pabrik',
                      onClick: () {},
                    ),
                    Menu(
                      gambar: PixIcon.pix_volume_high,
                      warna: Colors.redAccent,
                      text: 'Tartil',
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Tartil(
                                    blue: model.btSerial,
                                  )),
                        );
                      },
                    ),
                    Menu(
                      gambar: Icons.settings,
                      warna: Colors.blueGrey,
                      text: 'Pengaturan',
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen(
                                  // blue: model.btSerial,
                                  )),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {},
            //   tooltip: 'Increment',
            //   child: Icon(Icons.add),
            // ),
          );
        });
  }
}

class Menu extends StatelessWidget {
  Menu({this.gambar, this.warna, this.text, this.onClick});
  final IconData gambar;
  final String text;
  final Color warna;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        margin: EdgeInsets.all(1.50),
        color: Colors.black12,
        // color: Colors.white10,
        // borderRadius: BorderRadius.all(Radius.circular(10)),
        // child: new Material(
        child: new InkWell(
          // borderRadius: BorderRadius.all(Radius.circular(10)),
          splashColor: Colors.greenAccent,
          onTap: () {
            onClick();
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  gambar,
                  size: 55,
                  color: warna,
                ),
                Text(
                  text,
                  style: TextStyle(fontSize: 12.0),
                )
              ],
            ),
          ),
        ),
        // color: Colors.transparent,
        // ),
      ),
    );
  }
}
