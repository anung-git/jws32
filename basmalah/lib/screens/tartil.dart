import 'dart:ui';

import 'package:basmalah/providers/set_fix_view_model.dart';
import 'package:basmalah/providers/tartil_view_model.dart';
import 'package:basmalah/services/btHelper.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Tartil extends StatefulWidget {
  Tartil({Key key, this.blue}) : super(key: key);
  final BluetoothDriver blue;
  @override
  _TartilState createState() => _TartilState();
}

//seting sesuai init terahir
// bila null return terahir

class _TartilState extends State<Tartil> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return ViewModelBuilder<TartilViewModel>.reactive(
          viewModelBuilder: () => TartilViewModel(),
          onModelReady: (model) => model.init(widget.blue),
          builder: (context, model, chaild) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: model.warnaAppBar,
                centerTitle: true,
                title: Text(
                  'Tartil',
                  // style: kTextStyleBold,
                ),
              ),
              resizeToAvoidBottomInset: false,
              body: Container(
                color: model.warnaBackground,
                padding: EdgeInsets.all(10),
                child: Card(
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                      left: 3,
                      right: 3,
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 15, bottom: 10),
                          child: Center(
                            child: Text(
                              "Pengaturan Tartil",
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
                        Expanded(
                          child: ListView.separated(
                            itemCount: 5, //_treatments.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.only(right: 10),
                                height: 60,
                                color: index.isOdd
                                    ? model.warnaOdd
                                    : model.warnaEvent,
                                // height: 55,
                                child: Row(
                                  // mainAxisSize: MainAxisAlignment.spaceAround,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Checkbox(
                                            value: model.flag[index],
                                            onChanged: (bool value) async {
                                              await model.enable(index, value);
                                              // print(value);
                                            }),
                                        // value: rememberMe,
                                        // onChanged: _onRememberMeChanged
                                        // );
                                        Text(
                                          model.sholat[index],
                                          style: TextStyle(
                                              color: Colors.grey[700],

                                              // fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          textAlign: TextAlign.left,
                                        ),
                                        Container(
                                          width: 20,
                                        )
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        // Switch(
                                        //     value: model.flag[index],
                                        //     onChanged: (bool value) async {
                                        //       await model.enable(index, value);
                                        //       // print(value);
                                        //     }),
                                        VerticalDivider(
                                          thickness: 3,
                                          color: Colors.grey,
                                          indent: 7,
                                          endIndent: 7,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // model.save(index);
                                          },
                                          child: Text(
                                            model.tartil[index] + " menit",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.grey[700]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // ),
                              );
                            },
                            separatorBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 0.5),
                              // child: Divider(
                              //   height: 1.0,
                              //   thickness: 1.0,
                              //   indent: 15.0,
                              //   endIndent: 15.0,
                              //   // color: kDividerColor,
                              // ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              height: 50.0,
                              width: 140,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    side: BorderSide(
                                        color: Color.fromRGBO(0, 160, 227, 1))),
                                onPressed: () {},
                                padding: EdgeInsets.all(10.0),
                                color: Color.fromRGBO(0, 160, 227, 1),
                                textColor: Colors.white,
                                child: Text("Play",
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              height: 50.0,
                              width: 140,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    side: BorderSide(color: Colors.pink[600])),
                                // color: Color.fromRGBO(0, 160, 227, 1))),
                                onPressed: () {
                                  model.kirim(context, widget.blue);
                                },
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
                ),
              ),
            );
          });
    });
  }
}
