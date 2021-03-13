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
  Future<TimeOfDay> setJam(var contex, TimeOfDay initTime) async {
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

  Future<int> _setBrightnes(int init) async {
    // <-- note the async keyword here

    // this will contain the result from Navigator.pop(context, result)
    final selectedBrightnes = await showDialog<int>(
      context: context,
      builder: (context) => BrightnesPickerDialog(initialBrighnes: init),
    );

    return selectedBrightnes;
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
                                    GestureDetector(
                                      onTap: () async {
                                        TimeOfDay init = model.getInit(index);
                                        TimeOfDay waktu =
                                            await setJam(context, init);
                                        model.save(index, waktu);
                                      },
                                      child: Row(
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
                                    ),
                                    VerticalDivider(
                                      thickness: 3,
                                      color: Colors.grey,
                                      indent: 7,
                                      endIndent: 7,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        int hasil = await _setBrightnes(
                                            model.brightnes(index));

                                        await model.setBrightnes(index, hasil);
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
class BrightnesPickerDialog extends StatefulWidget {
  /// initial selection for the slider
  final int initialBrighnes;

  const BrightnesPickerDialog({Key key, this.initialBrighnes})
      : super(key: key);

  @override
  _BrightnesPickerDialogState createState() => _BrightnesPickerDialogState();
}

class _BrightnesPickerDialogState extends State<BrightnesPickerDialog> {
  /// current selection of the slider
  double _brightnes;

  @override
  void initState() {
    super.initState();
    _brightnes = widget.initialBrighnes.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      titlePadding: EdgeInsets.only(bottom: 10, top: 5),
      // actionsOverflowDirection: MainAxisAlignment.spaceBetween,
      // buttonPadding: ,
      title: Center(child: Text('Kecerahan = ${_brightnes.toInt()}')),
      content: Container(
        height: 20,
        child: Slider(
          value: _brightnes,
          min: 0,
          max: 7,
          divisions: 7,
          onChanged: (value) {
            setState(() {
              _brightnes = value;
            });
          },
        ),
      ),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () {
            // Use the second argument of Navigator.pop(...) to pass
            // back a result to the page that opened the dialog
            Navigator.pop(context, widget.initialBrighnes);
          },
          child: Text('Batal'),
        ),
        SizedBox(
          width: 5,
        ),
        OutlinedButton(
          onPressed: () {
            // Use the second argument of Navigator.pop(...) to pass
            // back a result to the page that opened the dialog
            Navigator.pop(context, _brightnes.toInt());
          },
          child: Text('Selesai'),
        )
      ],
    );
  }
}
