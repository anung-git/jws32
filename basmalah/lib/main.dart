import 'package:basmalah/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:random_color_scheme/random_color_scheme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basmalah JWS',
      theme: ThemeData(
        // colorScheme: randomColorSchemeLight(),
        colorScheme: randomColorSchemeDark(),
        // colorScheme: randomColorScheme(),
        // primarySwatch: Colors.blue,
      ),
      home: Home(title: 'Basmalah JWS'),
    );
  }
}
