import 'dart:ui';

import 'package:basmalah/providers/lokasi_view_model.dart';
import 'package:basmalah/services/btHelper.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Iqomah extends StatefulWidget {
  Iqomah({Key key, this.blue}) : super(key: key);
  final BluetoothDriver blue;
  @override
  _IqomahState createState() => _IqomahState();
}

class _IqomahState extends State<Iqomah> {
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
                  'Iqomah',
                  // style: kTextStyleBold,
                ),
              ),
              resizeToAvoidBottomInset: false,
              body: Container(
                color: model.warnaBackground,
                padding: EdgeInsets.all(10),
                child: Card(
                  child: Container(
                    margin: EdgeInsets.only(left: 3, right: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 15, bottom: 10),
                          child: Center(
                            child: Text(
                              "Pengaturan Iqomah",
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
                                    hintText: "Lama sholat...",
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
                        SizedBox(
                          height: 90,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              height: 50.0,
                              width: 130,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    side: BorderSide(
                                        color: Color.fromRGBO(0, 160, 227, 1))),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                padding: EdgeInsets.all(10.0),
                                color: Color.fromRGBO(0, 160, 227, 1),
                                textColor: Colors.white,
                                child: Text("Batal",
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              height: 50.0,
                              width: 130,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    side: BorderSide(color: Colors.pink[600])),
                                // color: Color.fromRGBO(0, 160, 227, 1))),
                                onPressed: () {},
                                padding: EdgeInsets.all(10.0),
                                color: Colors
                                    .pink //Color.fromRGBO(0, 160, 227, 1),
                                ,
                                textColor: Colors.white,
                                child: Text("Kirim",
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
