import 'package:basmalah/providers/koreksi_jadwal_view_model.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import '../services/btHelper.dart';

class KoreksiJadwal extends StatefulWidget {
  KoreksiJadwal({Key key, this.blue}) : super(key: key);
  final BluetoothDriver blue;
  @override
  _KoreksiJadwalState createState() => _KoreksiJadwalState();
}

class _KoreksiJadwalState extends State<KoreksiJadwal> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<KoreksiJadwalViewModel>.reactive(
        viewModelBuilder: () => KoreksiJadwalViewModel(),
        onModelReady: (model) => model.init(widget.blue),
        builder: (context, model, chaild) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: model.warnaAppBar,
              centerTitle: true,
              title: Text(
                'Koreksi Jadwal',
                // style: kTextStyleBold,
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.restore_outlined,
                      color: Colors.orangeAccent,
                    ),
                    onPressed: () => model.restore())
              ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 15, bottom: 10),
                        child: Center(
                          child: Text(
                            "Pengaturan Koreksi Jadwal",
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
                              height: 60,
                              color: index.isOdd
                                  ? model.warnaOdd
                                  : model.warnaEvent,
                              // height: 55,
                              child: Row(
                                // mainAxisSize: MainAxisAlignment.spaceAround,
                                //Ini di pakai
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
                                      VerticalDivider(
                                        // width: 10,
                                        thickness: 3,
                                        color: Colors.grey,
                                        indent: 7,
                                        endIndent: 7,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          // color: Color.fromRGBO(46, 54, 143, 1),
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        // splashColor: Colors.black12,
                                        // highlightColor: Colors.black12,
                                        onPressed: () {
                                          model.decr(index);
                                        },
                                      ),
                                      Text(
                                        model.value[index].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.grey[700]),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.green,
                                          // color: Color.fromRGBO(46, 54, 143, 1),
                                          size: 20,
                                        ),
                                        splashColor: Colors.black12,
                                        highlightColor: Colors.black12,
                                        onPressed: () {
                                          model.incr(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // ),
                            );
                          },
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.5),
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
  }
}
