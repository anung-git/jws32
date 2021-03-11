import 'dart:ui';

// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basmalah/providers/brightnes_view_model.dart';
import 'package:basmalah/services/btHelper.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Brightnes extends StatefulWidget {
  Brightnes({Key key, this.blue}) : super(key: key);
  final BluetoothDriver blue;
  @override
  _BrightnesState createState() => _BrightnesState();
}

class _BrightnesState extends State<Brightnes> {
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

  // showAlertDialog(BuildContext context) {
  //   // set up the button
  //   Widget okButton = FlatButton(
  //     child: Text("OK"),
  //     onPressed: () {},
  //   );

  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("My title"),
  //     content: Text("This is my message."),
  //     actions: [
  //       okButton,
  //     ],
  //   );

  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  _showAlertDialog(BuildContext context, int initVal) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {},
    );
    Widget continueButton = ElevatedButton(
      child: Text("Continue"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Column(
        children: [
          Text(
            "Kecerahan",
            style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
          Slider(
              max: 7,
              min: 0,
              divisions: 1,
              value: initVal.toDouble(),
              onChanged: (value) {
                setState(() {
                  initVal = value.toInt();
                });
              }),
          // Text(initVal.toString())
        ],
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return ViewModelBuilder<BrightnesViewModel>.reactive(
          viewModelBuilder: () => BrightnesViewModel(),
          onModelReady: (model) => model.init(widget.blue),
          builder: (context, model, chaild) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: model.warnaAppBar,
                centerTitle: true,
                title: Text(
                  'Kecerahan',
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
                              "Pengaturan Kecerahan",
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
                            itemCount: 4, //_treatments.length,
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
                                        Icon(
                                          Icons.access_time,
                                          size: 35,
                                          color: Colors.orange[900],
                                        ),
                                        Container(
                                          width: 10,
                                        ),
                                        Text(
                                          model.jam[index],
                                          style: TextStyle(
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                    VerticalDivider(
                                      thickness: 3,
                                      color: Colors.grey,
                                      indent: 7,
                                      endIndent: 7,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        // AwesomeDialog(
                                        //     context: context,
                                        //     headerAnimationLoop: false,
                                        //     // body:
                                        //     dialogType: DialogType.NO_HEADER,
                                        //     // title: 'Sinkron waktu',
                                        //     // desc:
                                        //     //     'Samakan waktu di perangkat dengan waktu di android',
                                        //     btnOkOnPress: () {
                                        //       // model.updateTime(context);
                                        //     },
                                        //     btnCancelOnPress: () {
                                        //       print("Cancel");
                                        //     }).show();
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.brightness_4_outlined,
                                            size: 35,
                                            color: Colors.lightBlue,
                                          ),
                                          Container(
                                            width: 10,
                                          ),
                                          Text(
                                            model.bright[index].toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.grey[700]),
                                          ),
                                          Container(
                                            width: 20,
                                          ),
                                        ],
                                      ),
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
