import 'package:basmalah/providers/memori.dart';
import 'package:basmalah/services/btHelper.dart';
import 'package:flutter/material.dart';

class RunningText extends StatefulWidget {
  RunningText({Key key, this.blue}) : super(key: key);

  final BluetoothDriver blue;

  @override
  _RunningTextState createState() => _RunningTextState();
}

class _RunningTextState extends State<RunningText> {
  final textcontroller1 = TextEditingController();
  Memori _eprom = new Memori();

  @override
  void initState() {
    loaddata();
    textcontroller1.addListener(_savetext1);
    super.initState();
  }

  loaddata() async {
    String _text1 = await _eprom.getString('text1');
    setState(() {
      textcontroller1.text = _text1;
    });
  }

  _savetext1() async => await _eprom.setString('text1', textcontroller1.text);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('running text'),
      ),
      body: Container(
        color: Colors.pink[100],
        padding: EdgeInsets.all(10),
        child: Card(
          child: Container(
            margin: EdgeInsets.only(left: 3, right: 3, bottom: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: 15,
                  ),
                  child: Center(
                    child: Text(
                      "Pengaturan Text",
                      style: TextStyle(
                          color: Colors.purpleAccent,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Divider(
                    color: Colors.redAccent[400],
                    thickness: 3,
                  ),
                ),
                Expanded(
                  child: Form(
                    child: ListView(padding: EdgeInsets.all(8.0), children: <
                        Widget>[
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            maxLines: 15,
                            maxLength: 500,
                            controller: textcontroller1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Running Text",
                              hintText: "tulis text di sini",
                            ),
                          )),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              height: 50.0,
                              width: 125,
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
                              width: 125,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    side: BorderSide(color: Colors.pink[600])),
                                // color: Color.fromRGBO(0, 160, 227, 1))),
                                onPressed: () {
                                  if (textcontroller1.text.isNotEmpty) {}
                                  widget.blue.setting(
                                      context, "%S", textcontroller1.text);
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
                      )
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
