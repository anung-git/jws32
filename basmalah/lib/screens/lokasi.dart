import 'dart:ui';

import 'package:basmalah/providers/lokasi_view_model.dart';
import 'package:basmalah/services/btHelper.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Lokasi extends StatefulWidget {
  Lokasi({Key key, this.blue}) : super(key: key);
  final BluetoothDriver blue;
  @override
  _LokasiState createState() => _LokasiState();
}

class _LokasiState extends State<Lokasi> {
  Future<TimeOfDay> setJamx(var contex, TimeOfDay initTime) async {
    TimeOfDay hasil = await showTimePicker(
      context: context,
      initialTime: initTime,
      // TimeOfDay.now(), //TimeOfDay(hour: 10, minute: 47),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              // change the border color
              primary: Colors.pink,
              // change the text color
              onSurface: Colors.purple,
            ),
            // button colors
            buttonTheme: ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: Colors.green,
              ),
            ),
          ),
          child: child,
        );
      },
    );
    return hasil == null ? initTime : hasil;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return ViewModelBuilder<LokasiViewModel>.reactive(
          viewModelBuilder: () => LokasiViewModel(),
          onModelReady: (model) => model.init(widget.blue),
          builder: (context, model, chaild) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: model.warnaAppBar,
                centerTitle: true,
                title: Text(
                  'Lokasi',
                  // style: kTextStyleBold,
                ),
                actions: [
                  IconButton(
                      icon: Icon(Icons.location_searching),
                      onPressed: () async {
                        await model.searchLokasi();
                      })
                ],
              ),
              resizeToAvoidBottomInset: false,
              body: Container(
                color: model.warnaBackground,
                padding: EdgeInsets.all(10),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 15, bottom: 10),
                        child: Center(
                          child: Text(
                            "Pengaturan Lokasi",
                            style: TextStyle(
                                color: model.warnaJudul,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 10, right: 10, bottom: 15),
                        child: Divider(
                          color: Colors.redAccent[400],
                          thickness: 3,
                        ),
                      ),
                      Container(
                        color: Colors.orange[100],
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10, left: 10),
                              child: TextField(
                                controller: model.latitudeControler,
                                decoration: InputDecoration(
                                  hintText: "Latitude...",
                                  hintStyle: TextStyle(
                                    color: Colors.purple,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                // decoration: ,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10, left: 10),
                              child: TextField(
                                controller: model.longitudeControler,
                                decoration: InputDecoration(
                                  hintText: "Longitude...",
                                  hintStyle: TextStyle(
                                    color: Colors.purple,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10, left: 10),
                              child: TextField(
                                // minLines: 5,
                                maxLines: 7,
                                controller: model.alamatControler,
                                decoration: InputDecoration(
                                  hintText: "Alamat...",
                                  hintStyle: TextStyle(
                                    color: Colors.purple,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              model.kirim(context, widget.blue);
                            },
                            child: Text("Kirim"),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.pink,
                              onPrimary: Colors.white,
                              onSurface: Colors.grey,
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          Container(
                            width: 10,
                          )
                        ],
                      ),
                    ],
                  ),
                  // ),
                ),
              ),
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () {
              //     print("searching lokasi");
              //   },
              //   child: Icon(Icons.location_searching),
              // ),
            );
          });
    });
  }
}
