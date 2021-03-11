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
        // backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text(
            //   "What is this new classroom?",
            // ),
            SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: Form(
                child:
                    ListView(padding: EdgeInsets.all(8.0), children: <Widget>[
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        minLines: 20, //Normal textInputField will be displayed
                        maxLines: 21,
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 30.0,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            if (textcontroller1.text.isNotEmpty) {}
                            widget.blue
                                .setting(context, "%S", textcontroller1.text);
                          },
                          child: Text("Kirim"),
                          // style: ButtonStyle(backgroundColor: Colors.black),
                        )
                      ],
                    ),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
