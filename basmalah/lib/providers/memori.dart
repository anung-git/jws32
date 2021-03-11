import 'package:shared_preferences/shared_preferences.dart';

// cara penggunaan
// emori eprom = new Memori() ;
// untuk mengambil data harus pakai async await
// int vb = await eprom.getIntValues('counter');
// untuk menulis jg harus pakai async await
// await eprom.addInt('ctr', _counter );
SharedPreferences prefs;

class Memori {
  Future<void> setBool(String key, bool value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<void> setInt(String key, int value) async {
    // print('menulis int dg key = $key dan value = $value');
    prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<void> setDouble(String key, double value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  Future setString(String key, String value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
  //=================================================================

  Future<String> getString(String key) async {
    prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(key) ?? '';
    return stringValue;
  }

  Future<bool> getBool(String key) async {
    prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool(key) ?? false;
    return boolValue;
  }

  Future<int> getInt(String key) async {
    // print('mengambil int dg key = $key');
    prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt(key) ?? 0;
    // if (prefs.containsKey(key)) {
    //   intValue = prefs.getInt(key) ?? 0;
    // } else {
    //   intValue = 0;
    // }
    return intValue;
  }

  getDouble(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    double doubleValue = prefs.getDouble(key) ?? 0.0;
    return doubleValue;
  }
}
