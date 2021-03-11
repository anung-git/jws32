import 'dart:ui';

import 'package:basmalah/providers/set_fix_view_model.dart';
import 'package:basmalah/services/btHelper.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SetFix extends StatefulWidget {
  SetFix({Key key, this.blue}) : super(key: key);
  final BluetoothDriver blue;
  @override
  _SetFixState createState() => _SetFixState();
}

//seting sesuai init terahir
// bila null return terahir

class _SetFixState extends State<SetFix> {
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
      return ViewModelBuilder<SetFixViewModel>.reactive(
          viewModelBuilder: () => SetFixViewModel(),
          onModelReady: (model) => model.init(widget.blue),
          builder: (context, model, chaild) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: model.warnaAppBar,
                centerTitle: true,
                title: Text(
                  'Fix Jadwal',
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
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 15, bottom: 10),
                          child: Center(
                            child: Text(
                              "Pengaturan Fix Jadwal",
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
                                        Container(
                                          width: 20,
                                        ),
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
                                        Switch(
                                            value: model.flag[index],
                                            onChanged: (bool value) async {
                                              await model.enable(index, value);
                                              // print(value);
                                            }),
                                        VerticalDivider(
                                          thickness: 3,
                                          color: Colors.grey,
                                          indent: 7,
                                          endIndent: 7,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            TimeOfDay init =
                                                model.getInit(index);
                                            TimeOfDay waktu =
                                                await setJamx(context, init);
                                            model.save(index, waktu);
                                          },
                                          child: Text(
                                            model.fix[index],
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
                  ),
                ),
              ),
            );
          });
    });
  }
}
