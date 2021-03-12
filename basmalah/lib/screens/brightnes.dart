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

  void _showFontSizePickerDialog() async {
    // <-- note the async keyword here

    // this will contain the result from Navigator.pop(context, result)
    final selectedFontSize = await showDialog<double>(
      context: context,
      builder: (context) => FontSizePickerDialog(initialFontSize: 10),
    );

    // execution of this code continues when the dialog was closed (popped)

    // note that the result can also be null, so check it
    // (back button or pressed outside of the dialog)
    if (selectedFontSize != null) {
      setState(() {
        // _fontSize = selectedFontSize;
      });
    }
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
                                        _showFontSizePickerDialog();
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              height: 50.0,
                              width: 130,
                              child: TextButton(
                                  child: Text("Batal",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        // fontWeight: FontWeight.bold,
                                      )),
                                  style: ButtonStyle(
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              EdgeInsets.all(15)),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.orange),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.pink),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero,
                                              side:
                                                  BorderSide(color: Colors.red)))),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              // TextButton(
                              //     onPressed: () {},
                              //     child: Text(
                              //       'Text Button',
                              //     ),
                              //     style: ButtonStyle(
                              //         side: MaterialStateProperty.all(
                              //             BorderSide(
                              //                 width: 2, color: Colors.red)),
                              //         backgroundColor:
                              //             MaterialStateProperty.all(
                              //                 Colors.pink),
                              //         foregroundColor:
                              //             MaterialStateProperty.all(
                              //                 Colors.purple),
                              //         // padding: MaterialStateProperty.all(
                              //         //     EdgeInsets.symmetric(
                              //         //         vertical: 10, horizontal: 50)),
                              //         textStyle: MaterialStateProperty.all(
                              //             TextStyle(fontSize: 20)))),

                              // RaisedButton(
                              //   shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(0.0),
                              //       side: BorderSide(
                              //           color: Color.fromRGBO(0, 160, 227, 1))),
                              //   onPressed: () {},
                              //   padding: EdgeInsets.all(10.0),
                              //   color: Color.fromRGBO(0, 160, 227, 1),
                              //   textColor: Colors.white,
                              //   child: Text("Batal",
                              //       style: TextStyle(fontSize: 20)),
                              // ),
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
                ),
              ),
            );
          });
    });
  }
}

// move the dialog into it's own stateful widget.
// It's completely independent from your page
// this is good practice
class FontSizePickerDialog extends StatefulWidget {
  /// initial selection for the slider
  final double initialFontSize;

  const FontSizePickerDialog({Key key, this.initialFontSize}) : super(key: key);

  @override
  _FontSizePickerDialogState createState() => _FontSizePickerDialogState();
}

class _FontSizePickerDialogState extends State<FontSizePickerDialog> {
  /// current selection of the slider
  double _fontSize;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Font Size'),
      content: Container(
        child: Slider(
          value: _fontSize,
          min: 0,
          max: 7,
          divisions: 1,
          onChanged: (value) {
            setState(() {
              _fontSize = value;
            });
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            // Use the second argument of Navigator.pop(...) to pass
            // back a result to the page that opened the dialog
            Navigator.pop(context, _fontSize);
          },
          child: Text('DONE'),
        )
      ],
    );
  }
}
